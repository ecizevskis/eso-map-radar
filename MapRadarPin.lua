MapRadarPin = {}

local zoMapPin = ZO_MapPin
local pinPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local pointerPool = ZO_ControlPool:New("PointerTemplate", MapRadarContainer, "Pointer")
local distanceLabelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Distance")

-- ========================================================================================
-- helper methods
-- TODO: convert to table with zone name and data params + defaults
local function getMeterCoefficient()

    --[[
    local mapToMeterCoefficients = {
        [3156] = 0.0003, -- Standard zone
        [1554] = 0.00145 -- Standard subzone
    }
--]]

    -- TODO: this is not good. Subzone map changes faster than zone name load

    -- using defaults for zone types
    if MapRadar.getMapType() == MAPTYPE_SUBZONE then
        -- MapRadar.debugDebounce("Assuming subzone meter: <<1>>", MapRadar.worldMap.zoneName)
        return 0.00145
    end

    -- MapRadar.debugDebounce("Assuming zone meter: <<1>>", MapRadar.worldMap.zoneName)
    return 0.0003
end

local function customPinName(pinType)
    local cpin = MapRadar.pinManager.customPins[pinType]
    if (cpin ~= nil) then
        return cpin.pinTypeString
    end

    return nil
end

local function IsWorldMapUnit(pinType)
    return pinType == MAP_PIN_TYPE_UNIT_IDLE_HEALTHY or pinType == MAP_PIN_TYPE_UNIT_COMBAT_HEALTHY
    -- or pinType == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pinType == MAP_PIN_TYPE_DRAGON_COMBAT_HEALTHY or pinType ==  MAP_PIN_TYPE_DRAGON_IDLE_WEAK 
end

local function IsCustomPin(pinType)
    -- First chek if this pin type is not default??

    -- Can check QuestMap pins here by name because pinType is dynamic most likely (depends on addon count and who register id first)

    if customPinName(pinType) == "QuestMap_uncompleted" or customPinName(pinType) == "QuestMap_zonestory" -- or pinType == 315 -- chests
    -- or customPinName(pinType) == "pinType_Treasure_Maps" -- from "Map Pins" by Hoft
    or customPinName(pinType) == "LostTreasure_SurveyReportPin" -- Survey from LostTreasure
    or customPinName(pinType) == "LostTreasure_TreasureMapPin" -- Treasure from LostTreasure
    then
        return true
    end

    return false
end

local function IsValidPOI(pin)
    local pinType = pin:GetPinType()
    -- Check here for ingame POI or other addons like Map Pins or Destinations 
    -- Filter what POIs to show (guess by texture path) based on how config is set

    -- pinType_Unknown_POI  (Map Pins)       alternative for POI pins
    -- DEST_PinSet_Unknown  (Destinations)   alternative for POI pins

    if customPinName(pinType) == "pinType_Unknown_POI" or customPinName(pinType) == "DEST_PinSet_Unknown" then
        -- TODO: check texture here 
        return true
    end

    return false
end

local function IsValidForPointer(pin)
    -- List only specific pins to have pointers. just active quest pins now
    if pin:IsQuest() then
        return true;
    end

    return false;
end

local function GetTintColor(radarPin)
    local pinData = zoMapPin.PIN_DATA[radarPin.pinType]
    if (pinData == nil or pinData.tint == nil) then
        return unpack({1, 1, 1, 1})
    end

    if type(pinData.tint) == "function" then
        return pinData.tint(radarPin.pin):UnpackRGBA()
    else
        return pinData.tint:UnpackRGBA()
    end
end

local function GetIcon(radarPin)
    local pinData = zoMapPin.PIN_DATA[radarPin.pinType]
    if (pinData == nil or pinData.texture == nil) then
        return "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds" -- unknown pin
    end

    if type(pinData.texture) == "function" then
        return pinData.texture(radarPin.pin)
    end

    return pinData.texture
end

-- ========================================================================================
-- MapRadarPin handling methods
function MapRadarPin:SetHidden(flag)
    self.texture:SetHidden(flag)
    if self.distanceLabel ~= nil then
        self.distanceLabel:SetHidden(flag)
    end
    if self.pointer ~= nil then
        self.pointer:SetHidden(flag)
    end
end

function MapRadarPin:SetVisibility()
    -- Most pin types they should be visible only in certain range
    if (not self.pin:IsQuest() and not self.pin:IsUnit() and self.distance > 1200) then
        self:SetHidden(true)
        return false
    end

    self:SetHidden(false)

    local maxAlpha = 0.6

    local alpha = maxAlpha
    if (self.distance > MapRadar.maxDistance * 2) then
        alpha = 0.3 -- maximum fade in so that icon is still seen
    elseif self.distance > MapRadar.maxDistance then
        alpha = maxAlpha - (self.distance - MapRadar.maxDistance) / MapRadar.maxDistance
    end

    self.texture:SetAlpha(alpha)
    return true
end

