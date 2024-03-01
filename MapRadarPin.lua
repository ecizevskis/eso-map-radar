MapRadarPin = {}

local pinManager = ZO_WorldMap_GetPinManager()

local pinPool = ZO_ControlPool:New("PinTemplate", MapRadarContainer, "Pin")
local pointerPool = ZO_ControlPool:New("PointerTemplate", MapRadarContainer, "Pointer")
local distanceLabelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Distance")

-- ========================================================================================
-- helper methods

local function IsCustomQuestPin(pinType)
    -- First chek if this pin type is not default.

    -- Can check QuestMap pins here by name because pinType is dynamic most likely (depends on addon count and who register id first)

    --[[
    local cpin1 = pinManager.customPins[293]
    if (cpin1 ~= nil) then
        MapRadar.debug("Custom pin <<1>> is <<2>>", pinType, cpin1.pinTypeString)
    end
    --]]

    if pinType == 293 -- QuestMap_uncompleted?  Unaquired quest markers. Need to find you what constant that is or what Is<> method
    -- or pinType == 295 -- QuestMap_hidden?  Unaquired quest markers. Need to find you what constant that is or what Is<> method
    -- or pinType == 315 -- chests
    or pinType == 301 -- QuestMap_zonestory?  zone story quest to grab
    then
        return true
    end

    return false
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

-- ========================================================================================
-- MapRadarPin handling methods
function MapRadarPin:SetVisibility()
    -- For some pin tpes they should be visible only in certain range
    if IsCustomQuestPin(self.pinType) and self.distance > 1200 then
        self.texture:SetHidden(true)
        return false
    end

    self.texture:SetHidden(false)

    local alpha = 1
    if (self.distance > MapRadar.maxDistance * 2) then
        alpha = 0.3 -- maximum fade in so that icon is still seen
    elseif self.distance > MapRadar.maxDistance then
        alpha = 1 - (self.distance - MapRadar.maxDistance) / MapRadar.maxDistance
    end

    self.texture:SetAlpha(alpha)
    return true
end

function MapRadarPin:SetPinDimensions()
    -- If value did not change then there is no need to trigger any UI actions
    if self.size ~= nil and self.size == MapRadar.pinSize then
        return
    end

    self.texture:SetDimensions(MapRadar.pinSize, MapRadar.pinSize)
    self.size = MapRadar.pinSize
end

function MapRadarPin:UpdatePin(playerX, playerY, heading, curvedZoom)
    local relative_dx = self.pin.normalizedX - playerX
    local relative_dy = self.pin.normalizedY - playerY

    local dx = relative_dx * MapRadar.currentMapWidth * MapRadar.scale
    local dy = relative_dy * MapRadar.currentMapHeight * MapRadar.scale

    local angle = math.atan2(-dx, -dy) - heading
    self.distance = math.sqrt(dx ^ 2 + dy ^ 2)
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

        if MapRadar.showAllPins then
            self.distanceLabel:SetText(zo_strformat("<<1>> <<2>>", self.pinType, MR_PinTypeNames[self.pinType]))
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

    if pinType == MAP_PIN_TYPE_PLAYER -- or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pin:GetPinType() == MAP_PIN_TYPE_DRAGON_IDLE_WEAK 
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
    -- or pin:IsFastTravelWayShrine() or pin:IsFastTravelKeep() or pin:IsAntiquityDigSitePin() 
    or IsCustomQuestPin(pinType) then
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

    radarPin.texture = texture
    radarPin.key = key
    radarPin.pin = pin
    radarPin.pinType = pin:GetPinType()
    radarPin.texture:SetTexture(GetIcon(pin))

    local pinData = ZO_MapPin.PIN_DATA[radarPin.pinType]
    if pinData ~= nil and pinData.tint ~= nil then
        radarPin.texture:SetColor(pinData.tint:UnpackRGBA())
    end

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
    pinPool:ReleaseAllObjects()
    pointerPool:ReleaseAllObjects()
    distanceLabelPool:ReleaseAllObjects()
end
