local scaleLabel = {}
local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")
local dataForm = {}
local mgridTexture = {}
-- local btnSaveScaleData = {}

local ScaleData = { dx = 0, dy = 0, px = 0, py = 0, unit1 = 0 }

local storedPos1 = {}

-- TODO: 
-- Data save button to saved variables
-- Create label/data form component with confing methods
-- Create data stack component
-- Add data label/datastack to form component

local function setScaleLabel(val)
    -- MapRadar.scale = MapRadar.scale + val
    -- scaleLabel:SetText(MapRadar.scale)
end

local function CreateLabel(anchorPoint, anchor, targetAnchorPoint, text)
    local label, labelKey = labelPool:AcquireObject()
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(unpack({ 1, 1, 1, 1 }))
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function calc1meter(x1, y1, x2, y2)
    local measuredMeters = 40

    local dx = x1 - x2
    local dy = y1 - y2

    local distance = math.sqrt(dx ^ 2 + dy ^ 2) -- distance in percentage

    return distance / measuredMeters -- calculate map part for 1 meter
end

local function showCalibrationData(pin)

    -- local measuredMeters = 40
    local playerX, playerY = MapRadar.getMapPlayerPosition("player")

    ScaleData.px = playerX
    ScaleData.py = playerY

    ScaleData.dx = pin.normalizedX - playerX
    ScaleData.dy = pin.normalizedY - playerY

    -- local distance = math.sqrt(ScaleData.dx ^ 2 + ScaleData.dy ^ 2) -- distance in percentage

    ScaleData.unit1 = calc1meter(pin.normalizedX, pin.normalizedY, playerX, playerY) -- distance / measuredMeters -- calculate map part for 1 meter

    dataForm:Update()

    -- just show actual scale value if it changed
    setScaleLabel(0)
end

local displayMultiplier = 10000000
local function CreateCalibrationDataForm()

    dataForm = MapRadarCommon.DataForm:New("CalibrateDataForm", MapRadarContainer)
    dataForm:SetAnchor(LEFT, GuiRoot, LEFT, 100, -100)

    dataForm:AddLabel(
        "GetCurrentMapId", function()
            return MapRadar.getCurrentMapId()
        end)
    dataForm:AddLabel(
        "GetCurrentMapIndex", function()
            return GetCurrentMapIndex()
        end)
    dataForm:AddLabel(
        "GetCurrentMapZoneIndex", function()
            return GetCurrentMapZoneIndex()
        end)

    dataForm:AddLabel(
        "Zone", function()
            return MapRadar.worldMap.zoneName
        end)
    dataForm:AddLabel(
        "Rel DX", function()
            return ScaleData.dx
        end)
    dataForm:AddLabel(
        "Rel DY", function()
            return ScaleData.dy
        end)
    dataForm:AddLabel(
        "Rel PX", function()
            return ScaleData.px
        end)
    dataForm:AddLabel(
        "Rel PY", function()
            return ScaleData.py
        end)
    dataForm:AddLabel(
        "Unit1", function()
            return ScaleData.unit1
        end)

    local btnSaveScaleData = CreateControlFromVirtual("$(parent)btnSaveScaleData", dataForm, "ZO_PlusButton")
    btnSaveScaleData:SetDimensions(40, 40)
    btnSaveScaleData:SetAnchor(TOPLEFT, dataForm, BOTTOMLEFT)
    btnSaveScaleData:SetHandler(
        "OnClicked", function()
            local curvedZoom = MapRadar.getPanAndZoom():GetCurrentCurvedZoom()
            local currentMapWidth, currentMapHeight = MapRadar.getMapDimensions()

            local data = { dx = ScaleData.dx, dy = ScaleData.dy, unit1 = ScaleData.unit1, mapId = MapRadar.getCurrentMapId(),
                           zoneIndex = GetCurrentMapZoneIndex(), name = MapRadar.worldMap.zoneName }

            MapRadar.config.scaleData[data.mapId] = data
            MapRadar.debug("Saved one meter unit data (<<1>>) for zone: <<2>>", MapRadar.getStrVal(data.unit1), MapRadar.worldMap.zoneName)
        end)

    local btnSavePosition1 = CreateControlFromVirtual("$(parent)btnSavePosition1", dataForm, "ZO_PlusButton")
    btnSavePosition1:SetDimensions(40, 40)
    btnSavePosition1:SetAnchor(TOPLEFT, btnSaveScaleData, BOTTOMLEFT, 0, 30)
    btnSavePosition1:SetHandler(
        "OnClicked", function()
            storedPos1.px = ScaleData.px
            storedPos1.py = ScaleData.py

            MapRadar.debug("Saved position one")
        end)

    local btnSavePosition2 = CreateControlFromVirtual("$(parent)btnSavePosition2", dataForm, "ZO_PlusButton")
    btnSavePosition2:SetDimensions(40, 40)
    btnSavePosition2:SetAnchor(TOPLEFT, btnSavePosition1, TOPRIGHT)
    btnSavePosition2:SetHandler(
        "OnClicked", function()
            local curvedZoom = MapRadar.getPanAndZoom():GetCurrentCurvedZoom()
            local currentMapWidth, currentMapHeight = MapRadar.getMapDimensions()

            local data = { dx = ScaleData.px - storedPos1.px, dy = ScaleData.py - storedPos1.py,
                           unit1 = calc1meter(ScaleData.px, ScaleData.py, storedPos1.px, storedPos1.py), mapId = MapRadar.getCurrentMapId(),
                           zoneIndex = GetCurrentMapZoneIndex(), name = MapRadar.worldMap.zoneName }

            storedPos1 = {}

            MapRadar.config.scaleData[data.mapId] = data
            MapRadar.debug("Saved one meter unit data (<<1>>) for zone: <<2>>", MapRadar.getStrVal(data.unit1), MapRadar.worldMap.zoneName)
        end)

