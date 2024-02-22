local MapRadar = {}
local playerPin = ZO_WorldMap_GetPinManager():GetPlayerPin()
local pinsPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local activePins = {}
local currentMapWidth = 0
local currentMapHeight = 0
local positionLabel = {}

local function getVal(obj)
    if obj == nil then
        return "nil"
    end
    return tostring(obj)
end

function MapRadar_button()
    local atanRes = math.atan(12, 24)

    -- d(zo_strformat("Atan result: <<1>>", atanRes))

    currentMapWidth, currentMapHeight = ZO_WorldMap_GetMapDimensions()
    local x, y, h = GetMapPlayerPosition("player")

    -- :GetCurrentCurvedZoom()
    -- :GetCurrentNormalizedZoom()

    -- local scale = ZO_WorldMap_GetPanAndZoom():GetCurrentZoom()

    d(zo_strformat("Map dimension: <<1>> <<2>>, Player coords: <<3>> <<4>> <<5>>", currentMapWidth, currentMapHeight, x, y, h))
    d(zo_strformat("Map curvedZoom: <<1>>, NormalizedZoom: <<2>>", ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom(),
                   ZO_WorldMap_GetPanAndZoom():GetCurrentNormalizedZoom()))
end

-- Create control pool
-- FooBar_Bar.barsPool = ZO_ControlPool:New("FooBar", FooBarContainer, "Bar")

-- Create new control in pool
-- self.barsPool:ReleaseObject(self.barKey)

-- Release from pool
-- 	self.barsPool:ReleaseObject(self.barKey)

-- function ZO_MapPin:GetQuestIcon()
--	if self.m_PinTag.isBreadcrumb then
--		return breadcrumbQuestPinTextures[self:GetPinType()]
--	else
--		return questPinTextures[self:GetPinType()]
--	end
-- end

-- ZO_MapPin.SelectedAnimation =
-- {
--    texture = "EsoUI/Art/WorldMap/selectedQuestHighlight.dds",
--    duration = LOOP_INDEFINITELY,
--    type = ZO_MapPin.ANIMATION_ALPHA,
-- }

-- local orgGetNormalizedPositionFocusZoomAndOffset = ZO_MapPanAndZoom.GetNormalizedPositionFocusZoomAndOffset
-- function ZO_MapPanAndZoom:GetNormalizedPositionFocusZoomAndOffset(normalizedX, normalizedY, useCurrentZoom)
--	if WORLD_MAP_MANAGER:GetMode() ~= MAP_MODE_VOTANS_MINIMAP then
--		return orgGetNormalizedPositionFocusZoomAndOffset(self, normalizedX, normalizedY, useCurrentZoom)
--	else
--		return FocusZoomAndOffset(self, normalizedX, normalizedY)
--	end
-- end

local function IsValidPin(pin)
    if pin == playerPin or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_WEAK or
        pin:GetPinType() == MAP_PIN_TYPE_ACTIVE_COMPANION then
        return false
    end

    if pin:IsQuest() or pin:IsObjective() -- or pin:IsAvAObjective()
    -- or pin:IsUnit()
    -- or pin:IsPOI()
    or pin:IsAssisted() -- or pin:IsMapPing()
    -- or pin:IsKillLocation()
    -- or pin:IsWorldEventUnitPin()
    or pin:IsZoneStory() or pin:IsSuggestion() -- or pin:IsAreaPin()
    or pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() or pin:IsAntiquityDigSitePin() then
        return true
    end

    return false
end

local function GetIcon(pin)
    if pin:IsQuest() then
        return pin:GetQuestIcon()
    end

    if pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() then
        return pin:GetFastTravelIcons()
    end

    return "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds"
end

local function clearPins()
    -- Clear existing pins
    for k in pairs(activePins) do
        activePins[k]:ClearAnchors()
        activePins[k] = nil
    end
    pinsPool:ReleaseAllObjects()
end

-- https://www.codecademy.com/resources/docs/lua/tables

-- https://esoapi.uesp.net/100031/src/ingame/map/mappin.lua.html
-- https://esodata.uesp.net/100025/src/ingame/map/worldmap.lua.html
local function registerMapPins()
    local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()

    -- TODO: create filter methods that return filtered pins 

    for pinKey, pin in pairs(pins) do
        -- d(zo_strformat("Looped pin: <<1>>,  Val: <<2>>", pinKey, getVal(pin)))

        if IsValidPin(pin) and pin.normalizedX and pin.normalizedY then
            local pinTexture, pinTextureKey = pinsPool:AcquireObject()

            pinTexture.x = pin.normalizedX
            pinTexture.y = pin.normalizedY
            pinTexture.pin = pin
            pinTexture:SetTexture(GetIcon(pin))

            activePins[pinTextureKey] = pinTexture
            -- d(zo_strformat("Added pin: <<1>>,  Normalized: <<2>> <<3>>", pinTextureKey, pin.normalizedX, pin.normalizedY))
        end
    end
end

