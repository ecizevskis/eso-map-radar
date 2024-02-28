local scaleLabel = {}
local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")

local ScaleData = {
    zoneName = {},
    mapWidth = {},
    mapHeight = {},
    curvedZoom = {},

    rel_dx = {},
    rel_dy = {},
    map_dx = {},
    map_dy = {},

    unit1 = {},
    mrScale = {}
}

local function setScaleLabel(val)
    MapRadar.scale = MapRadar.scale + val
    scaleLabel:SetText(MapRadar.scale)
end

local function CreateLabel(anchorPoint, anchor, targetAnchorPoint, text)
    local label, labelKey = labelPool:AcquireObject()
    label:SetFont("$(BOLD_FONT)|18|outline")
    label:SetColor(unpack({1, 1, 1, 1}))
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function showCalibrationData(pin)
    local displayMultiplier = 10000000
    local measuredMeters = 40

    local playerX, playerY = GetMapPlayerPosition("player")
    local curvedZoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()
    local currentMapWidth, currentMapHeight = ZO_WorldMap_GetMapDimensions()

    -- TODO  Take in account that map can be with different Width and Height (Do calc on paper for getting formulas right!!!)
    local relative_dx = pin.normalizedX - playerX
    local relative_dy = pin.normalizedY - playerY

    local map_dx = relative_dx * currentMapWidth
    local map_dy = relative_dy * currentMapHeight

    local distance = math.sqrt(map_dx ^ 2 + map_dy ^ 2) -- distance in map units as offset? pixels?

    local unit1 = distance / measuredMeters -- calculate map part for 1 meter
    local unit1k = unit1 * 1000

    local mrScale = measuredMeters / distance * 4; -- need to calculate here (x4 just to zoom in and aim for 160px marker)

    ScaleData.zoneName:SetText(ZO_WorldMap.zoneName)
    ScaleData.mapWidth:SetText(currentMapWidth)
    ScaleData.mapHeight:SetText(currentMapHeight)
    ScaleData.curvedZoom:SetText(curvedZoom)
    ScaleData.rel_dx:SetText(zo_strformat("<<1>>", relative_dx * displayMultiplier))
    ScaleData.rel_dy:SetText(zo_strformat("<<1>>", relative_dy * displayMultiplier))
    ScaleData.map_dx:SetText(map_dx)
    ScaleData.map_dy:SetText(map_dy)
    ScaleData.unit1:SetText(unit1)
    ScaleData.mrScale:SetText(mrScale)

    -- just show actual scale value if it changed
    setScaleLabel(0)
end

local function CreateCalibrationDataForm()
    local dataAnchorControl = CreateControl("$(parent)CalibrationDataAnchor", MapRadarContainer, CT_CONTROL)

    dataAnchorControl:SetAnchor(LEFT, GuiRoot, LEFT, 100)
    dataAnchorControl:SetDimensions(20, 100)

    local widthLabel = CreateLabel(RIGHT, dataAnchorControl, LEFT, "Zone")
    ScaleData.zoneName = CreateLabel(LEFT, dataAnchorControl, RIGHT, "")

    local widthLabel = CreateLabel(TOPRIGHT, widthLabel, BOTTOMRIGHT, "Map Width")
    ScaleData.mapWidth = CreateLabel(TOPLEFT, ScaleData.zoneName, BOTTOMLEFT, "0")

    local heightLabel = CreateLabel(TOPRIGHT, widthLabel, BOTTOMRIGHT, "Map Height")
    ScaleData.mapHeight = CreateLabel(TOPLEFT, ScaleData.mapWidth, BOTTOMLEFT, "0")

    local curvCoomLabel = CreateLabel(TOPRIGHT, heightLabel, BOTTOMRIGHT, "Curv zoom")
    ScaleData.curvedZoom = CreateLabel(TOPLEFT, ScaleData.mapHeight, BOTTOMLEFT, "0")

    local reldxLabel = CreateLabel(TOPRIGHT, curvCoomLabel, BOTTOMRIGHT, "Rel DX")
    ScaleData.rel_dx = CreateLabel(TOPLEFT, ScaleData.curvedZoom, BOTTOMLEFT, "0")

    local reldyLabel = CreateLabel(TOPRIGHT, reldxLabel, BOTTOMRIGHT, "Rel DY")
    ScaleData.rel_dy = CreateLabel(TOPLEFT, ScaleData.rel_dx, BOTTOMLEFT, "0")

    local mapdxLabel = CreateLabel(TOPRIGHT, reldyLabel, BOTTOMRIGHT, "Map DX")
    ScaleData.map_dx = CreateLabel(TOPLEFT, ScaleData.rel_dy, BOTTOMLEFT, "0")

    local mapdyLabel = CreateLabel(TOPRIGHT, mapdxLabel, BOTTOMRIGHT, "Map DY")
    ScaleData.map_dy = CreateLabel(TOPLEFT, ScaleData.map_dx, BOTTOMLEFT, "0")

    local unit1Label = CreateLabel(TOPRIGHT, mapdyLabel, BOTTOMRIGHT, "Unit1")
    ScaleData.unit1 = CreateLabel(TOPLEFT, ScaleData.map_dy, BOTTOMLEFT, "0")

    local mrScaleLabel = CreateLabel(TOPRIGHT, unit1Label, BOTTOMRIGHT, "MR Scale")
    ScaleData.mrScale = CreateLabel(TOPLEFT, ScaleData.unit1, BOTTOMLEFT, "0")

end

local function MapRadar_InitScaleCalibrator()

    CreateCalibrationDataForm()

    local mgridTexture = CreateControl("$(parent)Mgrid", MapRadarContainer, CT_TEXTURE)
    mgridTexture:SetTexture("MapRadar/textures/mgrid.dds")
    mgridTexture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER)
    mgridTexture:SetDimensions(329, 329)
    -- mgridTexture:SetAlpha(0.5)

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

    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinReader", 100, function()
        local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()

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

CALLBACK_MANAGER:RegisterCallback("OnMapRadarInitialized", function()
    if MapRadar.showCalibrate then
        MapRadar_InitScaleCalibrator()
    end
end)
