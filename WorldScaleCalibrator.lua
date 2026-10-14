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

-- Auto-save triggers once the explored path spans this fraction of either full map diagonal
local MIN_DIAGONAL_COVERAGE = 0.5

-- Relative gap (2%) between sorted coefficients that starts a new group / cluster
local CLUSTER_TOLERANCE = 0.02

-- Points kept per direction (8 directions) as baseline candidates, so pairing stays cheap on big maps
local EDGE_CANDIDATES_PER_DIRECTION = 10

-- Max relative deviation (2%) of a single baseline's coefficient from the median of all chosen baselines
local BASELINE_TOLERANCE = 0.02

-- Maps excluded from calibration and simulation (mapId -> name, name is just for reference)
local SKIPPED_MAPS = {
    [27] = "Tamriel",
    [439] = "The Aurubis"
}

local function isSkippedMap(mapId)
    return SKIPPED_MAPS[mapId] ~= nil
end

-- Adds a point to the live map data unless its 10 m cell already has one; returns true when added
local function AddPosition(mapId, mapX, mapY, worldX, worldY)
    local mapMatrix = mapCoordinateDataMatrix[mapId]

    -- Ensures that map positions are only saved in matrix by 10meters
    local xIndex = zo_floor(worldX / 1000)
    local yIndex = zo_floor(worldY / 1000)

    if (mapMatrix[xIndex] == nil) then
        mapMatrix[xIndex] = {}
    end

    if (mapMatrix[xIndex][yIndex] ~= nil) then
        return false
    end
    mapMatrix[xIndex][yIndex] = true

    local mapData = mapCoordinateData[mapId]

    table.insert(
        mapData.positions,
        {
            mapX = mapX,
            mapY = mapY,
            worldX = worldX,
            worldY = worldY
        }
    )

    -- Increase record counter for statistics
    mapData.count = mapData.count + 1

    -- Track the explored extent along each map diagonal (projection onto the diagonal):
    -- x + y grows top-left -> bottom-right, x - y grows bottom-left -> top-right
    local diagSum = mapX + mapY
    local diagDiff = mapX - mapY
    if mapData.minDiagSum == nil or diagSum < mapData.minDiagSum then
        mapData.minDiagSum = diagSum
    end
    if mapData.maxDiagSum == nil or diagSum > mapData.maxDiagSum then
        mapData.maxDiagSum = diagSum
    end
    if mapData.minDiagDiff == nil or diagDiff < mapData.minDiagDiff then
        mapData.minDiagDiff = diagDiff
    end
    if mapData.maxDiagDiff == nil or diagDiff > mapData.maxDiagDiff then
        mapData.maxDiagDiff = diagDiff
    end

    return true
end

-- ==================================================================================================
-- Stored points of maps without a resolved coefficient (worldScaleDataUnresolved). They persist across
-- reloads so collection continues where it left off, and are dropped once the map gets a coefficient.
-- Points are stored compactly as {mapX, mapY, worldX, worldY} to keep the SavedVariables file small.

local function GetOrCreateStoredMapData(mapId, name)
    local store = MapRadar.accountData.worldScaleDataUnresolved
    local stored = store[mapId]

    if stored == nil then
        stored = {
            name = name,
            count = 0,
            positions = {}
        }
        store[mapId] = stored
    elseif name ~= nil and name ~= "" then
        -- Keep the most recent known name
        stored.name = name
    end

    return stored
end

-- Replaces the stored points of a map with its live points (live data includes everything restored)
local function StoreAllPositions(mapId)
    local mapData = mapCoordinateData[mapId]
    if mapData == nil then
        return
    end

    local positions = {}
    for i, pos in ipairs(mapData.positions) do
        positions[i] = {pos.mapX, pos.mapY, pos.worldX, pos.worldY}
    end

    local stored = GetOrCreateStoredMapData(mapId, mapData.name)
    stored.positions = positions
    stored.count = #positions
end

