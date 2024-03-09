-- TODO: 
-- Some random pind get animated 
-- on disabling showDistance need to close them all? or hide sonehow?
-- area pins / blobs
MapRadarPin = {}

local zoMapPin = ZO_MapPin
local pinPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local pointerPool = ZO_ControlPool:New("PointerTemplate", MapRadarContainer, "Pointer")
local pinLabelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Distance")

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
    or customPinName(pinType) == "SkySMapPin_unknown" -- Destinations? Sky shards addon?
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

-- ========================================================================================
-- MapRadarPin handling methods
function MapRadarPin:SetHidden(flag)
    self.texture:SetHidden(flag)
    if self.label ~= nil then
        self.label:SetHidden(flag)
    end
    if self.pointer ~= nil then
        self.pointer:SetHidden(flag)
    end
end

function MapRadarPin:SetVisibility()
    -- Most pin types they should be visible only in certain range
    -- Quest and Group are shown across all map
    if (not self.pin:IsQuest() and not self.pin:IsUnit() and self.distance > MapRadar.maxRadarDistance * 2) then
        self:SetHidden(true)
        return false
    end

    self:SetHidden(false)

    -- Maybe grouop should not fade that much??!

    local maxAlpha = 1

    local alpha = maxAlpha
    if self.distance > MapRadar.maxRadarDistance then
        alpha = math.max(0.4, maxAlpha - (self.distance - MapRadar.maxRadarDistance) / MapRadar.maxRadarDistance)
    end

    self.texture:SetAlpha(alpha)

    if self.label ~= nil then
        self.label:SetAlpha(alpha)
    end
    return true
end

function MapRadarPin:SetPinDimensions()

    -- TODO: somehow add scaling for radar and overlay
    -- if self.size ~= nil and self.size == MapRadar.pinSize then
    --    return
    -- end

    local pinData = ZO_MapPin.PIN_DATA[self.pinType]
    if (pinData ~= nil or pinData.size ~= nil) then
        self.size = pinData.size
    else
        self.size = MapRadar.pinSize
    end

    -- Min scale: 0.6, max scale: 0.9
    local distanceScale = math.max(0.6, 0.9 - self.distance / MapRadar.maxRadarDistance)

    self.scaledSize = self.size * distanceScale
    self.texture:SetDimensions(self.scaledSize, self.scaledSize)
end

function MapRadarPin:ApplyTexture()
    local texture = "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds" -- unknown pin

    if self.animationTimeline then
        self.animationTimeline:Stop()
    end

    local pinData = zoMapPin.PIN_DATA[self.pinType]

    if (pinData ~= nil and pinData.texture ~= nil) then
        texture = MapRadar.value(pinData.texture, self.pin)

        if MapRadar.value(pinData.isAnimated, self.pin) then
            self.animation, self.animationTimeline = CreateSimpleAnimation(ANIMATION_TEXTURE, self.texture)
            self.animation:SetImageData(pinData.framesWide, pinData.framesHigh)
            self.animation:SetFramerate(pinData.framesPerSecond)

            -- is this doing something??
            -- self.animation:SetHandler("OnStop", function()
            --    self.texture:SetTextureCoords(0, 1, 0, 1)
            -- end)

            self.animationTimeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
            self.animationTimeline:PlayFromStart()
        end
    end

    self.texture:SetTexture(texture)
end

function MapRadarPin:ApplyTint()
    local pinData = zoMapPin.PIN_DATA[self.pinType]

    if (pinData ~= nil and pinData.tint ~= nil) then
        self.texture:SetColor(MapRadar.value(pinData.tint, self.pin):UnpackRGBA())
        return
    end

    self.texture:SetColor(unpack({1, 1, 1, 1}))
end

--[[
function MapRadarPin:CheckIfShouldStopAnimation()
    local pinData = zoMapPin.PIN_DATA[self.pinType]
    if (pinData ~= nil and pinData.texture ~= nil) then
        if MapRadar.value(pinData.isAnimated, self.pin) then
            return
        end
    end

    if self.animationTimeline then
        self.animationTimeline:Stop()
    end
end
--]]

