-- TODO
-- Scale slider to config for each mode
-- Group delve own settings option
-- Calibration interface changes 
--    Add two sections with changable distance and saving to saved variables
--    Remove party leader lookup
--    Remove party leader distance coords calculation from forms
--    Add main zone name to saved calibration data  GetPlayerActiveZoneName()  (Test delves and some quest places, sewers ... etc)
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

local MR = MapRadar
local MRPin = MapRadarPin
local radarTexture = MapRadarContainerRadarTexture

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
    for k, radarPin in pairs(MR.activePins) do
        if radarPin.isCorrupted or not MRPin:IsValidPin(radarPin.pin) or pins[k] ~= radarPin.pin then
            MR.activePins[k]:Dispose()
            MR.activePins[k] = nil
        end
    end

    local playerX, playerY = getMapPlayerPosition("player")
    local heading = getPlayerCameraHeading()

    -- Add new pins that did not exist
    for key, pin in pairs(pins) do
        if MR.activePins[key] == nil and MRPin:IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local radarPin = MRPin:New(pin, key)
            radarPin:UpdatePin(playerX, playerY, heading, true)
            MR.activePins[key] = radarPin
        end
    end
end

-- ==================================================================================================
-- Mode change
local function setOverlayMode(flag)
    MR.playerPinTexture:ClearAnchors()
    radarTexture:SetHidden(flag)

    if flag then
        MR.playerPinTexture:SetAnchor(CENTER, GuiRoot, BOTTOM, 0, -UIHeight * 0.4)
        MR.maxRadarDistance = UIHeight * 0.5
        MR.pinSize = 25
    else
        MR.playerPinTexture:SetAnchor(CENTER, MapRadarContainer, CENTER)
        MR.maxRadarDistance = 110
        MR.pinSize = 20
    end

    MR.config.isOverlayMode = flag

    if flag then
        MR.modeSettings = MR.config.overlaySettings
    else
        MR.modeSettings = MR.config.radarSettings
    end
    CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
end

local function updateOverlay()
    if MR.config.isOverlayMode then
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

    radarTexture:SetTextureRotation(-heading, 0.5, 0.5)

    -- reposition pins
    for key, radarPin in pairs(MR.activePins) do
        radarPin:UpdatePin(playerX, playerY, heading, hasPlayerMoved)
    end
end

local function mapPinIntegrityCheck()
    for key, radarPin in pairs(MR.activePins) do
        if not radarPin:CheckIntegrity() then
            radarPin.isCorrupted = true
            CALLBACK_MANAGER:FireCallbacks("MapRadar_CorruptedPin")
        end
    end
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
    MR.playerPinTexture = playerPinTexture

    --[[
    local positionLabel = CreateControl("$(parent)PositionLabel", MapRadarContainer, CT_LABEL)
    positionLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT)
    positionLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    positionLabel:SetColor(unpack({1, 1, 1, 1}))
    MR.positionLabel = positionLabel
    ]]

    -- Set mode to radar from start (should be saved to variables later)
    setOverlayMode(MR.config.isOverlayMode);

    local fragment = ZO_SimpleSceneFragment:New(MapRadarContainer)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)

    EVENT_MANAGER:RegisterForUpdate("MapRadar_OnUpdate", 30, mapUpdate)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinRefresh", 200, registerMapPins)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinCheck", 300, mapPinIntegrityCheck)

    CALLBACK_MANAGER:RegisterCallback(
        "MapRadar_Reset", function()
            playerHeading = 0
        end)

    CALLBACK_MANAGER:FireCallbacks("OnMapRadarInitialized")
end

-- ==================================================================================================
-- Event subscribtion

-- This is good to trigger pin reset (if quest chnages 1 marker then pin count check does not see difference)
EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_ADVANCED, function()
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_COMPLETE, function()
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_ADDED, function()
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_POSITION_REQUEST_COMPLETE, function()
        zo_callLater(registerMapPins, 200)
    end)

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_QUEST_CONDITION_COUNTER_CHANGED, function()
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

        if count == 1 then
            return setOverlayMode(not MR.config.isOverlayMode)
        end

        if count == 2 then
            return MapRadar_toggleSettings()
        end

        if count == 3 then
            -- ZO_ActionBarAssignmentManager:SetCurrentHotbar(HOTBAR_CATEGORY_BACKUP)
            -- ZO_ActionBarAssignmentManager.hotbarProxy()
        end

    end)

ZO_CreateStringId("SI_BINDING_NAME_MAPRADAR_HOTKEY", "Hotkey")

-- Handler for configured hotkey
function MapRadar_Hotkey()
    hotkeyDebouncer:Invoke()
end

-- ==================================================================================================
-- Slash commands
local function slashCommands(args)
    if args == "config" then
        MapRadar_toggleSettings()
    end

    if args == "mode" then
        setOverlayMode(not MR.config.isOverlayMode)
    end

    if args == "all" then
        MR.showAllPins = not MR.showAllPins
        local flagStr = MR.showAllPins and "ON" or "OFF"
        MR.debug("Show all pins: <<1>>", flagStr)
    end

    if args == "names" then
        MR.showPinNames = not MR.showPinNames
        local flagStr = MR.showPinNames and "ON" or "OFF"
        MR.debug("Show names: <<1>>", flagStr)
    end

    if args == "para" then
        MR.showPinParams = not MR.showPinParams
        local flagStr = MR.showPinParams and "ON" or "OFF"
        MR.debug("Show params: <<1>>", flagStr)
    end

    if args == "calibrate" then
        MR.config.showCalibrate = not MR.config.showCalibrate
        local flagStr = MR.config.showCalibrate and "ON" or "OFF"
        MR.debug("Show calibrate: <<1>>", flagStr)
    end

    if args == "analyzer" then
        MR.config.showAnalyzer = not MR.config.showAnalyzer
        local flagStr = MR.config.showAnalyzer and "ON" or "OFF"
        MR.debug("Show analyzer: <<1>>", flagStr)
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