function MapRadarPin:SetPinDimensions()

    -- TODO: somehow add scaling for radar and overlay
    -- if self.size ~= nil and self.size == MapRadar.pinSize then
    --    return
    -- end

    local pinData = ZO_MapPin.PIN_DATA[self.pinType]
    if (pinData == nil or pinData.size == nil) then
        self.size = pinData.size
        self.scaledSize = pinData.size
    else
        self.size = MapRadar.pinSize
        self.scaledSize = MapRadar.pinSize
    end

    self.texture:SetDimensions(self.scaledSize, self.scaledSize)
    -- self.size = MapRadar.pinSize
end

function MapRadarPin:UpdatePin(playerX, playerY, heading, curvedZoom)
    local dx = self.pin.normalizedX - playerX
    local dy = self.pin.normalizedY - playerY

    local angle = math.atan2(-dx, -dy) - heading
    self.distance = math.sqrt(dx ^ 2 + dy ^ 2) / getMeterCoefficient()
    local radarDistance = math.min(MapRadar.maxDistance, self.distance)

    -- recalc coordinates to apply rotation
    dx = radarDistance * -math.sin(angle)
    dy = radarDistance * -math.cos(angle)

    if self.pointer ~= nil then
        self.pointer:SetTextureRotation(angle, 0.5, 1)
        if radarDistance < 64 then
            self.pointer:SetDimensions(8, radarDistance)
        end
    end

    -- Show distance (or other test data) near pin on radar
    if (self.distanceLabel ~= nil) then
        self.distanceLabel:SetText(zo_strformat("<<1>>", self.distance))

        if MapRadar.showPinLoc then
            self.distanceLabel:SetText(zo_strformat("<<1>>   <<2>>", ZO_LocalizeDecimalNumber(self.pin.normalizedX),
                                                    ZO_LocalizeDecimalNumber(self.pin.normalizedY)))
        end

        if MapRadar.showAllPins then
            local name = MR_PinTypeNames[self.pinType] or customPinName(self.pinType)
            self.distanceLabel:SetText(zo_strformat("<<1>> <<2>>", self.pinType, name))
        end
    end

    -- Set visibility (hidden or transparency) and if not vissible then stop processing further 
    if not self:SetVisibility() then
        return
    end

    -- Resize pin 
    self:SetPinDimensions()

    -- Reposition pin
    self.texture:ClearAnchors()
    self.texture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER, dx, dy)
end

-- ========================================================================================
-- Static methods
function MapRadarPin:IsValidPin(pin)
    local pinType = pin:GetPinType()

    if pinType == MAP_PIN_TYPE_PLAYER -- or pinType == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pinType == MAP_PIN_TYPE_DRAGON_IDLE_WEAK 
    or pin:IsCompanion() then
        return false
    end

    if pin:IsQuest() -- or pin:IsObjective() -- or pin:IsAvAObjective()
    or pin:IsUnit() -- Player/Group/Companion units
    -- or pin:IsPOI() 
    or pin:IsAssisted() -- or pin:IsMapPing()
    -- or pin:IsKillLocation()
    -- or pin:IsWorldEventUnitPin()
    -- or pin:IsZoneStory() or pin:IsSuggestion() -- or pin:IsAreaPin()
    or pinType == MAP_PIN_TYPE_POI_SEEN or pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() -- or pin:IsAntiquityDigSitePin() 
    or IsWorldMapUnit(pinType) or IsCustomPin(pinType) or IsValidPOI(pin) then
        return true
    end

    return MapRadar.showAllPins
end

-- ========================================================================================
-- ctor
function MapRadarPin:New(pin, key)
    local radarPin = {}
    setmetatable(radarPin, self)
    self.__index = self

    local texture, textureKey = pinPool:AcquireObject()
    local pinType, pinTag = pin:GetPinTypeAndTag()

    radarPin.texture = texture
    radarPin.key = key
    radarPin.pin = pin
    radarPin.pinType = pinType
    radarPin.pinTag = pinTag
    radarPin.texture:SetTexture(GetIcon(radarPin))
    radarPin.texture:SetColor(GetTintColor(radarPin))

    if MapRadar.showDistance then
        local label = distanceLabelPool:AcquireObject()
        label:SetAnchor(TOPLEFT, radarPin.texture, TOPRIGHT)
        radarPin.distanceLabel = label
    end

    if MapRadar.showPointer and IsValidForPointer(pin) then
        local pointerTexture, pointerKey = pointerPool:AcquireObject()
        pointerTexture:SetTexture("MapRadar/textures/pointer.dds")
        pointerTexture:SetAnchor(BOTTOM, MapRadar.playerPinTexture, CENTER)
        pointerTexture:SetAlpha(0.5)
        pointerTexture:SetDimensions(8, 64)
        radarPin.pointer = pointerTexture
    end

    return radarPin
end

-- ========================================================================================
-- deconstruct
function MapRadarPin:Dispose()
    self.texture:ClearAnchors()

    -- TODO release only this and assigned childs

end

function MapRadarPin:ReleaseAll()
    pointerPool:ReleaseAllObjects()
    distanceLabelPool:ReleaseAllObjects()
    pinPool:ReleaseAllObjects()
end
