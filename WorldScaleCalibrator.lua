local mapCoordinateData = {}
local mapCoordinateDataMatrix = {}
local dataForm = nil
local worldMap = ZO_WorldMap
local getMapPlayerPosition = GetMapPlayerPosition
local getUnitWorldPosition = GetUnitWorldPosition
local getUnitRawWorldPosition = GetUnitRawWorldPosition
local getCurrentMapId = GetCurrentMapId
local zoDistance = zo_distance
local latestMapId = 0
local ScaleData = {
    px = 0,
    py = 0
}

-- Auto-save triggers once both explored diagonals reach this fraction of the full map diagonal
local FULL_MAP_DIAGONAL = zoDistance(0, 0, 1, 1)
local MIN_DIAGONAL_COVERAGE = 0.5

-- Maps excluded from calibration and simulation (mapId -> name, name is just for reference)
local SKIPPED_MAPS = {
    [27] = "Tamriel",
    [439] = "The Aurubis"
}

local function isSkippedMap(mapId)
    return SKIPPED_MAPS[mapId] ~= nil
end

local function checkMapIdUpdated(mapId)
    if latestMapId ~= mapId then
        local isCalibrated =
            MapRadarAutoscaled[mapId] ~= nil or MapRadarZoneData[mapId] ~= nil or
            MapRadar.accountData.worldScaleData[mapId] ~= nil
        dataForm:SetColor(1, 1, isCalibrated and 1 or 0, 1)

        if dataForm.autoscaleLabel then
            local isAutoscaled = MapRadarAutoscaled[mapId] ~= nil
            local isInSavedVars = MapRadar.accountData.worldScaleData[mapId] ~= nil
            local showLabel = isAutoscaled or not isInSavedVars
            dataForm.autoscaleLabel:SetHidden(not showLabel)
            dataForm.autoscaleLabel:SetColor(1, 1, isAutoscaled and 1 or 0, 1)
        end

        if (mapCoordinateData[mapId] == nil) then
            mapCoordinateData[mapId] = {
                name = worldMap.zoneName,
                positions = {},
                count = 0
            }
            mapCoordinateDataMatrix[mapId] = {}
        end
    end

    latestMapId = mapId
end

local function GetPositionsWithSinglePointCoefficientCalculation(positions)
    local result = {}

    local first = positions[1]

    for i = 2, #positions do
        local mapPos = positions[i]

        local mapDistance = zoDistance(mapPos.mapX, mapPos.mapY, first.mapX, first.mapY)
        local worldDistance = zoDistance(mapPos.worldX, mapPos.worldY, first.worldX, first.worldY) / 100
        mapPos.meterCoefficient = mapDistance / worldDistance
        table.insert(result, mapPos)
    end

    return result
end

