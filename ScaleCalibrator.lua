local scaleLabel = {}
local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")
local dataForm = {}

local ScaleData = {
    dx = 0,
    dy = 0,
    unit1 = 0
}

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
    label:SetColor(unpack({1, 1, 1, 1}))
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function showCalibrationData(pin)

    local measuredMeters = 40
    local playerX, playerY = MapRadar.getMapPlayerPosition("player")

    ScaleData.dx = pin.normalizedX - playerX
    ScaleData.dy = pin.normalizedY - playerY

    local distance = math.sqrt(ScaleData.dx ^ 2 + ScaleData.dy ^ 2) -- distance in percentage

    ScaleData.unit1 = distance / measuredMeters -- calculate map part for 1 meter

    dataForm:Update()

    -- just show actual scale value if it changed
    setScaleLabel(0)
end

local displayMultiplier = 10000000
local function CreateCalibrationDataForm()

    dataForm = MapRadarCommon.DataForm:New("CalibrateDataForm", MapRadarContainer)
    dataForm:SetAnchor(LEFT, GuiRoot, LEFT, 100, -100)
    dataForm:AddLabel(
        "Zone", function()
            return MapRadar.worldMap.zoneName
        end)
    dataForm:AddLabel(
        "Rel DX", function()
            return zo_strformat("<<1>>", ScaleData.dx * displayMultiplier)
        end)
    dataForm:AddLabel(
        "Rel DY", function()
            return zo_strformat("<<1>>", ScaleData.dy * displayMultiplier)
        end)
    dataForm:AddLabel(
        "Unit1", function()
            return ScaleData.unit1
        end)

    local btnSaveScaleData = CreateControlFromVirtual("$(parent)btnSaveScaleData", MapRadarContainer, "plusButtonTemplate")
    btnSaveScaleData:SetAnchor(TOPLEFT, dataForm, BOTTOMLEFT)
    btnSaveScaleData:SetHandler(
        "OnClicked", function()
            local curvedZoom = MapRadar.getPanAndZoom():GetCurrentCurvedZoom()
            local currentMapWidth, currentMapHeight = MapRadar.getMapDimensions()

            local data = {
                dx = ScaleData.dx,
                dy = ScaleData.dy,
                unit1 = ScaleData.unit1
            }

            MapRadar.config.scaleData[MapRadar.worldMap.zoneName] = data
            MapRadar.debug("Saved scale data for zone: <<1>>", MapRadar.worldMap.zoneName)
        end)
end

local function MapRadar_InitScaleCalibrator()

    CreateCalibrationDataForm()

    local mgridTexture = CreateControl("$(parent)Mgrid", MapRadarContainer, CT_TEXTURE)
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

    local btnAdd01 = CreateControlFromVirtual("$(parent)btnAdd01", MapRadarContainer, "plusButtonTemplate")
    btnAdd01:SetAnchor(TOPLEFT, scaleLabel, BOTTOMLEFT)
    btnAdd01:SetHandler("OnClicked", function()
        setScaleLabel(0.1)
    end)

    local btnSub01 = CreateControlFromVirtual("$(parent)btnSub01", MapRadarContainer, "minusButtonTemplate")
    btnSub01:SetAnchor(TOPLEFT, btnAdd01, BOTTOMLEFT)
    btnSub01:SetHandler("OnClicked", function()
        setScaleLabel(-0.1)
    end)

    local btnAdd001 = CreateControlFromVirtual("$(parent)btnAdd001", MapRadarContainer, "plusButtonTemplate")
    btnAdd001:SetAnchor(TOPLEFT, btnAdd01, TOPRIGHT)
    btnAdd001:SetHandler("OnClicked", function()
        setScaleLabel(0.01)
    end)

    local btnSub001 = CreateControlFromVirtual("$(parent)btnSub001", MapRadarContainer, "minusButtonTemplate")
    btnSub001:SetAnchor(TOPLEFT, btnAdd001, BOTTOMLEFT)
    btnSub001:SetHandler("OnClicked", function()
        setScaleLabel(-0.01)
    end)

    local btnAdd0001 = CreateControlFromVirtual("$(parent)btnAdd0001", MapRadarContainer, "plusButtonTemplate")
    btnAdd0001:SetAnchor(TOPLEFT, btnAdd001, TOPRIGHT)
    btnAdd0001:SetHandler("OnClicked", function()
        setScaleLabel(0.001)
    end)

    local btnSub0001 = CreateControlFromVirtual("$(parent)btnSub0001", MapRadarContainer, "minusButtonTemplate")
    btnSub0001:SetAnchor(TOPLEFT, btnAdd0001, BOTTOMLEFT)
    btnSub0001:SetHandler("OnClicked", function()
        setScaleLabel(-0.001)
    end)
]]

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
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized", function()

        if MapRadar.config.scaleData == nil then
            MapRadar.config.scaleData = {}
        end

        if MapRadar.showCalibrate then
            MapRadar_InitScaleCalibrator()
        end
    end)
