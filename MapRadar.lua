-- TODO For release
-- Saved variable usage (save mode, save radar position)
-- Filter configuration page radar and overlay separate config
-- Hide radar texture when in Overlay mode
-- Fast trakel wayshrines (with range limit)
-- Radar mode display range increase (it is lower than 200 - not good)
-- calibrate dungeons
-- calibrate delves
-- calibrate elden root inner
-- ===================================================================================================
-- Pin reading should be converted to event based. Read all pins and compare to current. Trigger pin create events and pin dispose events
-- Prepare pinData on addon load to include supported pinTypes (also calc all pinTypes for custom pins) (table data loads: texture, scale/size, visibility)
-- Create secondaryMethod (after pin type table) to fetch pinData by texture
-- Custom pin types read and saved to internal constants (QuestMap, TreasuremMap)
-- Convert get icon method to table data fetch (for better performance)
-- Create invoke analyzer
-- Debounce methods for key bindings
-- Survey/Treasure if you have map/item (load from LibTreasure) or juts rely on TreasureMap, Destinations or whatnot else??
-- https://github.com/esoui/esoui/blob/3b9326af2f5946a748be4551bfce41672f084e39/esoui/ingame/map/worldmap.lua#L695
-- Some maps load pins with certain distance only, add pin check from Destinations and MapPins (maybe some other addon too?)
-- Hide in combat option
MapRadar = {
    -- Localize global objects for better performance
    worldMap = ZO_WorldMap,
    getPanAndZoom = ZO_WorldMap_GetPanAndZoom,

    getMapDimensions = ZO_WorldMap_GetMapDimensions,
    orig_GetMapDimensions = orgZO_WorldMap_GetMapDimensions,

    getPlayerCameraHeading = GetPlayerCameraHeading,
    getMapPlayerPosition = GetMapPlayerPosition,

    pinManager = ZO_WorldMap_GetPinManager(),

    getMapType = GetMapType, -- Returns: UIMapType mapType: https://wiki.esoui.com/Globals#UIMapType

    -- flags
    showPointer = true,
    showDistance = true,

    currentMapWidth = 0,
    currentMapHeight = 0,

    maxRadarDistance = 0, -- limit distance to keep icons on radar outer edge (is set in setOverlayMode())
    pinSize = 0,

    positionLabel = {},

    scale = 1, -- This meant to be used and scale param when measuring and calibrating pins on different zones

    value = function(valueOrMethod, ...)
        if type(valueOrMethod) == "function" then
            -- MapRadar.debugDebounce("Execute method with params: <<1>>", MapRadar.getStrVal(...))
            return valueOrMethod(...)
        else
            return valueOrMethod
        end
    end,
    -- ==================================================================================================
    -- Debug stuff
    showCalibrate = true,
    showAllPins = false,
    showPinLoc = false,
    showPinNames = false,
    showPinParams = false,

    debug = function(formatString, ...)
        d(zo_strformat(formatString, ...))
    end,

    lastdebugMsg = "",
    debugDebounce = function(formatString, ...)
        local msg = zo_strformat(formatString, ...)

        if MapRadar.lastdebugMsg == msg then
            return
        end

        d(msg)

        MapRadar.lastdebugMsg = msg
    end,

    getStrVal = function(obj)
        if obj == nil then
            return "nil"
        end
        return tostring(obj)
    end
}

local UIWidth, UIHeight = GuiRoot:GetDimensions()
local playerPin = MapRadar.pinManager:GetPlayerPin()
local pinsPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local pointerPool = ZO_ControlPool:New("PointerTemplate", MapRadarContainer, "Pointer")
local distanceLabelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Distance")

local activePins = {}

local function getMapScale()
    -- For now set very apporx scale

    -- Standard zone
    if MapRadar.currentMapWidth == 3156 or MapRadar.currentMapWidth == 2752 then
        return 1.05
    end

    -- Some DLC middle maps??
    if MapRadar.currentMapWidth == 1945 then
        return 2.2
    end

    return 0.44 -- Standard subzone
end

-- https://www.codecademy.com/resources/docs/lua/tables