local function GroupByCoefficient(positions, delta)
    -- Sort by coefficient for fast linear grouping
    table.sort(
        positions,
        function(a, b)
            return a.meterCoefficient < b.meterCoefficient
        end
    )

    local groups = {}
    local current = {positions[1]}

    for i = 2, #positions do
        local p = positions[i]

        -- Compare to last element in current group
        if math.abs(p.meterCoefficient - current[#current].meterCoefficient) <= delta then
            table.insert(current, p)
        else
            table.insert(groups, current)
            current = {p}
        end
    end

    table.insert(groups, current)
    return groups
end

local function CalculateGroupCoefficient(points, minMapDist, useTopN)
    minMapDist = minMapDist or 0.001
    useTopN = useTopN or 10 -- longest 10 baselines

    local baselines = {}

    -- Compute all pairwise distances
    for i = 1, #points do
        for j = i + 1, #points do
            local a, b = points[i], points[j]

            local mapDist = zoDistance(a.mapX, a.mapY, b.mapX, b.mapY)
            if mapDist >= minMapDist then
                local worldDist = zoDistance(a.worldX, a.worldY, b.worldX, b.worldY)

                table.insert(
                    baselines,
                    {
                        map = mapDist,
                        world = worldDist
                    }
                )
            end
        end
    end

    -- Sort by map distance (longest first)
    table.sort(
        baselines,
        function(a, b)
            return a.map > b.map
        end
    )

    -- Keep only the longest N
    if useTopN and #baselines > useTopN then
        while #baselines > useTopN do
            table.remove(baselines)
        end
    end

    -- Weighted coefficient
    local sumMap, sumWorld = 0, 0
    for _, b in ipairs(baselines) do
        sumMap = sumMap + b.map
        sumWorld = sumWorld + b.world
    end

    if sumMap == 0 then
        return nil
    end
    return sumWorld / sumMap
end

local function CalculateGroupCoefficients(mapCoefficientGroups)
    local groupCoefficients = {}

    for _, coefficientGroup in pairs(mapCoefficientGroups) do
        local coefficient = CalculateGroupCoefficient(coefficientGroup)

        if coefficient ~= nil then
            table.insert(groupCoefficients, {meterCoefficient = coefficient})
        end
    end

    return groupCoefficients
end

local function EvaluateClusters(clusters)
    -- Calculate weighted average coefficient per cluster
    local clusterData = {}
    local totalPoints = 0

    for _, cluster in ipairs(clusters) do
        local sum = 0
        for _, v in ipairs(cluster) do
            sum = sum + v.meterCoefficient
        end
        table.insert(
            clusterData,
            {
                average = sum / #cluster,
                size = #cluster
            }
        )
        totalPoints = totalPoints + #cluster
    end

    -- Single cluster - straightforward
    if #clusterData == 1 then
        return clusterData[1].average
    end

    -- Sort by size descending to find dominant cluster
    table.sort(
        clusterData,
        function(a, b)
            return a.size > b.size
        end
    )

    local dominant = clusterData[1]

    -- If dominant cluster holds majority, check for outliers
    if dominant.size > totalPoints / 2 then
        local inliers = {dominant}
        local outlierCount = 0

        for i = 2, #clusterData do
            local relDev = math.abs(clusterData[i].average - dominant.average) / dominant.average
            if relDev > 0.15 then
                outlierCount = outlierCount + 1
                MapRadar.debug(
                    "[EvaluateClusters] Dropping outlier cluster (dev: <<1>>%)",
                    string.format("%.1f", relDev * 100)
                )
            else
                table.insert(inliers, clusterData[i])
            end
        end

        if outlierCount > 0 then
            local weightedSum, weightedCount = 0, 0
            for _, c in ipairs(inliers) do
                weightedSum = weightedSum + c.average * c.size
                weightedCount = weightedCount + c.size
            end
            return weightedSum / weightedCount
        end
    end

    -- No clear dominant or no outliers - check max pairwise deviation
    local maxDev = 0
    for i = 1, #clusterData do
        for j = i + 1, #clusterData do
            local mean = (clusterData[i].average + clusterData[j].average) / 2
            local relDev = math.abs(clusterData[i].average - clusterData[j].average) / mean
            if relDev > maxDev then
                maxDev = relDev
            end
        end
    end

    -- All clusters deviate too much - skip zone entirely
    if maxDev > 0.25 then
        MapRadar.debug(
            "[EvaluateClusters] Zone skipped: clusters deviate too much (max <<1>>%)",
            string.format("%.1f", maxDev * 100)
        )
        return nil
    end

    -- Moderate deviation - complicated zone with scaling, average all weighted by size
    MapRadar.debug(
        "[EvaluateClusters] Complicated zone (<<1>> clusters, max dev <<2>>%), using weighted average",
        #clusterData,
        string.format("%.1f", maxDev * 100)
    )
    local weightedSum = 0
    for _, c in ipairs(clusterData) do
        weightedSum = weightedSum + c.average * c.size
    end
    return weightedSum / totalPoints
end

local function CalculateMapCoefficient(mapData)
    if #mapData.positions < 3 then
        return nil
    end

    -- Calculate distance coefficient from single map point to all positions
    local positionsWithSinglePointCoefficient = GetPositionsWithSinglePointCoefficientCalculation(mapData.positions)

    -- Group positions by coefficients with some error delta
    local mapCoefficientGroups = GroupByCoefficient(positionsWithSinglePointCoefficient, 0.01)

    -- Average coefficients per group using pairwise baselines
    local groupCoefficients = CalculateGroupCoefficients(mapCoefficientGroups)

    if #groupCoefficients == 0 then
        return nil
    end

    -- Cluster group coefficients and evaluate
    local coefficientClusters = GroupByCoefficient(groupCoefficients, 0.01)
    return EvaluateClusters(coefficientClusters)
end

-- Diagnostic: runs the same clustering pipeline as CalculateMapCoefficient but,
-- instead of collapsing to a single coefficient, returns every cluster with its
-- average coefficient and member count. Returns nil when there is not enough data.
local function ComputeMapClusters(mapData)
    if mapData.positions == nil or #mapData.positions < 3 then
        return nil
    end

    local positionsWithSinglePointCoefficient = GetPositionsWithSinglePointCoefficientCalculation(mapData.positions)
    local mapCoefficientGroups = GroupByCoefficient(positionsWithSinglePointCoefficient, 0.01)
    local groupCoefficients = CalculateGroupCoefficients(mapCoefficientGroups)

    if #groupCoefficients == 0 then
        return nil
    end

    local coefficientClusters = GroupByCoefficient(groupCoefficients, 0.01)

    local clusterData = {}
    for _, cluster in ipairs(coefficientClusters) do
        local sum = 0
        for _, v in ipairs(cluster) do
            sum = sum + v.meterCoefficient
        end
        table.insert(
            clusterData,
            {
                average = sum / #cluster,
                size = #cluster
            }
        )
    end

    return clusterData
end

local function SaveMapScaleCoefficient(mapId, finalCoefficient)
    local map1meterCoefficient = 100 / finalCoefficient

    if MapRadar.config.calibrationSimulation then
        MapRadar.accountData.worldScaleDataSimulated[mapId] = map1meterCoefficient
        MapRadar.debug("[Calibrator] Saved simulated coefficient for map <<1>>", mapId)
    else
        MapRadar.accountData.worldScaleData[mapId] = map1meterCoefficient
        MapRadar.debug("[Calibrator] Saved coefficient for map <<1>>", mapId)
    end

    -- Coefficient resolved, so any stored raw data kept for recalc attempts is no longer needed
    if MapRadar.accountData.worldScaleDataUnresolved[mapId] ~= nil then
        MapRadar.accountData.worldScaleDataUnresolved[mapId] = nil
    end
end

local function autoSave(mapId)
    local mapData = mapCoordinateData[mapId]
    if mapData == nil or mapData.saved then
        return
    end

    local finalCoefficient = CalculateMapCoefficient(mapData)
    if finalCoefficient == nil then
        return
    end

    SaveMapScaleCoefficient(mapId, finalCoefficient)

    -- Flag prevents re-saving while the player keeps roaming the same map
    mapData.saved = true

    -- Map is resolved, so drop its live row from the on-screen counter
    dataForm.counterList:RemoveCounter(mapId)
end

local function calcAndSaveDistances()
    for index, mapData in pairs(mapCoordinateData) do
        local finalCoefficient = CalculateMapCoefficient(mapData)

        if finalCoefficient ~= nil then
            SaveMapScaleCoefficient(index, finalCoefficient)
        else
            MapRadar.debug(
                "[calcAndSaveDistances] Skipped map <<1>> (<<2>>) due to insufficient/inconsistent data",
                index,
                zo_strformat("<<1>>", GetMapNameById(index))
            )

            -- Persist the raw position data so the map can be re-analyzed / recalculated later.
            -- Merge into any existing record so points from earlier failed gathers accumulate.
            local stored = MapRadar.accountData.worldScaleDataUnresolved[index]
            if stored == nil then
                stored = {
                    name = mapData.name,
                    count = 0,
                    positions = {}
                }
                MapRadar.accountData.worldScaleDataUnresolved[index] = stored
            end

            -- Keep the most recent known name
            if mapData.name ~= nil and mapData.name ~= "" then
                stored.name = mapData.name
            end

            -- Append the freshly gathered positions
            for _, pos in pairs(mapData.positions) do
                table.insert(
                    stored.positions,
                    {
                        mapX = pos.mapX,
                        mapY = pos.mapY,
                        worldX = pos.worldX,
                        worldY = pos.worldY
                    }
                )
            end
            stored.count = #stored.positions

            -- Expand the explored bounding box to cover both old and new points
            if mapData.left ~= nil and (stored.left == nil or mapData.left < stored.left) then
                stored.left = mapData.left
            end
            if mapData.right ~= nil and (stored.right == nil or mapData.right > stored.right) then
                stored.right = mapData.right
            end
            if mapData.top ~= nil and (stored.top == nil or mapData.top < stored.top) then
                stored.top = mapData.top
            end
            if mapData.bottom ~= nil and (stored.bottom == nil or mapData.bottom > stored.bottom) then
                stored.bottom = mapData.bottom
            end
        end

        -- Cleaning position table data
        for i, pos in pairs(mapData.positions) do
            mapData.positions[i] = nil
        end
        mapCoordinateData[index] = nil
    end

    -- Clear counter data from UI
    dataForm.counterList:Clear()

    latestMapId = 0
    checkMapIdUpdated(getCurrentMapId())
end

local function readPlayerData()
    local playerX, playerY, heading, isShownInCurrentMap = getMapPlayerPosition("player")
    if not isShownInCurrentMap then
        return
    end

    local zoneId, wx, wy, wz = getUnitWorldPosition("player")
    local zoneId, rwx, rwy, rwz = getUnitRawWorldPosition("player")

    ScaleData.px = playerX
    ScaleData.py = playerY

    ScaleData.wx = wx
    ScaleData.wy = wy
    ScaleData.wz = wz

    ScaleData.rwx = rwx -- Longitude
    ScaleData.rwy = rwy -- Elevation
    ScaleData.rwz = rwz -- Latitude
end

local function CreateCalibrationDataForm()
    dataForm = MapRadarCommon.DataForm:New("WorldCalibrateDataForm", MapRadarContainer)
    dataForm:SetAnchor(LEFT, GuiRoot, LEFT, 150, 150)

    dataForm:AddLabel(
        "MapId",
        function()
            local mapId = getCurrentMapId()
            checkMapIdUpdated(mapId)
            return mapId
        end
    )

    dataForm:AddLabel(
        "Active zone",
        function()
            return GetPlayerActiveZoneName()
        end
    )

    dataForm:AddLabel(
        "Zone",
        function()
            return worldMap.zoneName
        end
    )
    dataForm:AddLabel(
        "Rel PX",
        function()
            return ScaleData.px
        end
    )
    dataForm:AddLabel(
        "Rel PY",
        function()
            return ScaleData.py
        end
    )

    dataForm:AddLabel(
        "World (X/Z/Y)",
        function()
            return zo_strformat("<<1>>  <<2>>  <<3>>", ScaleData.wx, ScaleData.wz, ScaleData.wy)
        end
    )

    dataForm:AddLabel(
        "Raw World (X/Z/Y)",
        function()
            return zo_strformat("<<1>>  <<2>>  <<3>>", ScaleData.rwx, ScaleData.rwz, ScaleData.rwy)
        end
    )

    dataForm:AddLabel(
        "AUTOSCALE",
        function()
            return "AUTOSCALE"
        end
    )
    local autoscaleIndex = table.maxn(dataForm.labels)
    dataForm.autoscaleLabel = dataForm.labels[autoscaleIndex].control
    dataForm.autoscaleLabel:SetColor(1, 1, 0, 1)
    dataForm.autoscaleLabel:SetHidden(true)

    local btnSave = CreateControlFromVirtual("$(parent)btnSave", dataForm, "SavingEditBoxSaveButton")
    btnSave:SetDimensions(40, 40)
    btnSave:SetAnchor(TOPLEFT, dataForm, BOTTOMLEFT, 0, 10)
    btnSave:SetHandler(
        "OnClicked",
        function()
            calcAndSaveDistances()
        end
    )

    -- Counter list
    dataForm.counterList = MapRadarCommon.CounterList:New("WorldCalibrateCounterList", MapRadarContainer)
    dataForm.counterList:SetAnchor(TOP, GuiRoot, TOP, 550, 0)
end

local function RegisterMapCoordinateCollection()
    -- EVENT_MANAGER:UnregisterForUpdate("MapRadar_SaveMapCoordinates") -- TODO: Should unregister somewhere??
    EVENT_MANAGER:RegisterForUpdate(
        "MapRadar_SaveMapCoordinates",
        1000,
        function()
            local mapId = getCurrentMapId()

            local hasScaleData = MapRadarAutoscaled[mapId] ~= nil or MapRadar.accountData.worldScaleData[mapId] ~= nil
            local hasSimulatedScaleData = MapRadar.accountData.worldScaleDataSimulated[mapId] ~= nil
            if hasScaleData and (not MapRadar.config.calibrationSimulation or hasSimulatedScaleData) then
                return -- do not gather position data for world scaled maps
            end

            local mapX, mapY, heading, isShownInCurrentMap = getMapPlayerPosition("player")
            if not isShownInCurrentMap or isSkippedMap(mapId) then
                return
            end

            checkMapIdUpdated(mapId)

            if MapRadarZoneData[mapId] == nil and MapRadar.accountData.mapNameData[mapId] == nil then
                -- Need to save map name
                MapRadar.accountData.mapNameData[mapId] = worldMap.zoneName
            end

            local _, wx, _, wz = getUnitRawWorldPosition("player")
            -- local _, rwx, _, rwz = getUnitRawWorldPosition("player");

            -- Ensures that map positions are only saved in matrix by 10meters
            local xIndex = zo_floor(wx / 1000)
            local yIndex = zo_floor(wz / 1000)

            local mapMatrix = mapCoordinateDataMatrix[mapId]

            if (mapMatrix[xIndex] == nil) then
                mapMatrix[xIndex] = {}
            end

            if (mapMatrix[xIndex][yIndex] == nil) then
                mapMatrix[xIndex][yIndex] = true

                local mapData = mapCoordinateData[mapId]

                table.insert(
                    mapData.positions,
                    {
                        mapX = mapX,
                        mapY = mapY,
                        worldX = wx,
                        worldY = wz -- Z parameter is instead of Y because Y is elevation
                    }
                )

                -- Increase record counter for statistics
                mapData.count = mapData.count + 1

                -- Track the explored bounding box (normalized map coords; top = min Y, bottom = max Y)
                if mapData.left == nil or mapX < mapData.left then
                    mapData.left = mapX
                end
                if mapData.right == nil or mapX > mapData.right then
                    mapData.right = mapX
                end
                if mapData.top == nil or mapY < mapData.top then
                    mapData.top = mapY
                end
                if mapData.bottom == nil or mapY > mapData.bottom then
                    mapData.bottom = mapY
                end

                local name = zo_strformat("<<1>> (<<2>>)", worldMap.zoneName, mapId)
                dataForm.counterList:AddOrUpdateCounter(mapId, name, mapData.count)

                -- Auto-save once both explored diagonals cover enough of the map
                if not mapData.saved and mapData.count >= 3 then
                    local diagTopLeftToBottomRight =
                        zoDistance(mapData.left, mapData.top, mapData.right, mapData.bottom)
                    local diagBottomLeftToTopRight =
                        zoDistance(mapData.left, mapData.bottom, mapData.right, mapData.top)

                    if
                        diagTopLeftToBottomRight / FULL_MAP_DIAGONAL >= MIN_DIAGONAL_COVERAGE and
                            diagBottomLeftToTopRight / FULL_MAP_DIAGONAL >= MIN_DIAGONAL_COVERAGE
                     then
                        autoSave(mapId)
                    end
                end
            end
        end
    )
end

local function MapRadar_InitScaleCalibrator()
    CreateCalibrationDataForm()
    RegisterMapCoordinateCollection()
end

local function EnableOrDisableCalibrator()
    if (dataForm ~= nil and dataForm.SetHidden ~= nil) then
        dataForm:SetHidden(not MapRadar.config.showCalibrate)
    end

    if MapRadar.config.showCalibrate then
        EVENT_MANAGER:RegisterForUpdate(
            "MapRadar_WorldCalibrationData",
            100,
            function()
                readPlayerData()

                if (dataForm ~= nil) then
                    dataForm:Update()
                end
            end
        )

        latestMapId = 0
        checkMapIdUpdated(getCurrentMapId())
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_CalibrationData")
    end
end

-- ==================================================================================================
-- Simulation vs. original scale data deviation report
local reportList = nil

local REPORT_COLUMNS = {
    {title = "MapId", width = 60},
    {title = "Name", width = 320},
    {title = "Orig", width = 120},
    {title = "Auto", width = 120},
    {title = "Diff %", width = 80}
}

local function formatCoefficient(value)
    if value == nil then
        return "n/a"
    end
    return string.format("%.8f", value)
end

local function BuildScaleReportData()
    local rows = {}

    for mapId, simulatedValue in pairs(MapRadar.accountData.worldScaleDataSimulated) do
        -- Original value: user calibration takes precedence over built-in zone data
        local origValue = MapRadar.accountData.worldScaleData[mapId] or MapRadarZoneData[mapId]
        local name = zo_strformat("<<1>>", GetMapNameById(mapId))

        local diffStr = "n/a"
        local absDiff = -1 -- entries without a baseline sink to the bottom when sorted
        local color = {1, 1, 1}

        if origValue ~= nil and origValue ~= 0 then
            local diff = (simulatedValue - origValue) / origValue * 100
            diffStr = string.format("%+.1f%%", diff)
            absDiff = math.abs(diff)

            if absDiff < 5 then
                color = {0.4, 1, 0.4} -- green: close match
            elseif absDiff < 15 then
                color = {1, 0.85, 0.4} -- yellow: moderate deviation
            else
                color = {1, 0.45, 0.45} -- red: large deviation
            end
        end

        table.insert(
            rows,
            {
                mapId = mapId,
                absDiff = absDiff,
                color = color,
                values = {
                    tostring(mapId),
                    name,
                    formatCoefficient(origValue),
                    formatCoefficient(simulatedValue),
                    diffStr
                }
            }
        )
    end

    -- Worst deviations first
    table.sort(
        rows,
        function(a, b)
            return a.absDiff > b.absDiff
        end
    )

    return rows
end

-- Removes a single simulated calibration record and re-enables data gathering for that map
local function DeleteSimulatedRecord(mapId)
    MapRadar.accountData.worldScaleDataSimulated[mapId] = nil

    -- Drop any in-progress gathering data so collection starts clean for this map.
    -- Resetting latestMapId forces checkMapIdUpdated to re-initialize the table on the next tick.
    mapCoordinateData[mapId] = nil
    mapCoordinateDataMatrix[mapId] = nil
    latestMapId = 0

    MapRadar.debug("[ScaleReport] Deleted simulated calibration for map <<1>>; gathering re-enabled", mapId)

    -- Refresh the report so the deleted row disappears
    if reportList ~= nil and not reportList:IsHidden() then
        reportList:SetData(BuildScaleReportData())
    end
end

local SCALE_REPORT_DELETE_DIALOG = "MAPRADAR_DELETE_SIMULATED_SCALE"
ZO_Dialogs_RegisterCustomDialog(
    SCALE_REPORT_DELETE_DIALOG,
    {
        title = {text = "Delete Simulated Calibration"},
        mainText = {
            text = "Delete the simulated calibration record for <<1>> (<<2>>)?\n\nData collection will resume for this map."
        },
        buttons = {
            {
                text = SI_DIALOG_CONFIRM,
                callback = function(dialog)
                    DeleteSimulatedRecord(dialog.data.mapId)
                end
            },
            {
                text = SI_DIALOG_CANCEL
            }
        }
    }
)

local SCALE_REPORT_ROW_ACTION = {
    label = "Delete",
    width = 70,
    onClick = function(item)
        local name = zo_strformat("<<1>>", GetMapNameById(item.mapId))
        ZO_Dialogs_ShowDialog(SCALE_REPORT_DELETE_DIALOG, {mapId = item.mapId}, {mainTextParams = {name, item.mapId}})
    end
}

local function ToggleScaleReport()
    if reportList == nil then
        reportList =
            MapRadarCommon.ReportList:New(
            "ScaleReport",
            nil,
            "World Scale Simulation Report",
            REPORT_COLUMNS,
            20,
            SCALE_REPORT_ROW_ACTION
        )
        reportList:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
        -- Registering as a top level gives us cursor/mouse mode and ESC-to-close
        SCENE_MANAGER:RegisterTopLevel(reportList, false)
    end

    if not reportList:IsHidden() then
        SCENE_MANAGER:HideTopLevel(reportList)
        return
    end

    local rows = BuildScaleReportData()
    reportList:SetData(rows)
    SCENE_MANAGER:ShowTopLevel(reportList)
end

-- ==================================================================================================
-- Measurement clustering check: pick a map, inspect all of its coefficient clusters
local checkList = nil
local clusterList = nil

local CHECK_COLUMNS = {
    {title = "MapId", width = 60},
    {title = "Name", width = 340},
    {title = "Points", width = 70}
}

local CLUSTER_COLUMNS = {
    {title = "Cluster", width = 70},
    {title = "Avg Coeff", width = 140},
    {title = "1m Coeff", width = 140},
    {title = "Size", width = 60}
}

-- Gathers every map that still has raw position data to cluster: live in-memory
-- gathering data first, then persisted unresolved data for maps not currently loaded.
local function CollectCheckableMaps()
    local maps = {}

    for mapId, mapData in pairs(mapCoordinateData) do
        if mapData.positions ~= nil and #mapData.positions > 0 then
            maps[mapId] = mapData
        end
    end

    for mapId, mapData in pairs(MapRadar.accountData.worldScaleDataUnresolved) do
        if maps[mapId] == nil and mapData.positions ~= nil and #mapData.positions > 0 then
            maps[mapId] = mapData
        end
    end

    return maps
end

local function BuildCheckListData()
    local rows = {}

    for mapId, mapData in pairs(CollectCheckableMaps()) do
        local name = mapData.name
        if name == nil or name == "" then
            name = zo_strformat("<<1>>", GetMapNameById(mapId))
        end

        table.insert(
            rows,
            {
                mapId = mapId,
                values = {
                    tostring(mapId),
                    name,
                    tostring(#mapData.positions)
                }
            }
        )
    end

    table.sort(
        rows,
        function(a, b)
            return a.mapId < b.mapId
        end
    )

    return rows
end

local function BuildClusterReportData(mapId)
    local rows = {}

    local mapData = CollectCheckableMaps()[mapId]
    if mapData == nil then
        return rows
    end

    local clusters = ComputeMapClusters(mapData)
    if clusters == nil then
        return rows
    end

    -- Largest clusters first
    table.sort(
        clusters,
        function(a, b)
            return a.size > b.size
        end
    )

    for i, c in ipairs(clusters) do
        table.insert(
            rows,
            {
                values = {
                    tostring(i),
                    string.format("%.8f", c.average),
                    string.format("%.8f", 100 / c.average),
                    tostring(c.size)
                }
            }
        )
    end

    return rows
end

local function ShowClusterReport(mapId)
    if clusterList == nil then
        clusterList = MapRadarCommon.ReportList:New("CheckClusters", nil, "Measurement Clusters", CLUSTER_COLUMNS, 20)
        clusterList:SetAnchor(CENTER, GuiRoot, CENTER, 250, 0)
        SCENE_MANAGER:RegisterTopLevel(clusterList, false)
    end

    local name = zo_strformat("<<1>>", GetMapNameById(mapId))
    clusterList:SetTitle(zo_strformat("Clusters: <<1>> (<<2>>)", name, mapId))

    local rows = BuildClusterReportData(mapId)
    clusterList:SetData(rows)
    SCENE_MANAGER:ShowTopLevel(clusterList)

    MapRadar.debug("[Check] Map <<1>>: <<2>> cluster(s)", mapId, tostring(#rows))
end

local CHECK_ROW_ACTION = {
    label = "Check",
    width = 70,
    onClick = function(item)
        ShowClusterReport(item.mapId)
    end
}

local function ToggleCheckReport()
    if checkList == nil then
        checkList =
            MapRadarCommon.ReportList:New("Check", nil, "Measurement Check", CHECK_COLUMNS, 20, CHECK_ROW_ACTION)
        checkList:SetAnchor(CENTER, GuiRoot, CENTER, -250, 0)
        SCENE_MANAGER:RegisterTopLevel(checkList, false)
    end

    if not checkList:IsHidden() then
        SCENE_MANAGER:HideTopLevel(checkList)
        if clusterList ~= nil and not clusterList:IsHidden() then
            SCENE_MANAGER:HideTopLevel(clusterList)
        end
        return
    end

    local rows = BuildCheckListData()
    checkList:SetData(rows)
    SCENE_MANAGER:ShowTopLevel(checkList)
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized",
    function()
        if MapRadar.accountData.worldScaleData == nil then
            MapRadar.accountData.worldScaleData = {}
        end

        if MapRadar.accountData.worldScaleDataSimulated == nil then
            MapRadar.accountData.worldScaleDataSimulated = {}
        end

        -- Raw position data for maps whose coefficient could not be resolved,
        -- kept for further analysis and recalc attempts
        if MapRadar.accountData.worldScaleDataUnresolved == nil then
            MapRadar.accountData.worldScaleDataUnresolved = {}
        end

        if MapRadar.accountData.mapNameData == nil then
            MapRadar.accountData.mapNameData = {}
        end

        if MapRadar.config.showCalibrate then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end
)

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarSlashCommand",
    function(args)
        if (args == "reset") then
            dataForm.counterList:Clear()
        end

        if (args == "report") then
            ToggleScaleReport()
        end

        if (args == "check") then
            ToggleCheckReport()
        end

        if MapRadar.config.showCalibrate and dataForm == nil then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end
)
