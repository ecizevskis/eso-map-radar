-- TODO
-- Pointer fading like icon on distance
-- Create invoke analyzer
-- Debounce methods for key bindings
-- Automatic calibration calculation (from map width/height scale to specific 40 pixel count in offset )
-- Saved variable usage (save mode, save radar position)
-- Configuration page
-- Icon fading if distance is big (faded as constant if 2x maxDistance ... or gradient fade?)
-- Fast trakel wayshrines (up to 3 if in same distance +- some threshold)
-- Closest dolmen
-- Group via all map
-- Survey/Treasure if you have map/item (load from LibTreasure)
-- https://github.com/esoui/esoui/blob/3b9326af2f5946a748be4551bfce41672f084e39/esoui/ingame/map/worldmap.lua#L695
MapRadar = {
    showPointer = true,
    showDistance = false,

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

--[[

local function IsCustomQuestPin(pinType)
    -- These withouy name might be comming from LIB
    -- Unaquired quest markers. Need to find you what constant that is or what Is<> method

    if pinType == 293 -- Unaquired quest markers. Need to find you what constant that is or what Is<> method
    or pinType == 295 -- Unaquired quest markers. Need to find you what constant that is or what Is<> method
    -- or pinType == 315 -- chests
    or pinType == 301 -- zone story quest to grab
    then
        return true
    end
end

local function IsValidPin(pin)
    local pinType = pin:GetPinType()

    if pinType == playerPin -- or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_WEAK 
    or pin:IsCompanion() then
        return false
    end

    if pin:IsQuest() -- or pin:IsObjective() -- or pin:IsAvAObjective()
    or pin:IsUnit() -- Player/Group/Companion units
    -- or pin:IsPOI()
    -- or pin:IsCompanion()
    or pin:IsAssisted() -- or pin:IsMapPing()
    -- or pin:IsKillLocation()
    -- or pin:IsWorldEventUnitPin()
    -- or pin:IsZoneStory() or pin:IsSuggestion() -- or pin:IsAreaPin()
    -- or pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() or pin:IsAntiquityDigSitePin() 
    or IsCustomQuestPin(pinType) then
        return true
    end

    return MapRadar.showAllPins
end

local function IsValidForPointer(pin)

    -- List only specific pins to have pointers. usually just active quest pins
    if pin:IsQuest() or pin:IsAssisted() then
        return true;
    end

    return false;
end

local function GetIcon(pin)

    if pin:IsUnit() then
        -- return "MapRadar/textures/x.dds"
    end

    if pin:IsCompanion() then
        return "EsoUI/Art/MapPins/activeCompanion_pin.dds"
    end

    if pin:IsUnit() then
        return pin:GetGroupIcon()
    end

    if pin:IsQuest() then
        return pin:GetQuestIcon()
    end

    if pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() then
        return pin:GetFastTravelIcons()
    end

    local texture = ZO_MapPin.GetStaticPinTexture(pin:GetPinType())
    if texture ~= nil then
        return texture
    end

    return "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds"
end
--]]

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

    -- Add new pins
    local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()
    for key, pin in pairs(pins) do
        if MapRadarPin:IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local radarPin = MapRadarPin:New(pin, key)
            activePins[key] = radarPin
        end
    end
end

-- local function pinReset()
-- local playerZone = GetPlayerActiveZoneName()
-- local playerSubZone = GetPlayerActiveSubzoneName()
-- local zoneName = ZO_WorldMap.zoneName

-- If map zone name does not match player zone/subzone that means map is just navigated and should not regenerate pins.
-- if zoneName ~= playerZone and zoneName ~= playerSubZone then
-- MapRadar.debug("pZone: <<2>>,  pSubZone: <<3>>,  Zone: <<4>>", mapName, playerZone, playerSubZone, zoneName)

-- For now let it stay without filter. Surfing map gegenerates pins but closing them back generates them as was
-- with this regen it guarantees to regen pins in some map changes where GetPlayerActiveSubzoneName() does not return correct value still

-- return 
-- end

-- Trigger pin reset
-- clearPins()
-- registerMapPins()
-- end

-- ========================================================================================
-- pinTexure handling methods
--[[
local function setVisibility(pinTexture)
    -- For some pin tpes they should be visible only in certain range
    if IsCustomQuestPin(pinTexture.pin) and pinTexture.distance > 1500 then
        pinTexture:SetHidden(true)
        return false
    end

    pinTexture:SetHidden(false)

    local alpha = 1
    if (pinTexture.distance > MapRadar.maxDistance * 2) then
        alpha = 0.3 -- maximum fade in so that icon is still seen
    elseif pinTexture.distance > MapRadar.maxDistance then
        alpha = 1 - (pinTexture.distance - MapRadar.maxDistance) / MapRadar.maxDistance
    end

    pinTexture:SetAlpha(alpha)
    return true
end

local function setPinDimensions(pinTexture)
    -- If value did not change then there is no need to trigger any UI actions
    if pinTexture.size ~= nil and pinTexture.size == MapRadar.pinSize then
        return
    end

    pinTexture:SetDimensions(MapRadar.pinSize, MapRadar.pinSize)
    pinTexture.size = MapRadar.pinSize
end

-- local function calcHypotenuse(a, b)
--    return math.sqrt(a ^ 2 + b ^ 2)
-- end

local function updateTextureAlpha(pinTexture)
    local alpha = 1

    if (pinTexture.distance > MapRadar.maxDistance * 2) then
        alpha = 0.3 -- maximum fade in so that icon is still seen
    elseif pinTexture.distance > MapRadar.maxDistance then
        alpha = 1 - (pinTexture.distance - MapRadar.maxDistance) / MapRadar.maxDistance
    end

    pinTexture:SetAlpha(alpha)
end

local function updatePinTexture(pinTexture, playerX, playerY, heading, curvedZoom)
    local relative_dx = pinTexture.pin.normalizedX - playerX
    local relative_dy = pinTexture.pin.normalizedY - playerY

    local dx = relative_dx * MapRadar.currentMapWidth * MapRadar.scale
    local dy = relative_dy * MapRadar.currentMapHeight * MapRadar.scale

    local angle = math.atan2(-dx, -dy) - heading
    pinTexture.distance = math.sqrt(dx ^ 2 + dy ^ 2)
    local radarDistance = math.min(MapRadar.maxDistance, pinTexture.distance)

    -- recalc coordinates to apply rotation
    dx = radarDistance * -math.sin(angle)
    dy = radarDistance * -math.cos(angle)

    if pinTexture.pointer ~= nil then
        pinTexture.pointer:SetTextureRotation(angle, 0.5, 1)
        if radarDistance < 64 then
            pinTexture.pointer:SetDimensions(8, radarDistance)
        end
    end

    -- Show distance (or other test data) near pin on radar
    if (pinTexture.distanceLabel ~= nil) then
        pinTexture.distanceLabel:SetText(zo_strformat("<<1>>", pinTexture.distance))

        if MapRadar.showAllPins then
            pinTexture.distanceLabel:SetText(zo_strformat("<<1>> <<2>>", pinTexture.pin:GetPinType(), MR_PinTypeNames[pinTexture.pin:GetPinType()]))
        end
    end

    -- Set visibility (hidden or transparency) and if not vissible then stop processing further 
    if not setVisibility(pinTexture) then
        return
    end

    -- Resize pin 
    setPinDimensions(pinTexture)

    -- Reposition pin
    pinTexture:ClearAnchors()
    pinTexture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER, dx, dy)
end
--]]

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
    MapRadar.currentMapWidth, MapRadar.currentMapHeight = ZO_WorldMap_GetMapDimensions()

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

local function getMapScale()
    -- For now set very apporx scale

    -- Standard zone
    if MapRadar.currentMapWidth == 3156 or MapRadar.currentMapWidth == 2752 then
        return 4.15
    end

    -- Some DLC middle maps
    if MapRadar.currentMapWidth == 1945 then
        return 2.2
    end

    return 1.1 -- Standard subzone
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

    CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function()
        zo_callLater(function()
            MapRadar.scale = getMapScale()
        end, 200)

    end)

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
