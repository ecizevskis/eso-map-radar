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

local function isSkippedMap(mapId)
    if mapId == 27 or mapId == 439 then -- Tamriel -- The Aurubis
        return true
    end

    return false
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
            MapRadar.debug("[CalculateGroupCoefficients] <<1>>", coefficient)
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
        table.insert(clusterData, {
            average = sum / #cluster,
            size = #cluster
        })
        totalPoints = totalPoints + #cluster
    end

    -- Single cluster - straightforward
    if #clusterData == 1 then
        return clusterData[1].average
    end

    -- Sort by size descending to find dominant cluster
    table.sort(clusterData, function(a, b) return a.size > b.size end)

    local dominant = clusterData[1]

    -- If dominant cluster holds majority, check for outliers
    if dominant.size > totalPoints / 2 then
        local inliers = {dominant}
        local outlierCount = 0

        for i = 2, #clusterData do
            local relDev = math.abs(clusterData[i].average - dominant.average) / dominant.average
            if relDev > 0.15 then
                outlierCount = outlierCount + 1
                MapRadar.debug("[EvaluateClusters] Dropping outlier cluster (dev: <<1>>%)", string.format("%.1f", relDev * 100))
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
        MapRadar.debug("[EvaluateClusters] Zone skipped: clusters deviate too much (max <<1>>%)", string.format("%.1f", maxDev * 100))
        return nil
    end

    -- Moderate deviation - complicated zone with scaling, average all weighted by size
    MapRadar.debug("[EvaluateClusters] Complicated zone (<<1>> clusters, max dev <<2>>%), using weighted average", #clusterData, string.format("%.1f", maxDev * 100))
    local weightedSum = 0
    for _, c in ipairs(clusterData) do
        weightedSum = weightedSum + c.average * c.size
    end
    return weightedSum / totalPoints
end

local function calcAndSaveDistances()
    for index, mapData in pairs(mapCoordinateData) do
        if #mapData.positions >= 3 then
            -- Calculate distance coefficient from single map point to all positions
            local positionsWithSinglePointCoefficient = GetPositionsWithSinglePointCoefficientCalculation(mapData.positions)

            -- Group positions by coefficients with some error delta
            local mapCoefficientGroups = GroupByCoefficient(positionsWithSinglePointCoefficient, 0.01)

            -- Average coefficients per group using pairwise baselines
            local groupCoefficients = CalculateGroupCoefficients(mapCoefficientGroups)

            if #groupCoefficients > 0 then
                -- Cluster group coefficients and evaluate
                local coefficientClusters = GroupByCoefficient(groupCoefficients, 0.01)
                local finalCoefficient = EvaluateClusters(coefficientClusters)

                if finalCoefficient ~= nil and not MapRadar.calibrationSimulation then
                    local map1meterCoefficient = 100 / finalCoefficient
                    MapRadar.accountData.worldScaleData[index] = map1meterCoefficient
                    MapRadar.debug("[calcAndSaveDistances] Saved coefficient <<1>> for map <<2>>", map1meterCoefficient, index)
                elseif finalCoefficient == nil then
                    MapRadar.debug("[calcAndSaveDistances] Skipped map <<1>> due to inconsistent data", index)
                end
            end
        else
            MapRadar.debug("[calcAndSaveDistances] Not enough positions for map <<1>>", index)
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
            if hasScaleData and not MapRadar.calibrationSimulation then
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

                table.insert(
                    mapCoordinateData[mapId].positions,
                    {
                        mapX = mapX,
                        mapY = mapY,
                        worldX = wx,
                        worldY = wz -- Z parameter is instead of Y because Y is elevation
                    }
                )

                -- Increase record counter for statistics
                mapCoordinateData[mapId].count = mapCoordinateData[mapId].count + 1

                local name = zo_strformat("<<1>> (<<2>>)", worldMap.zoneName, mapId)
                dataForm.counterList:AddOrUpdateCounter(mapId, name, mapCoordinateData[mapId].count)
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

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized",
    function()
        if MapRadar.accountData.worldScaleData == nil then
            MapRadar.accountData.worldScaleData = {}
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

        if MapRadar.config.showCalibrate and dataForm == nil then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end
)
