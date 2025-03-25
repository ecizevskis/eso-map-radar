MapRadarCustomPin = {}

local zoMapPin = ZO_MapPin

local getCurrentMapId = GetCurrentMapId
local zoneData = MapRadarZoneData
local pinManager = ZO_WorldMap_GetPinManager()
local getMapType = GetMapType

-- ========================================================================================
-- helper methods
local function getMeterCoefficient()

    local zData = zoneData[getCurrentMapId()]
    if zData ~= nil then
        -- MapRadar.debugDebounce("Get zone unit1: <<1>>", MapRadar.getStrVal(zData))
        return zData, true
    end

    local calibratedData = MapRadar.config.scaleData[getCurrentMapId()]
    if calibratedData ~= nil and calibratedData.unit1 ~= nil then
        -- MapRadar.debugDebounce("Get calibrated zone unit1: <<1>>", MapRadar.getStrVal(calibratedData.unit1))
        return calibratedData.unit1, true
    end

    if getMapType() == MAPTYPE_SUBZONE then
        -- Default sub-zone coefficient
        return 0.00145, false
    end

    if getMapType() == MAPTYPE_ZONE then
        -- Default main zone coefficient
        return 0.0003, false
    end

    -- Default for any other smaller map (very imprecise as they usually are between 0.001 and 0.009)
    return 0.005, false
end

-- local function IsValidForPointer(pin)
--     -- List only specific pins to have pointers. just active quest pins now
--     if pin:IsQuest() then
--         return true;
--     end

--     return false;
-- end

-- ========================================================================================
-- MapRadarCustomPin handling methods
function MapRadarCustomPin:SetHidden(flag)
    self.texture:SetHidden(flag)
    if self.label ~= nil then
        self.label:SetHidden(flag)
    end
end

function MapRadarCustomPin:SetVisibility(isCalibrated)
    -- Most pin types they should be visible only in certain range
    if self.distance > MapRadar.modeSettings.maxDistance then
        self:SetHidden(true)
        return false
    end

    self:SetHidden(false)

    local minAlpha = MapRadar.modeSettings.minAlpha / 100
    local maxAlpha = MapRadar.modeSettings.maxAlpha / 100

    local alpha = maxAlpha
    if self.distance > MapRadar.maxRadarDistance then
        alpha = math.max(minAlpha, maxAlpha - (self.distance - MapRadar.maxRadarDistance) / MapRadar.maxRadarDistance)
    end

    self.texture:SetAlpha(alpha)

    if self.pointer ~= nil then
        self.pointer:SetAlpha(alpha)
    end

    if self.label ~= nil then
        self.label:SetColor(1, 1, isCalibrated and 1 or 0, alpha)
    end
    return true
end

function MapRadarCustomPin:SetPinDimensions()

    self.size = MapRadar.pinSize
    local minScale = MapRadar.modeSettings.minScale / 100
    local maxScale = MapRadar.modeSettings.maxScale / 100

    local distanceScale = math.max(minScale, maxScale - self.distance / MapRadar.maxRadarDistance / 2)

    self.scaledSize = self.size * distanceScale
    self.texture:SetDimensions(self.scaledSize, self.scaledSize)
end

-- function MapRadarCustomPin:ApplyTint()
--     local pinData = zoMapPin.PIN_DATA[self.pin:GetPinType()]

--     if (pinData ~= nil and pinData.tint ~= nil) then
--         self.texture:SetColor(MapRadar.value(pinData.tint, self.pin):UnpackRGBA())
--         return
--     end

--     self.texture:SetColor(1, 1, 1, 1)
-- end