end

local function MapRadar_InitScaleCalibrator()

    CreateCalibrationDataForm()

    mgridTexture = CreateControl("$(parent)Mgrid", MapRadarContainer, CT_TEXTURE)
    mgridTexture:SetTexture("MapRadar/textures/mgrid.dds")
    mgridTexture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER)
    mgridTexture:SetDimensions(329, 329)
    -- mgridTexture:SetAlpha(0.5)

    --[[
    scaleLabel = CreateControl("$(parent)ScaleLabel", MapRadarContainer, CT_LABEL)
    scaleLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT, 20, 40)
    scaleLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    scaleLabel:SetColor(unpack({1, 1, 1, 1}))
    setScaleLabel(0)

    local btnAdd01 = CreateControlFromVirtual("$(parent)btnAdd01", MapRadarContainer, "ZO_PlusButton")
    btnAdd01:SetAnchor(TOPLEFT, scaleLabel, BOTTOMLEFT)
    btnAdd01:SetHandler("OnClicked", function()
        setScaleLabel(0.1)
    end)

    local btnSub01 = CreateControlFromVirtual("$(parent)btnSub01", MapRadarContainer, "ZO_MinusButton")
    btnSub01:SetAnchor(TOPLEFT, btnAdd01, BOTTOMLEFT)
    btnSub01:SetHandler("OnClicked", function()
        setScaleLabel(-0.1)
    end)

    local btnAdd001 = CreateControlFromVirtual("$(parent)btnAdd001", MapRadarContainer, "ZO_PlusButton")
    btnAdd001:SetAnchor(TOPLEFT, btnAdd01, TOPRIGHT)
    btnAdd001:SetHandler("OnClicked", function()
        setScaleLabel(0.01)
    end)

    local btnSub001 = CreateControlFromVirtual("$(parent)btnSub001", MapRadarContainer, "ZO_MinusButton")
    btnSub001:SetAnchor(TOPLEFT, btnAdd001, BOTTOMLEFT)
    btnSub001:SetHandler("OnClicked", function()
        setScaleLabel(-0.01)
    end)

    local btnAdd0001 = CreateControlFromVirtual("$(parent)btnAdd0001", MapRadarContainer, "ZO_PlusButton")
    btnAdd0001:SetAnchor(TOPLEFT, btnAdd001, TOPRIGHT)
    btnAdd0001:SetHandler("OnClicked", function()
        setScaleLabel(0.001)
    end)

    local btnSub0001 = CreateControlFromVirtual("$(parent)btnSub0001", MapRadarContainer, "ZO_MinusButton")
    btnSub0001:SetAnchor(TOPLEFT, btnAdd0001, BOTTOMLEFT)
    btnSub0001:SetHandler("OnClicked", function()
        setScaleLabel(-0.001)
    end)
]]

end

local function EnableOrDisableCalibrator()
    dataForm:SetHidden(not MapRadar.config.showCalibrate)
    mgridTexture:SetHidden(not MapRadar.config.showCalibrate)
    -- btnSaveScaleData:SetHidden(not MapRadar.config.showCalibrate)

    if MapRadar.config.showCalibrate then
        -- ===================================================================================
        -- Fetch party leader pin to use for calculation
        EVENT_MANAGER:RegisterForUpdate(
            "MapRadar_PinReader", 100, function()
                local pins = MapRadar.pinManager:GetActiveObjects()

                for pinKey, pin in pairs(pins) do
                    -- MAP_PIN_TYPE_ACTIVE_COMPANION
                    -- MAP_PIN_TYPE_GROUP_LEADER

                    if pin:IsCompanion() -- pin:GetPinType() == MAP_PIN_TYPE_GROUP_LEADER 
                    and pin.normalizedX and pin.normalizedY then
                        showCalibrationData(pin)
                        return
                    end
                end

            end)
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_PinReader")
    end
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized", function()
        if MapRadar.config.scaleData == nil then
            MapRadar.config.scaleData = {}
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
