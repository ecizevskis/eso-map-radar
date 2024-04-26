-- TODO
-- Group delve own settings option
-- Calibration interface changes 
--    Add two sections with changable distance and saving to saved variables
--    Remove party leader lookup
--    Remove party leader distance coords calculation from forms
--    Add main zone name to saved calibration data  GetPlayerActiveZoneName()
-- on zone zhange (pin count chnage maybe) can trigger checking of pins? Can try to dispose them in other method maybe?
MapRadar = {
    maxRadarDistance = 0, -- limit distance to keep icons on radar outer edge (is set in setOverlayMode())
    pinSize = 0, -- positionLabel = {},
    activePins = {}, --
    modeSettings = {}, --
    scale = 1, -- This meant to be used and scale param when measuring and calibrating pins on different zones
    value = function(valueOrMethod, ...)
        if type(valueOrMethod) == "function" then
            -- MapRadar.debugDebounce("Execute method with params: <<1>>", MapRadar.getStrVal(...))
            return valueOrMethod(...)
        else
            return valueOrMethod
        end
    end, -- ==================================================================================================
    -- Debug stuff
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
    end,
    tablelength = function(T)
        local count = 0
        for _ in pairs(T) do
            count = count + 1
        end
        return count
    end
 }

-- Localize global objects for better performance
local sceneManager = SCENE_MANAGER
local getPlayerCameraHeading = GetPlayerCameraHeading
local getMapPlayerPosition = GetMapPlayerPosition
local pinManager = ZO_WorldMap_GetPinManager()

local UIWidth, UIHeight = GuiRoot:GetDimensions()
local playerPin = pinManager:GetPlayerPin()
local pinsPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local pointerPool = ZO_ControlPool:New("PointerTemplate", MapRadarContainer, "Pointer")
local distanceLabelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Distance")

-- https://esoapi.uesp.net/100031/src/ingame/map/mappin.lua.html
-- https://esodata.uesp.net/100025/src/ingame/map/worldmap.lua.html
local function registerMapPins()

    if sceneManager:IsShowing("worldMap") then
        return -- Block further execution while map is opened
    end

    local pins = pinManager:GetActiveObjects()

    -- Dispose invalid pins
    for k, radarPin in pairs(MapRadar.activePins) do
        if radarPin.isCorrupted or not MapRadarPin:IsValidPin(radarPin.pin) or pins[k] ~= radarPin.pin then
            MapRadar.activePins[k]:Dispose()
            MapRadar.activePins[k] = nil
        end
    end

    local playerX, playerY = getMapPlayerPosition("player")
    local heading = getPlayerCameraHeading()

    -- Add new pins that did not exist
    for key, pin in pairs(pins) do
        if MapRadar.activePins[key] == nil and MapRadarPin:IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local radarPin = MapRadarPin:New(pin, key)
            radarPin:UpdatePin(playerX, playerY, heading, true)
            MapRadar.activePins[key] = radarPin
        end
    end
end

-- ==================================================================================================
-- Mode change
local function setOverlayMode(flag)
    MapRadar.playerPinTexture:ClearAnchors()
    MapRadarContainerRadarTexture:SetHidden(flag)

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

    if flag then
        MapRadar.modeSettings = MapRadar.config.overlaySettings
    else
        MapRadar.modeSettings = MapRadar.config.radarSettings
    end
    CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
end

local function updateOverlay()
    if MapRadar.config.isOverlayMode then
        setOverlayMode(true)
    end
end

-- ==================================================================================================
-- Event handlers
local playerHeading, playerX, playerY = 0, 0, 0
local function mapUpdate()
    if sceneManager:IsShowing("worldMap") then
        return -- Block further execution while map is opened
    end

    local px, py = getMapPlayerPosition("player")
    local heading = getPlayerCameraHeading()

    local hasPlayerMoved = playerHeading ~= heading or playerX ~= px or playerY ~= py
    playerHeading = heading
    playerX = px
    playerY = py

    -- MapRadar.positionLabel:SetText(zo_strformat("Pos:  <<1>> <<2>>", playerX * 100, playerY * 100))
    MapRadarContainerRadarTexture:SetTextureRotation(-heading, 0.5, 0.5)

    -- reposition pins
    for key, radarPin in pairs(MapRadar.activePins) do
        radarPin:UpdatePin(playerX, playerY, heading, hasPlayerMoved)
    end
end

local function mapPinIntegrityCheck()
    for key, radarPin in pairs(MapRadar.activePins) do
        if not radarPin:CheckIntegrity() then
            radarPin.isCorrupted = true
            CALLBACK_MANAGER:FireCallbacks("MapRadar_CorruptedPin")
        end
    end
end