local function pinReset()
    local playerZone = GetPlayerActiveZoneName()
    local playerSubZone = GetPlayerActiveSubzoneName()
    local zoneName = ZO_WorldMap.zoneName

    -- If map zone name does not match player zone/subzone that means map is just navigated and should not regenerate pins.
    if zoneName ~= playerZone and zoneName ~= playerSubZone then
        -- d(zo_strformat("pZone: <<2>>,  pSubZone: <<3>>,  Zone: <<4>>", mapName, playerZone, playerSubZone, zoneName))

        -- For now let it stay without filter. Surfing map gegenerates pins but closing them back generates them as was
        -- with this regen it guarantees to regen pins in some map changes where GetPlayerActiveSubzoneName() does not return correct value still

        -- return 
    end

    -- d("Pin reset")
    -- Trigger pin reset
    clearPins()
    registerMapPins()
end

-- ========================================================================================
-- pinTexure handling methods

local function calcPinTextureParams(pinTexture, playerX, playerY, curvedZoom)
    local scale = 100

    local dx = (pinTexture.x - playerX) * currentMapWidth
    local dy = (pinTexture.y - playerY) * currentMapHeight
    local size = 25 -- change this to be based on distance calculated

    -- TODO: need to calculate distance (at least relative as percents)

    -- TODO: need to calculate angle

    -- TODO: based on new angle and relative distance need to calculate new dx and dy

    -- TODO: need to return translparency/opacity of texture based on 

    return dx, dy, size
end

local function setPinDimensions(pinTexture, size)
    -- If value did not change then there is no need to trigger any UI actions
    if pinTexture.size ~= nil and pinTexture.size == size then
        return
    end

    pinTexture:SetDimensions(size, size)
    pinTexture.size = size
end

-- ==================================================================================================
-- Event handlers

-- zoneChangeCheck might not be needed at all
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

    d(zo_strformat("ZoneChange: zone: <<1>>, subzone: <<2>>", playerZone, playerSubZone))

    -- Trigger pin reset
    pinReset()
end

local function mapUpdate()
    local heading = GetPlayerCameraHeading()
    MapRadarContainerRadarTexture:SetTextureRotation(heading, 0.5, 0.5)

    -- read map width and height to local params not to invoke method in loop
    currentMapWidth, currentMapHeight = ZO_WorldMap_GetMapDimensions()

    local playerX, playerY = GetMapPlayerPosition("player")
    local curvedZoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()

    positionLabel:SetText(zo_strformat("Pos:  <<1>> <<2>>", playerX * 100, playerY * 100))

    -- reposition pins
    for k in pairs(activePins) do
        local pinTexture = activePins[k]
        local dx, dy, size = calcPinTextureParams(pinTexture, playerX, playerY, curvedZoom)
        pinTexture:ClearAnchors()
        pinTexture:SetAnchor(BOTTOM, MapRadarContainer, CENTER, dx, dy)
        setPinDimensions(pinTexture, size)
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
    pinReset()
end

local function initialize(eventType, addonName)
    if addonName ~= "MapRadar" then
        return
    end

    local playerPinTexture = CreateControl("$(parent)PlayerPin", MapRadarContainer, CT_TEXTURE)
    playerPinTexture:SetTexture("EsoUI/Art/MapPins/UI-WorldMapPlayerPip.dds")
    playerPinTexture:SetAnchor(CENTER, MapRadarContainer, CENTER)
    playerPinTexture:SetDimensions(20, 20)

    positionLabel = CreateControl("$(parent)PositionLabel", MapRadarContainer, CT_LABEL)
    positionLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT)
    positionLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    positionLabel:SetColor(unpack({1, 1, 1, 1}))

    local fragment = ZO_SimpleSceneFragment:New(MapRadarContainer)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)

    EVENT_MANAGER:RegisterForUpdate("MapRadar_OnUpdate", 100, mapUpdate)
    EVENT_MANAGER:RegisterForUpdate("MapRadar_PinCount", 100, mapPinCountCheck)
    CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function()
        -- d("OnWorldMapChanged")
        -- pinReset()
        -- zoneChangeCheck()
    end)
end

-- ==================================================================================================
-- Event subscribtion

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_ADD_ON_LOADED, initialize)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_PLAYER_IN_PIN_AREA_CHANGED, function()
    d(zo_strformat("EVENT_PLAYER_IN_PIN_AREA_CHANGED"))
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_OBJECTIVE_CONTROL_STATE, function()
    d(zo_strformat("EVENT_OBJECTIVE_CONTROL_STATE"))
end)

-- This is good to trigger pin reset (if quest chnages 1 marker then pin count check does not see difference)
EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_ADVANCED, function()
    -- d(zo_strformat("EVENT_QUEST_ADVANCED"))
    zo_callLater(pinReset, 200)
end)

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_QUEST_COMPLETE, function()
    -- d(zo_strformat("EVENT_QUEST_COMPLETE"))
    zo_callLater(pinReset, 200)
end)