function MapRadarPin:UpdatePin(playerX, playerY, heading)
    local dx = self.pin.normalizedX - playerX
    local dy = self.pin.normalizedY - playerY

    local angle = math.atan2(-dx, -dy) - heading
    self.distance = math.sqrt(dx ^ 2 + dy ^ 2) / getMeterCoefficient()
    local radarDistance = math.min(MapRadar.maxRadarDistance, self.distance)

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
    if (self.label ~= nil) then
        self.label:SetText(zo_strformat("<<1>>", self.distance))

        if MapRadar.showPinLoc then
            self.label:SetText(zo_strformat("<<1>>   <<2>>", ZO_LocalizeDecimalNumber(self.pin.normalizedX),
                                            ZO_LocalizeDecimalNumber(self.pin.normalizedY)))
        end

        if MapRadar.showPinNames then
            local name = MR_PinTypeNames[self.pinType] or customPinName(self.pinType)
            self.label:SetText(zo_strformat("<<1>> <<2>>", self.pinType, name))
        end

        if MapRadar.showPinParams then
            local pinData = zoMapPin.PIN_DATA[self.pinType]
            if pinData ~= nil then
                local animatedStr = MapRadar.value(pinData.isAnimated, self.pin) and "[A]" or "[N]"
                -- later add more
                self.label:SetText(zo_strformat("<<1>>", animatedStr))
            end
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

    -- Reset texture params
    -- self:ApplyTexture()  -- This crashes on map open, maybe because of pins being destroyed? Reenable once pin reload is done while map not opened??
    self:ApplyTint()
    -- self:CheckIfShouldStopAnimation() -- Maybe this is just temporary till ApplyTexture does not throw errors?
end

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
    pin.mapRadarKey = key .. pinType

    radarPin.texture = texture
    radarPin.textureKey = textureKey

    radarPin.key = key
    radarPin.pin = pin
    radarPin.pinType = pinType
    radarPin.pinTag = pinTag

    radarPin:ApplyTexture()
    radarPin:ApplyTint()

    if MapRadar.showDistance then
        local label, labelKey = pinLabelPool:AcquireObject()
        label:SetAnchor(TOPLEFT, radarPin.texture, TOPRIGHT)
        radarPin.label = label
        radarPin.labelKey = labelKey
    end

    if MapRadar.showPointer and IsValidForPointer(pin) then
        local pointerTexture, pointerKey = pointerPool:AcquireObject()
        pointerTexture:SetTexture("MapRadar/textures/pointer.dds")
        pointerTexture:SetAnchor(BOTTOM, MapRadar.playerPinTexture, CENTER)
        pointerTexture:SetAlpha(0.5)
        pointerTexture:SetDimensions(8, 64)
        radarPin.pointer = pointerTexture
        radarPin.pointerKey = pointerKey
    end

    return radarPin
end

-- ========================================================================================
-- deconstruct
function MapRadarPin:Dispose()

    if self.animationTimeline then
        self.animationTimeline:Stop()
        self.animationTimeline = nil
        self.animation = nil
    end

    self.texture:ClearAnchors()
    pinPool:ReleaseObject(self.textureKey)
    self.textureKey = nil
    self.texture = nil

    if self.pointer ~= nil then
        self.pointer:ClearAnchors()
        pointerPool:ReleaseObject(self.pointerKey)
        self.pointerKey = nil
        self.pointer = nil
    end

    if self.label ~= nil then
        self.label:SetText("")
        pinLabelPool:ReleaseObject(self.labelKey)
        self.labelKey = nil
        self.label = nil
    end

    self.pin = nil
    self.pinType = nil
    self.pinTag = nil
    self.distance = nil
    self.size = nil
    self.scaledSize = nil
end

function MapRadarPin:ReleaseAll()
    pointerPool:ReleaseAllObjects()
    pinLabelPool:ReleaseAllObjects()
    pinPool:ReleaseAllObjects()
end