local prevPinCount = 0
local function mapPinCountCheck()
    local pins = pinManager:GetActiveObjects()
    local maxn = table.maxn(pins)

    if prevPinCount == maxn then
        -- return
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

    --[[
    local positionLabel = CreateControl("$(parent)PositionLabel", MapRadarContainer, CT_LABEL)
    positionLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT)
    positionLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    positionLabel:SetColor(unpack({1, 1, 1, 1}))
    MapRadar.positionLabel = positionLabel
    ]]

    -- Set mode to radar from start (should be saved to variables later)
    setOverlayMode(MapRadar.config.isOverlayMode);

    local fragment = ZO_SimpleSceneFragment:New(MapRadarContainer)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)

    EVENT_MANAGER:RegisterForUpdate("MapRadar_OnUpdate", 30, mapUpdate)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinCount", 200, mapPinCountCheck)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinCheck", 1000, mapPinIntegrityCheck)

    CALLBACK_MANAGER:RegisterCallback(
        "MapRadar_Reset", function()
            playerHeading = 0
        end)

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

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_PLAYER_IN_PIN_AREA_CHANGED, function()
        -- MapRadar.debug("EVENT_PLAYER_IN_PIN_AREA_CHANGED")
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_OBJECTIVE_CONTROL_STATE, function()
        MapRadar.debug("EVENT_OBJECTIVE_CONTROL_STATE")
    end)

-- This is good to trigger pin reset (if quest chnages 1 marker then pin count check does not see difference)
EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_ADVANCED, function()
        -- MapRadar.debug("EVENT_QUEST_ADVANCED")
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_COMPLETE, function()
        -- MapRadar.debug("EVENT_QUEST_COMPLETE")
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_ADDED, function()
        -- MapRadar.debug("EVENT_QUEST_ADDED ")
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_POSITION_REQUEST_COMPLETE, function()
        -- MapRadar.debug("EVENT_QUEST_POSITION_REQUEST_COMPLETE ")
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_CONDITION_COUNTER_CHANGED, function()
        -- MapRadar.debug("EVENT_QUEST_CONDITION_COUNTER_CHANGED ")
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_ALL_GUI_SCREENS_RESIZED, function()
        UIWidth, UIHeight = GuiRoot:GetDimensions()
        updateOverlay()
    end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_ADD_ON_LOADED, initialize)

-- ==================================================================================================
-- Key binding

local hotkeyDebouncer = MapRadarCommon.Debouncer:New(
    function(count)

        if count == 2 then
            return MapRadar_toggleSettings()
        end

        setOverlayMode(not MapRadar.config.isOverlayMode)
    end)

ZO_CreateStringId("SI_BINDING_NAME_MAPRADAR_HOTKEY", "Hotkey")

-- Handler for configured hotkey
function MapRadar_Hotkey()
    hotkeyDebouncer:Invoke()
end

-- ==================================================================================================
-- Slash commands
local function slashCommands(args)
    if args == "all" then
        MapRadar.showAllPins = not MapRadar.showAllPins
        local flagStr = MapRadar.showAllPins and "ON" or "OFF"
        MapRadar.debug("Show all pins: <<1>>", flagStr)
    end

    if args == "names" then
        MapRadar.showPinNames = not MapRadar.showPinNames
        local flagStr = MapRadar.showPinNames and "ON" or "OFF"
        MapRadar.debug("Show names: <<1>>", flagStr)
    end

    if args == "dist" then
        MapRadar.modeSettings.showDistance = not MapRadar.modeSettings.showDistance
        local flagStr = MapRadar.modeSettings.showDistance and "ON" or "OFF"
        MapRadar.debug("Show disatnce: <<1>>", flagStr)
    end

    if args == "para" then
        MapRadar.showPinParams = not MapRadar.showPinParams
        local flagStr = MapRadar.showPinParams and "ON" or "OFF"
        MapRadar.debug("Show params: <<1>>", flagStr)
    end

    if args == "calibrate" then
        MapRadar.config.showCalibrate = not MapRadar.config.showCalibrate
        local flagStr = MapRadar.config.showCalibrate and "ON" or "OFF"
        MapRadar.debug("Show calibrate: <<1>>", flagStr)
    end

    if args == "analyzer" then
        MapRadar.config.showAnalyzer = not MapRadar.config.showAnalyzer
        local flagStr = MapRadar.config.showAnalyzer and "ON" or "OFF"
        MapRadar.debug("Show analyzer: <<1>>", flagStr)
    end

    CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
    CALLBACK_MANAGER:FireCallbacks("OnMapRadarSlashCommand")
end

SLASH_COMMANDS["/mapradar"] = slashCommands
SLASH_COMMANDS["/mr"] = slashCommands

-- ==================================================================================================
-- Test stuff 

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

-- local zoneId, pwx1, pwh1, pwy1 = GetUnitRawWorldPosition("player")
-- local _, pwx2, pwh2, pwy2 = GetUnitWorldPosition("player")

-- GetMapTileTexture()    whats that??

--[[
local x, y = GetMapPlayerPosition("player")
local numTiles = GetMapNumTiles()
local tilePixelWidth = ZO_WorldMapContainer1:GetTextureFileDimensions()
local totalPixels = numTiles * tilePixelWidth
local w, h = ZO_WorldMapScroll:GetDimensions()
]]

-- 			needChange, oldMapType, mapId = not DoesCurrentMapMatchMapForPlayerLocation(), GetMapType(), GetMapTileTexture()
-- DoesCurrentMapShowPlayerWorld()

-- Search on ESOUI Source Code WorldPositionToGuiRender3DPosition(integer worldX, integer worldY, integer worldZ)
-- Returns: number renderX, number renderY, number renderZ 

-- 	local subzone=string.match(string.gsub(GetMapTileTexture(),"_base[_%w]*",""),"([%w%-_]+).dds$")

-- GetMapType(), -- Returns: UIMapType mapType: https://wiki.esoui.com/Globals#UIMapType