-- https://esoapi.uesp.net/100031/src/ingame/map/mappin.lua.html
-- https://esodata.uesp.net/100025/src/ingame/map/worldmap.lua.html
local function registerMapPins()

    --[[
    if SCENE_MANAGER:IsShowing("worldMap") then
        -- Dispose all pins because they are removed from pool and will get different keys
        for k in pairs(activePins) do
            activePins[k]:Dispose()
            activePins[k] = nil
        end
        return -- Block further execution while map is opened
    end
    --]]

    local pins = MapRadar.pinManager:GetActiveObjects()

    -- Dispose pins that are not active 
    --[[ 
        Shit works only if you do not reset pins globally like map change)
        To make it work need to update pins only when map scroll is closed!!!!
        But if map was navigated and closed then all pins are recreated in pin manager and they have all their keys changed
        Maybe on map close need to flush all pins and trigger register???
    --]]

    -- Pin count may stay the same and pin gets replaced (even with same key) with different pin
    -- Need to add pinKey value to pin bades on its data??
    -- how to make world unit or group unit pins unique?? Need to check what it contains!!!

    -- When pins chanage with new zone then they all need to be reset because active pin keys now assigned to other pins
    -- Could check custom pin key for content or existance

    -- Need to compare references of pin objects!!
    -- rawequal (v1, v2)

    for k, radarPin in pairs(activePins) do
        -- if pins[k] == nil or pins[k].mapRadarKey == nil or pins[k].mapRadarKey ~= activePins[k].pin.mapRadarKey then
        CALLBACK_MANAGER:FireCallbacks("OnMapRadar_RemovePin", activePins[k])
        activePins[k]:Dispose()
        activePins[k] = nil
        -- end
    end

    MapRadarPin:ReleaseAll()

    local playerX, playerY = MapRadar.getMapPlayerPosition("player")
    local heading = MapRadar.getPlayerCameraHeading()

    -- Add new pins that did not exist
    for key, pin in pairs(pins) do
        if -- pin.mapRadarKey == nil and 
        MapRadarPin:IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local radarPin = MapRadarPin:New(pin, key)
            radarPin:UpdatePin(playerX, playerY, heading)
            activePins[key] = radarPin
            CALLBACK_MANAGER:FireCallbacks("OnMapRadar_NewPin", radarPin)
        end
    end
end

-- ==================================================================================================
-- Mode change
local function setOverlayMode(flag)
    MapRadar.playerPinTexture:ClearAnchors()

    if flag then
        MapRadar.playerPinTexture:SetAnchor(CENTER, GuiRoot, BOTTOM, 0, -UIHeight * 0.4)
        MapRadar.maxRadarDistance = UIHeight * 0.5
        MapRadar.pinSize = 25
    else
        MapRadar.playerPinTexture:SetAnchor(CENTER, MapRadarContainer, CENTER)
        MapRadar.maxRadarDistance = 110
        MapRadar.pinSize = 20
    end

    MapRadar.config.isOverlayMode = flag
end

local function updateOverlay()
    if MapRadar.config.isOverlayMode then
        setOverlayMode(true)
    end
end

-- ==================================================================================================
-- Event handlers

local function mapUpdate()
    local heading = MapRadar.getPlayerCameraHeading()
    MapRadarContainerRadarTexture:SetTextureRotation(-heading, 0.5, 0.5)

    -- read map width and height to local params not to invoke method in loop
    local mapWidth, mapHeight = MapRadar.getMapDimensions()
    -- MapRadar.debugDebounce("Read map W: <<1>>  <<2>>", mapWidth, mapHeight)

    -- This reassigns global values only if they are different to reduce value loss during write operartion.
    -- Other read opperations may read unassigned value
    if MapRadar.currentMapWidth ~= mapWidth then
        MapRadar.currentMapWidth = mapWidth
    end
    if MapRadar.currentMapHeight ~= mapWidth then
        MapRadar.currentMapHeight = mapHeight
    end

    local playerX, playerY = MapRadar.getMapPlayerPosition("player")

    MapRadar.positionLabel:SetText(zo_strformat("Pos:  <<1>> <<2>>", playerX * 100, playerY * 100))

    -- reposition pins
    for key in pairs(activePins) do
        local radarPin = activePins[key]
        -- MapRadar.debug("Fetching pin: <<1>>  <<2>>", key, MapRadar.getStrVal(radarPin))
        radarPin:UpdatePin(playerX, playerY, heading)
    end
end

local prevPinCount = 0
local function mapPinCountCheck()
    local pins = MapRadar.pinManager:GetActiveObjects()
    local maxn = table.maxn(pins)

    if prevPinCount == maxn then
        return
    end

    -- MapRadar.debugDebounce("Pin count changed: <<1>>", maxn)

    prevPinCount = maxn
    registerMapPins()
end

local function initialize(eventType, addonName)
    if addonName ~= "MapRadar" then
        return
    end

    CALLBACK_MANAGER:FireCallbacks("OnMapRadarInitializing")

    local playerPinTexture = CreateControl("$(parent)PlayerPin", MapRadarContainer, CT_TEXTURE)
    playerPinTexture:SetTexture("EsoUI/Art/MapPins/UI-WorldMapPlayerPip.dds")
    playerPinTexture:SetDimensions(20, 20)
    playerPinTexture:SetAlpha(0.5)
    MapRadar.playerPinTexture = playerPinTexture

    local positionLabel = CreateControl("$(parent)PositionLabel", MapRadarContainer, CT_LABEL)
    positionLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT)
    positionLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    positionLabel:SetColor(unpack({1, 1, 1, 1}))
    MapRadar.positionLabel = positionLabel

    -- Set mode to radar from start (should be saved to variables later)
    setOverlayMode(MapRadar.config.isOverlayMode);

    local fragment = ZO_SimpleSceneFragment:New(MapRadarContainer)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)

    EVENT_MANAGER:RegisterForUpdate("MapRadar_OnUpdate", 30, mapUpdate)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinCount", 100, mapPinCountCheck)

    --[[
    CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function()
        zo_callLater(function()
            MapRadar.scale = getMapScale()
        end, 200)

    end)
    --]]

    CALLBACK_MANAGER:FireCallbacks("OnMapRadarInitialized")
