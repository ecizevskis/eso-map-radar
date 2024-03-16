local dataForm = {}

local AnalyzerData = {
    pinCreateCount = 0,
    pinRemoveCount = 0,
    pinUpdateCount = 0,
    pointerCreatinCount = 0,
    pointerRotateCount = 0
}

local function showAnalyzerData()
    dataForm:Update()
end

local function CreateInvokeAnalyzerDataForm()

    dataForm = MapRadarCommon.DataForm:New("InvokeAnalyzerDataForm", MapRadarContainer)
    dataForm:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 100, 200)

    dataForm:AddStack(
        "Pins", function()
            return MapRadar.tablelength(MapRadar.pinManager:GetActiveObjects())
        end)
    dataForm:AddStack(
        "ActivePins", function()
            return MapRadar.tablelength(MapRadar.activePins)
        end)
    dataForm:AddStack(
        "Pin Create", function()
            return AnalyzerData.pinCreateCount
        end)
    dataForm:AddStack(
        "Pin Remove", function()
            return AnalyzerData.pinRemoveCount
        end)
    dataForm:AddStack(
        "Pin Update", function()
            return AnalyzerData.pinUpdateCount
        end)
end

local function MapRadar_InitInvokeAnalyzer()
    CreateInvokeAnalyzerDataForm()

    EVENT_MANAGER:RegisterForUpdate(
        "MapRadar_AnalyzerReader", 1000, function()
            showAnalyzerData()

            -- Rest counters
            AnalyzerData.pinCreateCount = 0
            AnalyzerData.pinRemoveCount = 0
            AnalyzerData.pinUpdateCount = 0

            --[[
        local mapScrollHidden = MapRadar.getStrVal(ZO_WorldMapScroll:IsHidden())
        local navOverlayShowing = MapRadar.getStrVal(WORLD_MAP_AUTO_NAVIGATION_OVERLAY_FRAGMENT:IsShowing())
        local worldmapShowing = MapRadar.getStrVal(SCENE_MANAGER:IsShowing("worldMap"))

        MapRadar.debugDebounce("Scroll hidden: <<1>>,  NavOverlay: <<2>>,  WorldMap: <<3>>", mapScrollHidden, navOverlayShowing, worldmapShowing)
--]]
        end)

    CALLBACK_MANAGER:RegisterCallback(
        "OnMapRadar_NewPin", function(radarPin)
            -- MapRadar.debug("New radar pin: <<1>>", radarPin.key)
            AnalyzerData.pinCreateCount = AnalyzerData.pinCreateCount + 1
        end)

    CALLBACK_MANAGER:RegisterCallback(
        "OnMapRadar_RemovePin", function(radarPin)
            -- MapRadar.debug("Removed radar pin: <<1>>", radarPin.key)
            AnalyzerData.pinRemoveCount = AnalyzerData.pinRemoveCount + 1
        end)

    CALLBACK_MANAGER:RegisterCallback(
        "OnMapRadar_UpdatePin", function(radarPin)
            -- MapRadar.debug("Removed radar pin: <<1>>", radarPin.key)
            AnalyzerData.pinUpdateCount = AnalyzerData.pinUpdateCount + 1
        end)

    d("InvokeAnalyzer enabled")
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitializing", function()
        MapRadar_InitInvokeAnalyzer()
    end)
