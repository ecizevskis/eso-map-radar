local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")

local AnalyzerData = {
    pinResetCount = 0,
    pinResetLabel = {},

    pinUpdateCount = 0,
    pinUpdateLabel = {},

    pointerCreatinCount = 0,
    pointerCreationLabel = {},

    pointerRotateCount = 0,
    pointerRotateLabel = {}

}

-- TODO
-- Create component for pushing and displaying stack of values 
-- Create component to show data form (register array of data fetch methods with label or stack)

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

local function showAnalyzerData(pin)

    --[[
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
--]]
end

local function CreateInvokeAnalyzerDataForm()
    local dataAnchorControl = CreateControl("$(parent)InvokeAnalyzerDataAnchor", MapRadarContainer, CT_CONTROL)

    dataAnchorControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 100, 200)
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

function MapRadar_InitInvokeAnalyzer()
    CreateInvokeAnalyzerDataForm()

    EVENT_MANAGER:RegisterForUpdate("MapRadar_AnalyzerReader", 100, function()
        showAnalyzerData()
    end)
end