end

-- ==================================================================================================
-- Event subscribtion

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_PLAYER_IN_PIN_AREA_CHANGED, function()
    -- MapRadar.debug("EVENT_PLAYER_IN_PIN_AREA_CHANGED")
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_OBJECTIVE_CONTROL_STATE, function()
    MapRadar.debug("EVENT_OBJECTIVE_CONTROL_STATE")
end)

-- This is good to trigger pin reset (if quest chnages 1 marker then pin count check does not see difference)
EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_ADVANCED, function()
    -- MapRadar.debug("EVENT_QUEST_ADVANCED")
    zo_callLater(registerMapPins, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_COMPLETE, function()
    -- MapRadar.debug("EVENT_QUEST_COMPLETE")
    zo_callLater(registerMapPins, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_ADDED, function()
    -- MapRadar.debug("EVENT_QUEST_ADDED ")
    zo_callLater(registerMapPins, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_POSITION_REQUEST_COMPLETE, function()
    -- MapRadar.debug("EVENT_QUEST_POSITION_REQUEST_COMPLETE ")
    zo_callLater(registerMapPins, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_CONDITION_COUNTER_CHANGED, function()
    -- MapRadar.debug("EVENT_QUEST_CONDITION_COUNTER_CHANGED ")
    zo_callLater(registerMapPins, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_ALL_GUI_SCREENS_RESIZED, function()
    UIWidth, UIHeight = GuiRoot:GetDimensions()
    updateOverlay()
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_ADD_ON_LOADED, initialize)

-- ==================================================================================================
-- Key binding

ZO_CreateStringId("SI_BINDING_NAME_MAPRADAR_TOGGLE", "Toggle mode")

-- Hanller for configured hotkey
function MapRadar_ToggleMode()
    setOverlayMode(not MapRadar.config.isOverlayMode)
end

-- ==================================================================================================
-- Slash commands
local function slashCommands(args)
    -- REFACTOR to support only one arg maybe?? without array?

    if args == "all" then
        MapRadar.showAllPins = not MapRadar.showAllPins
    end

    if args == "names" then
        MapRadar.showPinNames = not MapRadar.showPinNames
    end

    if args == "dist" then
        MapRadar.showDistance = not MapRadar.showDistance
    end

    if args == "para" then
        MapRadar.showPinParams = not MapRadar.showPinParams
    end
end

SLASH_COMMANDS["/mapradar"] = slashCommands
SLASH_COMMANDS["/mr"] = slashCommands

-- ==================================================================================================
-- Test stuff 

function MapRadar_button()
    registerMapPins() -- reset all pins placement (for calibration)

    local oW, oH = MapRadar.orgZO_WorldMap_GetMapDimensions()
    local currentMapWidth, currentMapHeight = MapRadar.getMapDimensions()
    local x, y, h = MapRadar.getMapPlayerPosition("player")

    MapRadar.debug("Map dimension: <<1>> <<2>>", currentMapWidth, currentMapHeight)
    MapRadar.debug("Orig Map dimension: <<1>> <<2>>", oW, oH)
    MapRadar.debug("Map curvedZoom: <<1>>", MapRadar.getPanAndZoom():GetCurrentCurvedZoom() * 1000)
    MapRadar.debug("UI -  W: <<1>>  H: <<2>>", UIWidth, UIHeight)
    MapRadar.debug("MR max distance: <<1>>", MapRadar.maxRadarDistance)

end

--[[
CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function()
    local oW, oH = orgZO_WorldMap_GetMapDimensions()
    local currentMapWidth, currentMapHeight = ZO_WorldMap_GetMapDimensions()

    MapRadar.debug("Map dimension: <<1>> <<2>>", currentMapWidth, currentMapHeight)
    MapRadar.debug("Orig Map dimension: <<1>> <<2>>", oW, oH)
end)
--]]

-- GetCurrentMapIndex() 
-- GetPlayerActiveSubzoneName() -> Returns: string subzoneName 
-- GetPlayerActiveZoneName() -> Returns: string zoneName 

-- local worldMapMode = WORLD_MAP_MANAGER:GetMode()
--[[
MAP_MODE_AVA_KEEP_RECALL
	6
MAP_MODE_AVA_RESPAWN
	5
MAP_MODE_DIG_SITES
	7
MAP_MODE_FAST_TRAVEL
	4
MAP_MODE_KEEP_TRAVEL
	3
MAP_MODE_LARGE_CUSTOM
	2
MAP_MODE_SMALL_CUSTOM
--]]

-- ZO_WorldMapScroll:IsHidden()
-- WORLD_MAP_AUTO_NAVIGATION_OVERLAY_FRAGMENT:IsShowing()
-- SCENE_MANAGER:IsShowing("worldMap")
