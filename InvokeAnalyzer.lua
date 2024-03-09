local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "InvokeCounter")

local AnalyzerData = {
    pinCreateCount = 0,
    pinCreateLabel = {},

    pinRemoveCount = 0,
    pinRemoveLabel = {},

    pinUpdateCount = 0,
    pinUpdateLabel = {},

    pointerCreatinCount = 0,
    pointerCreationLabel = {},

    pointerRotateCount = 0,
    pointerRotateLabel = {}

}

-- TODO
-- Create component to show data form (register array of data fetch methods with label or stack)

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

local function CreateStack(id, anchorPoint, anchor, targetAnchorPoint, text)
    local label = MapRadarCommon.LabelStack:New("$(parent)Stack" .. id, MapRadarContainer, 5)
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(unpack({1, 1, 1, 1}))
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function showAnalyzerData(pin)
    AnalyzerData.pinCreateLabel:SetText(AnalyzerData.pinCreateCount)
    AnalyzerData.pinRemoveLabel:SetText(AnalyzerData.pinRemoveCount)
    -- AnalyzerData.pinUpdateLabel:SetText(AnalyzerData.pinUpdateCount)
    -- AnalyzerData.pointerCreationLabel:SetText(AnalyzerData.pointerCreatinCount)
    -- AnalyzerData.pointerRotateLabel:SetText(AnalyzerData.pointerRotateCount)
end

local function CreateInvokeAnalyzerDataForm()
    local dataAnchorControl = CreateControl("$(parent)InvokeAnalyzerDataAnchor", MapRadarContainer, CT_CONTROL)

    dataAnchorControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 100, 200)
    dataAnchorControl:SetDimensions(20, 100)

    local l1 = CreateLabel(RIGHT, dataAnchorControl, LEFT, "Pin create:")
    AnalyzerData.pinCreateLabel = CreateStack("pinCreate", LEFT, dataAnchorControl, RIGHT, "")

    local l2 = CreateLabel(TOPRIGHT, l1, BOTTOMRIGHT, "Pin remove:")
    AnalyzerData.pinRemoveLabel = CreateStack("pinRemove", TOPLEFT, AnalyzerData.pinCreateLabel, BOTTOMLEFT, "0")

    --[[
    local l3 = CreateLabel(TOPRIGHT, l2, BOTTOMRIGHT, "Pin update:")
    AnalyzerData.pinUpdateLabel = CreateLabel(TOPLEFT, AnalyzerData.pinRemoveLabel, BOTTOMLEFT, "0")

    local l4 = CreateLabel(TOPRIGHT, l3, BOTTOMRIGHT, "Pointer create:")
    AnalyzerData.pointerCreationLabel = CreateLabel(TOPLEFT, AnalyzerData.pinUpdateLabel, BOTTOMLEFT, "0")

    local l5 = CreateLabel(TOPRIGHT, l4, BOTTOMRIGHT, "Pointer rotate:")
    AnalyzerData.pointerRotateLabel = CreateLabel(TOPLEFT, AnalyzerData.pointerCreationLabel, BOTTOMLEFT, "0")
--]]
end

local function MapRadar_InitInvokeAnalyzer()
    CreateInvokeAnalyzerDataForm()

    EVENT_MANAGER:RegisterForUpdate("MapRadar_AnalyzerReader", 1000, function()
        showAnalyzerData()

        -- Rest counters
        AnalyzerData.pinCreateCount = 0
        AnalyzerData.pinRemoveCount = 0

        --[[
        local mapScrollHidden = MapRadar.getStrVal(ZO_WorldMapScroll:IsHidden())
        local navOverlayShowing = MapRadar.getStrVal(WORLD_MAP_AUTO_NAVIGATION_OVERLAY_FRAGMENT:IsShowing())
        local worldmapShowing = MapRadar.getStrVal(SCENE_MANAGER:IsShowing("worldMap"))

        MapRadar.debugDebounce("Scroll hidden: <<1>>,  NavOverlay: <<2>>,  WorldMap: <<3>>", mapScrollHidden, navOverlayShowing, worldmapShowing)
--]]
    end)

    CALLBACK_MANAGER:RegisterCallback("OnMapRadar_NewPin", function(radarPin)
        -- MapRadar.debug("New radar pin: <<1>>", radarPin.key)
        AnalyzerData.pinCreateCount = AnalyzerData.pinCreateCount + 1
    end)

    CALLBACK_MANAGER:RegisterCallback("OnMapRadar_RemovePin", function(radarPin)
        -- MapRadar.debug("Removed radar pin: <<1>>", radarPin.key)
        AnalyzerData.pinRemoveCount = AnalyzerData.pinRemoveCount + 1
    end)

    d("InvokeAnalyzer enabled")
end

CALLBACK_MANAGER:RegisterCallback("OnMapRadarInitializing", function()
    MapRadar_InitInvokeAnalyzer()
end)