-- Converts stored compact points into the keyed form the coefficient calculation works on
local function ExpandStoredPositions(storedPositions)
    local positions = {}
    for i, p in ipairs(storedPositions) do
        positions[i] = {
            mapX = p[1],
            mapY = p[2],
            worldX = p[3],
            worldY = p[4]
        }
    end
    return positions
end

-- Loads stored points into freshly created live map data, rebuilding the 10 m grid and coverage
local function RestoreStoredPositions(mapId)
    local stored = MapRadar.accountData.worldScaleDataUnresolved[mapId]
    if stored == nil or stored.positions == nil then
        return
    end

    for _, p in ipairs(stored.positions) do
        AddPosition(mapId, p[1], p[2], p[3], p[4])
    end
end

local function checkMapIdUpdated(mapId)
    if latestMapId ~= mapId then
        -- Calibrator window is optional; position gathering also runs without it
        if dataForm ~= nil then
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
        end

        if (mapCoordinateData[mapId] == nil) then
            mapCoordinateData[mapId] = {
                name = worldMap.zoneName,
                positions = {},
                count = 0
            }
            mapCoordinateDataMatrix[mapId] = {}

            -- Continue from points collected in earlier sessions
            RestoreStoredPositions(mapId)
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

local function GroupByCoefficient(positions, tolerance)
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

        -- Compare to last element in current group; relative, so it works for any coefficient unit
        local last = current[#current].meterCoefficient
        if math.abs(p.meterCoefficient - last) <= tolerance * last then
            table.insert(current, p)
        else
            table.insert(groups, current)
            current = {p}
        end
    end

    table.insert(groups, current)
    return groups
end

-- Inserts an item into a list kept sorted by value (highest first) and capped at maxSize entries
local function InsertTopN(values, items, maxSize, value, item)
    local count = #values
    if count >= maxSize and value <= values[count] then
        return
    end

    if count < maxSize then
        count = count + 1
    end

    -- Shift lower entries down; when the list is full the lowest one falls off
    local k = count
    while k > 1 and values[k - 1] < value do
        values[k], items[k] = values[k - 1], items[k - 1]
        k = k - 1
    end
    values[k], items[k] = value, item
end

-- Picks the points furthest out in 8 directions (left/right, up/down and both diagonals).
-- The longest baselines run between such edge points, so pairing only these keeps the
-- pairwise step cheap no matter how many points the group has.
local function GetEdgeCandidates(points, perDirection)
    if #points <= perDirection * 8 then
        return points
    end

    local values, items = {}, {}
    for d = 1, 8 do
        values[d], items[d] = {}, {}
    end

    for _, p in ipairs(points) do
        local x, y = p.mapX, p.mapY
        local sum, diff = x + y, x - y
        InsertTopN(values[1], items[1], perDirection, x, p)
        InsertTopN(values[2], items[2], perDirection, -x, p)
        InsertTopN(values[3], items[3], perDirection, y, p)
        InsertTopN(values[4], items[4], perDirection, -y, p)
        InsertTopN(values[5], items[5], perDirection, sum, p)
        InsertTopN(values[6], items[6], perDirection, -sum, p)
        InsertTopN(values[7], items[7], perDirection, diff, p)
        InsertTopN(values[8], items[8], perDirection, -diff, p)
    end

    -- Merge, keeping points that are extreme in several directions only once
    local candidates, seen = {}, {}
    for d = 1, 8 do
        for _, p in ipairs(items[d]) do
            if not seen[p] then
                seen[p] = true
                table.insert(candidates, p)
            end
        end
    end

    return candidates
end

local function CalculateGroupCoefficient(points, minMapDist, useTopN)
    minMapDist = minMapDist or 0.001
    useTopN = useTopN or 10 -- longest 10 baselines

    local candidates = GetEdgeCandidates(points, EDGE_CANDIDATES_PER_DIRECTION)

    -- Compute pairwise distances between edge candidates
    local candidatePairs = {}
    for i = 1, #candidates do
        for j = i + 1, #candidates do
            local a, b = candidates[i], candidates[j]

            local mapDist = zoDistance(a.mapX, a.mapY, b.mapX, b.mapY)
            if mapDist >= minMapDist then
                table.insert(candidatePairs, {map = mapDist, a = a, b = b})
            end
        end
    end

    -- Sort by map distance (longest first)
    table.sort(
        candidatePairs,
        function(a, b)
            return a.map > b.map
        end
    )

    -- Take the longest N, using each point in at most one baseline so a single far-out point can't dominate
    local baselines = {}
    local used = {}
    for _, pair in ipairs(candidatePairs) do
        if #baselines >= useTopN then
            break
        end

        if not used[pair.a] and not used[pair.b] then
            used[pair.a] = true
            used[pair.b] = true
            table.insert(
                baselines,
                {
                    map = pair.map,
                    world = zoDistance(pair.a.worldX, pair.a.worldY, pair.b.worldX, pair.b.worldY)
                }
            )
        end
    end

    if #baselines == 0 then
        return nil
    end

    -- Median of the per-baseline coefficients
    local ratios = {}
    for i, b in ipairs(baselines) do
        ratios[i] = b.world / b.map
    end
    table.sort(ratios)

    local mid = math.floor(#ratios / 2)
    local median
    if #ratios % 2 == 1 then
        median = ratios[mid + 1]
    else
        median = (ratios[mid] + ratios[mid + 1]) / 2
    end

    -- Weighted coefficient, dropping baselines that disagree with the median (e.g. from one bad point)
    local sumMap, sumWorld, dropped = 0, 0, 0
    for _, b in ipairs(baselines) do
        if math.abs(b.world / b.map - median) <= BASELINE_TOLERANCE * median then
            sumMap = sumMap + b.map
            sumWorld = sumWorld + b.world
        else
            dropped = dropped + 1
        end
    end

    if dropped > 0 then
        MapRadar.debug("[Calibrator] Dropped <<1>> of <<2>> baselines deviating from median", dropped, #baselines)
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
            -- Size carries the group's point count so bigger groups get more decision weight
            table.insert(groupCoefficients, {meterCoefficient = coefficient, size = #coefficientGroup})
        end
    end

    return groupCoefficients
end

-- Collapses each cluster of group coefficients into its point-weighted average and total point count
local function SummarizeClusters(clusters)
    local clusterData = {}

    for _, cluster in ipairs(clusters) do
        local weightedSum, size = 0, 0
        for _, group in ipairs(cluster) do
            weightedSum = weightedSum + group.meterCoefficient * group.size
            size = size + group.size
        end
        table.insert(
            clusterData,
            {
                average = weightedSum / size,
                size = size
            }
        )
    end

    return clusterData
end

local function EvaluateClusters(clusters)
    local clusterData = SummarizeClusters(clusters)
    local totalPoints = 0
    for _, c in ipairs(clusterData) do
        totalPoints = totalPoints + c.size
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

-- Shared clustering pipeline; returns clusters of group coefficients, or nil when there is not enough data
local function BuildCoefficientClusters(mapData)
    if mapData.positions == nil or #mapData.positions < 3 then
        return nil
    end

    -- Calculate distance coefficient from single map point to all positions
    local positionsWithSinglePointCoefficient = GetPositionsWithSinglePointCoefficientCalculation(mapData.positions)

    -- Group positions by coefficients, so virtually inserted places with other raw coordinates split off
    local mapCoefficientGroups = GroupByCoefficient(positionsWithSinglePointCoefficient, CLUSTER_TOLERANCE)

    -- Internal coefficient per group using pairwise baselines
    local groupCoefficients = CalculateGroupCoefficients(mapCoefficientGroups)

    if #groupCoefficients == 0 then
        return nil
    end

    -- Cluster group coefficients so matching groups are evaluated together
    return GroupByCoefficient(groupCoefficients, CLUSTER_TOLERANCE)
end

local function CalculateMapCoefficient(mapData)
    local coefficientClusters = BuildCoefficientClusters(mapData)
    if coefficientClusters == nil then
        return nil
    end

    return EvaluateClusters(coefficientClusters)
end

-- Diagnostic: runs the same clustering pipeline as CalculateMapCoefficient but,
-- instead of collapsing to a single coefficient, returns every cluster with its
-- point-weighted average coefficient and point count. Returns nil when there is not enough data.
local function ComputeMapClusters(mapData)
    local coefficientClusters = BuildCoefficientClusters(mapData)
    if coefficientClusters == nil then
        return nil
    end

    return SummarizeClusters(coefficientClusters)
end

local function SaveMapScaleCoefficient(mapId, finalCoefficient)
    local map1meterCoefficient = 100 / finalCoefficient

    if MapRadar.config.calibrationSimulation then
        MapRadar.accountData.worldScaleDataSimulated[mapId] = map1meterCoefficient

        -- Deviation vs the current baseline (user calibration takes precedence over zone data)
        local origValue = MapRadar.accountData.worldScaleData[mapId] or MapRadarZoneData[mapId]
        local diffStr = "n/a"
        if origValue ~= nil and origValue ~= 0 then
            diffStr = string.format("%+.1f%%", (map1meterCoefficient - origValue) / origValue * 100)
        end

        -- Also store as a real calibration when there is no user calibration yet, so the
        -- radar can use the value without toggling simulation off. Zone data (autoscaled
        -- or not) only serves as the diff baseline above; it does not block the save.
        if MapRadar.accountData.worldScaleData[mapId] == nil then
            MapRadar.accountData.worldScaleData[mapId] = map1meterCoefficient
        end

        local mapName = zo_strformat("<<1>>", GetMapNameById(mapId))
        MapRadar.debug("[Calibrator] Saved simulated coefficient for <<1>> (<<2>>) diff <<3>>", mapName, mapId, diffStr)
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
    if dataForm ~= nil then
        dataForm.counterList:RemoveCounter(mapId)
    end
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

            -- Keep the raw points stored so the map can be re-analyzed, and collection
            -- picks them up again (restored on the next visit) instead of starting over
            StoreAllPositions(index)
        end

        -- Cleaning position table data
        for i, pos in pairs(mapData.positions) do
            mapData.positions[i] = nil
        end
        mapCoordinateData[index] = nil
    end

    -- Clear counter data from UI
    if dataForm ~= nil then
        dataForm.counterList:Clear()
    end

    latestMapId = 0
    checkMapIdUpdated(getCurrentMapId())
end

local function readPlayerData()
    if SCENE_MANAGER:IsShowing("worldMap") then
        return -- don't read while browsing the map; player can't move anyway
    end

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
    -- Unregister first so repeated calls never stack a second loop
    EVENT_MANAGER:UnregisterForUpdate("MapRadar_SaveMapCoordinates")
    EVENT_MANAGER:RegisterForUpdate(
        "MapRadar_SaveMapCoordinates",
        1000,
        function()
            if SCENE_MANAGER:IsShowing("worldMap") then
                return -- don't gather while browsing the map; player can't move anyway
            end

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

            -- Z parameter is used instead of Y because Y is elevation
            if AddPosition(mapId, mapX, mapY, wx, wz) then
                local mapData = mapCoordinateData[mapId]

                -- Store the point too, so collection continues after a reload
                local stored = GetOrCreateStoredMapData(mapId, mapData.name)
                table.insert(stored.positions, {mapX, mapY, wx, wz})
                stored.count = #stored.positions

                if dataForm ~= nil then
                    local name = zo_strformat("<<1>> (<<2>>)", worldMap.zoneName, mapId)
                    dataForm.counterList:AddOrUpdateCounter(mapId, name, mapData.count)
                end

                -- Auto-save once the explored path spans enough of either diagonal, so moving
                -- through any 3 map corners triggers on whichever diagonal they cover.
                -- Both value ranges span 2 across the full map, so half the range is the coverage.
                if not mapData.saved and mapData.count >= 3 then
                    local coverageTopLeftToBottomRight = (mapData.maxDiagSum - mapData.minDiagSum) / 2
                    local coverageBottomLeftToTopRight = (mapData.maxDiagDiff - mapData.minDiagDiff) / 2

                    if
                        coverageTopLeftToBottomRight >= MIN_DIAGONAL_COVERAGE or
                            coverageBottomLeftToTopRight >= MIN_DIAGONAL_COVERAGE
                     then
                        autoSave(mapId)
                    end
                end
            end
        end
    )
end

-- Position gathering runs independently of the calibrator window. While calibration is being
-- tested it follows the window toggle; return true here to gather on unscaled maps all the time.
local function IsCollectionEnabled()
    return MapRadar.config.showCalibrate
end

local function EnableOrDisableCollection()
    if IsCollectionEnabled() then
        RegisterMapCoordinateCollection()
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_SaveMapCoordinates")
    end
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
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_WorldCalibrationData")
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

-- Percent deviation at/above which a row is "too big" and floats to the top of the report
local LARGE_DIFF_THRESHOLD = 15

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
        local absDiff = -1 -- entries without a baseline never count as "too big"
        local color = {1, 1, 1}

        if origValue ~= nil and origValue ~= 0 then
            local diff = (simulatedValue - origValue) / origValue * 100
            diffStr = string.format("%+.1f%%", diff)
            absDiff = math.abs(diff)

            if absDiff < 5 then
                color = {0.4, 1, 0.4} -- green: close match
            elseif absDiff < LARGE_DIFF_THRESHOLD then
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

    -- Ordered by mapId, but "too big" deviations float to the top of the list
    table.sort(
        rows,
        function(a, b)
            local aBig = a.absDiff >= LARGE_DIFF_THRESHOLD
            local bBig = b.absDiff >= LARGE_DIFF_THRESHOLD
            if aBig ~= bBig then
                return aBig
            end
            return a.mapId < b.mapId
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

    for mapId, stored in pairs(MapRadar.accountData.worldScaleDataUnresolved) do
        if maps[mapId] == nil and stored.positions ~= nil and #stored.positions > 0 then
            maps[mapId] = {
                name = stored.name,
                positions = ExpandStoredPositions(stored.positions)
            }
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

        -- Older records stored keyed points ({mapX = ...}) and a bounding box; convert to the compact form
        for _, stored in pairs(MapRadar.accountData.worldScaleDataUnresolved) do
            if stored.positions ~= nil then
                for i, p in ipairs(stored.positions) do
                    if p.mapX ~= nil then
                        stored.positions[i] = {p.mapX, p.mapY, p.worldX, p.worldY}
                    end
                end
            end
            stored.left, stored.right, stored.top, stored.bottom = nil, nil, nil, nil
        end

        if MapRadar.accountData.mapNameData == nil then
            MapRadar.accountData.mapNameData = {}
        end

        if MapRadar.config.showCalibrate then
            CreateCalibrationDataForm()
        end

        EnableOrDisableCalibrator()
        EnableOrDisableCollection()
    end
)

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarSlashCommand",
    function(args)
        if (args == "reset") and dataForm ~= nil then
            dataForm.counterList:Clear()
        end

        if (args == "recalibrate") then
            -- Saved coefficient was just cleared, so let autoSave fire again for this map;
            -- positions gathered this session are still valid and are kept
            local mapId = getCurrentMapId()
            local mapData = mapCoordinateData[mapId]
            if mapData ~= nil then
                mapData.saved = false

                -- The earlier save dropped the stored points; store them again so they survive a reload
                StoreAllPositions(mapId)
            end
        end

        if (args == "report") then
            ToggleScaleReport()
        end

        if (args == "check") then
            ToggleCheckReport()
        end

        if MapRadar.config.showCalibrate and dataForm == nil then
            CreateCalibrationDataForm()
        end

        EnableOrDisableCalibrator()
        EnableOrDisableCollection()
    end
)
