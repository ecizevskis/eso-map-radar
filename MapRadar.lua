-- TODO
-- MAP_PIN_TYPE_POI_SEEN type check by texture path (Public Dungeon, Group Dungeon, Delve, Wayshrine, Solo Dungeon?, GroupBoss )
-- Prepare pinData on addon load to include supported pinTypes (also calc all pinTypes for custom pins) (table data loads: texture, scale/size, visibility)
-- Create secondaryMethod (after pin type table) to fetch pinData by texture
-- Custom pin types read and saved to internal constants (QuestMap, TreasuremMap)
-- Convert get icon method to table data fetch (for better performance)
-- Pointer fading like icon on distance
-- Create invoke analyzer
-- Debounce methods for key bindings
-- Saved variable usage (save mode, save radar position)
-- Configuration page
-- Icon fading if distance is big (faded as constant if 2x maxDistance ... or gradient fade?)
-- Fast trakel wayshrines (with range limit 1200 meters?)
-- Closest dolmen
-- Group via all map
-- Survey/Treasure if you have map/item (load from LibTreasure)
-- https://github.com/esoui/esoui/blob/3b9326af2f5946a748be4551bfce41672f084e39/esoui/ingame/map/worldmap.lua#L695
MapRadar = {
    showPointer = true,
    showDistance = true,

    currentMapWidth = 0,
    currentMapHeight = 0,

    maxDistance = 0, -- limit distance to keep icons on radar outer edge (is set in setOverlayMode())
    pinSize = 0,

    positionLabel = {},

    scale = 1, -- This meant to be used and scale param when measuring and calibrating pins on different zones

    showCalibrate = true,
    showAllPins = false,

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

    getVal = function(obj)
        if obj == nil then
            return "nil"
        end
        return tostring(obj)
    end
}

local UIWidth, UIHeight = GuiRoot:GetDimensions()
local playerPin = ZO_WorldMap_GetPinManager():GetPlayerPin()
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
    -- Clear existing pins
    -- TODO: use dispose here!!!
    for k in pairs(activePins) do
        activePins[k]:Dispose()
        activePins[k] = nil
    end

    MapRadarPin:ReleaseAll()
    MapRadar.scale = getMapScale()

    -- Add new pins
    local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()
    for key, pin in pairs(pins) do
        if MapRadarPin:IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local radarPin = MapRadarPin:New(pin, key)
            activePins[key] = radarPin
        end
    end
end

-- ==================================================================================================
-- Mode change
local function setOverlayMode(flag)
    MapRadar.playerPinTexture:ClearAnchors()

    if flag then
        MapRadar.playerPinTexture:SetAnchor(CENTER, GuiRoot, BOTTOM, 0, -UIHeight * 0.4)
        MapRadar.maxDistance = UIHeight * 0.5
        MapRadar.pinSize = 25
    else
        MapRadar.playerPinTexture:SetAnchor(CENTER, MapRadarContainer, CENTER)
        MapRadar.maxDistance = 110
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

-- zoneChangeCheck might not be needed at all
--[[
local prevZone = ""
local prevSubZone = ""
local function zoneChangeCheck()
    local playerZone = GetPlayerActiveZoneName()
    local playerSubZone = GetPlayerActiveSubzoneName()

    if prevZone == playerZone and prevSubZone == playerSubZone then
        return
    end
    prevZone = playerZone
    prevSubZone = playerSubZone

    MapRadar.debug("ZoneChange: zone: <<1>>, subzone: <<2>>", playerZone, playerSubZone)

    -- Trigger pin reset
    registerMapPins()
end
--]]

local function mapUpdate()
    local heading = GetPlayerCameraHeading()
    MapRadarContainerRadarTexture:SetTextureRotation(-heading, 0.5, 0.5)

    -- read map width and height to local params not to invoke method in loop
    local mapWidth, mapHeight = ZO_WorldMap_GetMapDimensions()
    -- MapRadar.debugDebounce("Read map W: <<1>>  <<2>>", mapWidth, mapHeight)

    -- This reassigns global values only if they are different to reduce value loss during write operartion.
    -- Other read opperations may read unassigned value
    if MapRadar.currentMapWidth ~= mapWidth then
        MapRadar.currentMapWidth = mapWidth
    end
    if MapRadar.currentMapHeight ~= mapWidth then
        MapRadar.currentMapHeight = mapHeight
    end

    local playerX, playerY = GetMapPlayerPosition("player")
    local curvedZoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()

    MapRadar.positionLabel:SetText(zo_strformat("Pos:  <<1>> <<2>>", playerX * 100, playerY * 100))

    -- reposition pins
    for key in pairs(activePins) do
        local radarPin = activePins[key]
        -- MapRadar.debug("Fetching pin: <<1>>  <<2>>", key, MapRadar.getVal(radarPin))
        radarPin:UpdatePin(playerX, playerY, heading, curvedZoom)
    end
end

local prevPinCount = 0
local function mapPinCountCheck()
    local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()
    local maxn = table.maxn(pins)

    if prevPinCount == maxn then
        return
    end

    -- df("Pin count changed %d", maxn)

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
-- Test stuff 

function MapRadar_button()
    registerMapPins() -- reset all pins placement (for calibration)

    local currentMapWidth, currentMapHeight = ZO_WorldMap_GetMapDimensions()
    local x, y, h = GetMapPlayerPosition("player")

    MapRadar.debug("Map dimension: <<1>> <<2>>", currentMapWidth, currentMapHeight)
    MapRadar.debug("Map curvedZoom: <<1>>", ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom() * 1000)
    MapRadar.debug("UI -  W: <<1>>  H: <<2>>", UIWidth, UIHeight)
    MapRadar.debug("MR max distance: <<1>>", MapRadar.maxDistance)

end