function MapRadarCustomPin:UpdatePin(playerX, playerY, heading)
    local dx = self.x - playerX
    local dy = self.y - playerY

    local coefficient, isCalibrated = getMeterCoefficient()

    self.distance = math.sqrt(dx ^ 2 + dy ^ 2) / coefficient

    -- Set visibility (hidden or transparency) and if not visible then stop processing further 
    if not self:SetVisibility(isCalibrated) then
        return
    end

    local radarDistance = math.min(MapRadar.maxRadarDistance, self.distance)

    -- recalculate coordinates to apply rotation
    local angle = math.atan2(-dx, -dy) - heading
    dx = radarDistance * -math.sin(angle)
    dy = radarDistance * -math.cos(angle)

    -- Show distance (or other test data) near pin on radar
    if self.label ~= nil then
        local text = ""

        if MapRadar.modeSettings.showDistance then
            text = zo_strformat("<<1>>", self.distance)
        end

        self.label:SetText(text)
    end

    -- Resize pin 
    self:SetPinDimensions()

    -- Reposition pin
    self.texture:ClearAnchors()
    self.texture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER, dx, dy)

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_UpdatePin", self)
end

function MapRadarCustomPin:IsValidPin(pin)
    -- local pinType = pin:GetPinType()

    -- if pinType == nil then
    --     return false
    -- end

    return true; -- TODO: filter

    -- if (pin:IsQuest() or pinType == MAP_PIN_TYPE_TRACKED_QUEST_OFFER_ZONE_STORY) and MapRadar.modeSettings.showQuests -- or pin:IsObjective() -- or pin:IsAvAObjective()
    -- or pinType == MAP_PIN_TYPE_TRACKED_ANTIQUITY_DIG_SITE -- Antiquity
    -- or pin:IsUnit() and MapRadar.modeSettings.showGroup -- Player/Group/Companion units
    -- or pin:IsWorldEventPOIPin() -- Active Dolmens
    -- -- or pin:IsAssisted() -- or pin:IsMapPing()
    -- -- or pin:IsKillLocation()
    -- or pin:IsWorldEventUnitPin() -- Dragons and whatnot
    -- -- or pin:IsZoneStory() or pin:IsSuggestion() -- or pin:IsAreaPin()
    -- -- or pin:IsFastTravelWayShrine() -- Somehow some houses are in this category "MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE" (Some addon shitting?)
    -- or IsCustomPin(pinType) -- Custom pins from other addons. Maybe valid POI method can handle it?
    -- or IsValidPOI(pin) -- Filters POIs by texture
    -- then
    --     return true
    -- end

    -- return false;
end

-- ========================================================================================
-- ctor
function MapRadarCustomPin:New(key, x, y, pinTypeId, texturePath)
    local customPin = {}
    setmetatable(customPin, self)
    self.__index = self

    customPin.x = x
    customPin.y = y

    customPin.key = key
    customPin.pinTypeId = pinTypeId

    local texture, textureKey = MapRadar.pinPool:AcquireObject()

    customPin.texture = texture
    customPin.textureKey = textureKey
    customPin.texturePath = texturePath
    customPin.texture:SetTexture(texturePath)

    local tint = Harvest.settings.defaultSettings.pinLayouts[pinTypeId].tint
    customPin.texture:SetColor(tint.r, tint.g, tint.b, 1)

    local label, labelKey = MapRadar.pinLabelPool:AcquireObject()
    label:SetAnchor(BOTTOMLEFT, customPin.texture, BOTTOMRIGHT)
    customPin.label = label
    customPin.labelKey = labelKey

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_NewPin", customPin)

    return customPin
end

-- ========================================================================================
-- deconstruct
function MapRadarCustomPin:Dispose()

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_RemovePin", self)

    self.texture:ClearAnchors()
    MapRadar.pinPool:ReleaseObject(self.textureKey)
    self.textureKey = nil
    self.texture = nil

    if self.label ~= nil then
        self.label:SetText("")
        MapRadar.pinLabelPool:ReleaseObject(self.labelKey)
        self.labelKey = nil
        self.label = nil
    end

    self.pin = nil
    self.distance = nil
    self.size = nil
    self.scaledSize = nil
end
