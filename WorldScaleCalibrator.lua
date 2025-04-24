local scaleLabel = {}
local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")
local dataForm = nil
local worldMap = ZO_WorldMap
local getMapPlayerPosition = GetMapPlayerPosition
local getUnitRawWorldPosition = GetUnitRawWorldPosition
local getUnitWorldPosition = GetUnitWorldPosition
local getUnitRawWorldPosition = GetUnitRawWorldPosition
local latestMapId = 0
local ScaleData = {
    px = 0,
    py = 0
 }

local storedPos = {}

local function checkMapIdUpdated(mapId)
    if latestMapId ~= mapId then
        local isCalibrated = MapRadar.config.worldScaleData[mapId] ~= nil
        dataForm:SetColor(1, 1, isCalibrated and 1 or 0, 1)
    end

    latestMapId = mapId;
end

local function CreateLabel(anchorPoint, anchor, targetAnchorPoint, text)
    local label, labelKey = labelPool:AcquireObject()
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(1, 1, 1, 1)
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function calcAndSaveDistance()

    if storedPos.px == nil or storedPos.py == nil then
        return
    end
    local mapId = GetCurrentMapId()
    local worldDistanceMeters = zo_distance(storedPos.wx, storedPos.wz, ScaleData.wx, ScaleData.wz) / 100
    local mapDistance = zo_distance(storedPos.px, storedPos.py, ScaleData.px, ScaleData.py)

    local map1meterCoefficient = mapDistance / worldDistanceMeters

    MapRadar.config.worldScaleData[mapId] = map1meterCoefficient
    MapRadar.debug("Saved one meter unit data (<<1>>) for zone: <<2>>", MapRadar.getStrVal(map1meterCoefficient), worldMap.zoneName)

    latestMapId = 0
    checkMapIdUpdated(mapId)
end

local function selfData()
    local playerX, playerY = getMapPlayerPosition("player")
    local zoneId, wx, wy, wz = getUnitWorldPosition("player");
    local zoneId, rwx, rwy, rwz = getUnitRawWorldPosition("player");

    ScaleData.px = playerX
    ScaleData.py = playerY

    ScaleData.wx = wx
    ScaleData.wy = wy
    ScaleData.wz = wz

    ScaleData.rwx = rwx -- Longitude
    ScaleData.rwy = rwy -- Elevation
    ScaleData.rwz = rwz -- Latitude

    if (storedPos.wx) then
        ScaleData.wdist = zo_strformat(
            "<<1>> : <<2>>", zo_distance(storedPos.wx, storedPos.wz, wx, wz) / 100,
            zo_distance3D(storedPos.wx, storedPos.wy, storedPos.wz, wx, wy, wz) / 100)
    end

    if (storedPos.rwx) then
        ScaleData.rwdist = zo_strformat(
            "<<1>> : <<2>>", zo_distance(storedPos.rwx, storedPos.rwz, rwx, rwz) / 100,
            zo_distance3D(storedPos.rwx, storedPos.rwy, storedPos.rwz, rwx, rwy, rwz) / 100)
    end

    if (storedPos.wy) then
        ScaleData.eleDiff = zo_strformat("<<1>> / <<2>>", wy - storedPos.wy, rwy - storedPos.rwy)
    end
end

local function CreateCalibrationDataForm()

    dataForm = MapRadarCommon.DataForm:New("WorldCalibrateDataForm", MapRadarContainer)
    dataForm:SetAnchor(LEFT, GuiRoot, LEFT, 150, -250)

    dataForm:AddLabel(
        "MapId", function()
            local mapId = GetCurrentMapId()
            checkMapIdUpdated(mapId)
            return mapId;
        end)

    -- dataForm:AddLabel(
    --     "Active zone", function()
    --         return GetPlayerActiveZoneName()
    --     end)

    -- dataForm:AddLabel(
    --     "Zone", function()
    --         return worldMap.zoneName
    --     end)
    -- dataForm:AddLabel(
    --     "Rel PX", function()
    --         return ScaleData.px
    --     end)
    -- dataForm:AddLabel(
    --     "Rel PY", function()
    --         return ScaleData.py
    --     end)

    dataForm:AddLabel(
        "World (X/Z/Y)", function()
            return zo_strformat("<<1>>  <<2>>  <<3>>", ScaleData.wx, ScaleData.wz, ScaleData.wy)
        end)

    dataForm:AddLabel(
        "Raw World (X/Z/Y)", function()
            return zo_strformat("<<1>>  <<2>>  <<3>>", ScaleData.rwx, ScaleData.rwz, ScaleData.rwy)
        end)

    dataForm:AddLabel(
        "World distances", function()
            return zo_strformat("<<1>> / <<2>>", ScaleData.wdist, ScaleData.rwdist)
        end)

    dataForm:AddLabel(
        "Elevation diff", function()
            return zo_strformat("<<1>>", ScaleData.eleDiff)
        end)

    local btnSavePosition1 = CreateControlFromVirtual("$(parent)btnSavePosition1", dataForm, "ZO_NextArrowButton")
    btnSavePosition1:SetDimensions(40, 40)
    btnSavePosition1:SetAnchor(TOPLEFT, dataForm, BOTTOMLEFT, 0, 10)
    btnSavePosition1:SetHandler(
        "OnClicked", function()
            storedPos.px = ScaleData.px
            storedPos.py = ScaleData.py

            storedPos.wx = ScaleData.wx
            storedPos.wy = ScaleData.wy
            storedPos.wz = ScaleData.wz

            storedPos.rwx = ScaleData.rwx
            storedPos.rwy = ScaleData.rwy
            storedPos.rwz = ScaleData.rwz

            MapRadar.debug("Saved world position")
        end)
    btnSavePosition1:SetHandler(
        "OnMouseEnter", function(self)
            ZO_Tooltips_ShowTextTooltip(self, BOTTOM, "Save current player position")
        end)
    btnSavePosition1:SetHandler(
        "OnMouseExit", function(self)
            ZO_Tooltips_HideTextTooltip()
        end)

    local labelPosition1 = MapRadarCommon.CreateLabel("$(parent)labelPosition1", dataForm, "Mark position")
    labelPosition1:SetAnchor(RIGHT, btnSavePosition1, LEFT)

    -- local labelSave = MapRadarCommon.CreateLabel("$(parent)labelSave", dataForm, "Save calibration")
    -- labelSave:SetAnchor(TOPRIGHT, labelPosition1, BOTTOMRIGHT, 0, 10)

    local btnSave = CreateControlFromVirtual("$(parent)btnSave", dataForm, "SavingEditBoxSaveButton")
    btnSave:SetDimensions(40, 40)
    btnSave:SetAnchor(LEFT, btnSavePosition1, RIGHT, 30)
    btnSave:SetHandler(
        "OnClicked", function()
            calcAndSaveDistance();
        end)

end

local function MapRadar_InitScaleCalibrator()
    CreateCalibrationDataForm()

end

local function EnableOrDisableCalibrator()
    if (dataForm ~= nil and dataForm.SetHidden ~= nil) then
        dataForm:SetHidden(not MapRadar.config.showCalibrate)
    end

    if MapRadar.config.showCalibrate then
        EVENT_MANAGER:RegisterForUpdate(
            "MapRadar_WorldCalibrationData", 100, function()
                selfData()
                dataForm:Update()
            end)
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_CalibrationData")
    end
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized", function()
        if MapRadar.config.worldScaleData == nil then
            MapRadar.config.worldScaleData = {}
        end

        if MapRadar.config.showCalibrate then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end)

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarSlashCommand", function()
        if MapRadar.config.showCalibrate and dataForm == nil then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end)
