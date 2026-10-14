local getCurrentMapId = GetCurrentMapId
local getMapType = GetMapType
local getMapMeterCoefficient = MapRadarWorldScale.GetMeterCoefficient -- WorldScaleCalibrator.lua loads first

-- Localize global objects for better performance (UpdatePin runs per pin on every draw tick)
local MR = MapRadar -- MapRadar.lua loads first, so this is the final table
local callbackManager = CALLBACK_MANAGER
local zoStrformat = zo_strformat
local sqrt, min, max, atan2, sin, cos = math.sqrt, math.min, math.max, math.atan2, math.sin, math.cos
local CENTER = CENTER

MapRadarPinBase = {}

-- Meter coefficient of the current map, refreshed once per batch of pin updates instead of per pin
local meterCoefficient, isMeterCalibrated = 0.005, false

-- ========================================================================================
-- helper methods

local function getMeterCoefficient()

    -- Zone data, then calibrated value, then temporary approximation (see WorldScaleCalibrator)
    local coefficient, isCalibrated = getMapMeterCoefficient(getCurrentMapId())
    if coefficient ~= nil then
        return coefficient, isCalibrated
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

-- Call once before each batch of UpdatePin calls (draw tick, newly created pins)
function MapRadarPinBase.RefreshMeterCoefficient()
    meterCoefficient, isMeterCalibrated = getMeterCoefficient()
end

-- ========================================================================================
-- MapRadarPinBase handling methods
function MapRadarPinBase:SetHidden(flag)
    self.texture:SetHidden(flag)
    if self.label ~= nil then
        self.label:SetHidden(flag)
    end
    if self.pointer ~= nil then
        self.pointer:SetHidden(flag)
    end
end

function MapRadarPinBase:SetVisibility(isCalibrated)
    -- modeSettings is replaced on mode switch, so read it per call
    local modeSettings = MR.modeSettings
    local distance = self.distance

    -- Most pin types they should be visible only in certain range
    if not self.showAlways and distance > modeSettings.maxDistance then
        -- d(zo_strformat("Pin is not visible: <<1>>  <<2>> > <<3>>", self.key, self.distance, MapRadar.modeSettings.maxDistance))
        self:SetHidden(true)
        return false
    end

    self:SetHidden(false)

    local minAlpha = modeSettings.minAlpha / 100
    local maxAlpha = modeSettings.maxAlpha / 100
    local maxRadarDistance = MR.maxRadarDistance

    local alpha = maxAlpha
    if distance > maxRadarDistance then
        alpha = max(minAlpha, maxAlpha - (distance - maxRadarDistance) / maxRadarDistance)
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

function MapRadarPinBase:SetPinDimensions(pinSize)
    -- MapRadar.pinSize changes on switching between modes, so need to reassign it while other different approach is found.
    -- Maybe this is not needed at all if every mode apply own scaling?
    self.size = pinSize or MR.pinSize
    local modeSettings = MR.modeSettings
    local minScale = modeSettings.minScale / 100
    local maxScale = modeSettings.maxScale / 100

    local distanceScale = max(minScale, maxScale - self.distance / MR.maxRadarDistance / 2)

    self.scaledSize = self.size * distanceScale
    self.texture:SetDimensions(self.scaledSize, self.scaledSize)
end

function MapRadarPinBase:ApplyTexture()
    local texture = "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds" -- unknown pin

    -- Just in case check
    if self.animationTimeline then
        self.animationTimeline:Stop()
    end

    self.texture:SetTexture(texture)
    self.texturePath = texture
end

function MapRadarPinBase:ApplyTint()
    self.texture:SetColor(1, 1, 1, 1)
end

function MapRadarPinBase:UpdatePin(playerX, playerY, heading, hasPlayerMoved)

    if not hasPlayerMoved then
        return -- If nothing changed then skip update. 
    end

    local dx = self.x - playerX
    local dy = self.y - playerY

    self.distance = sqrt(dx * dx + dy * dy) / meterCoefficient

    -- Set visibility (hidden or transparency) and if not visible then stop processing further
    if not self:SetVisibility(isMeterCalibrated) then
        return
    end

    local radarDistance = min(MR.maxRadarDistance, self.distance)

    -- recalculate coordinates to apply rotation
    local angle = atan2(-dx, -dy) - heading
    dx = radarDistance * -sin(angle)
    dy = radarDistance * -cos(angle)

    -- Resize pin
    self:SetPinDimensions()

    -- Reposition pin
    self.texture:ClearAnchors()
    self.texture:SetAnchor(CENTER, MR.playerPinTexture, CENTER, dx, dy)

    -- Pointer points only for quests (not affected by range)
    if self.pointer ~= nil then
        local showPointers = MR.modeSettings.showPointers
        self.pointer:SetHidden(not showPointers)

        if showPointers then
            self.pointer:SetTextureRotation(angle, 0.5, 1)
            if radarDistance < 64 then
                self.pointer:SetDimensions(8, radarDistance)
            end
        end
    end

    self:UpdateLabel()

    callbackManager:FireCallbacks("OnMapRadar_UpdatePin", self)
end

-- Show distance near pin (only while the pin is visible); subclasses override for extra label data
function MapRadarPinBase:UpdateLabel()
    if self.label ~= nil and MR.modeSettings.showDistance then
        self.label:SetText(zoStrformat("<<1>>", self.distance))
    end
end

-- ========================================================================================
-- ctor
function MapRadarPinBase:New(key, x, y, showPointer)
    local radarPin = {}
    setmetatable(radarPin, self)
    self.__index = self

    local texture, textureKey = MR.pinPool:AcquireObject()

    radarPin.texture = texture
    radarPin.textureKey = textureKey

    radarPin.key = key

    radarPin.x = x
    radarPin.y = y

    radarPin:ApplyTexture()
    radarPin:ApplyTint()

    local label, labelKey = MR.pinLabelPool:AcquireObject()
    label:SetAnchor(BOTTOMLEFT, radarPin.texture, BOTTOMRIGHT)
    radarPin.label = label
    radarPin.labelKey = labelKey

    if showPointer then
        local pointerTexture, pointerKey = MR.pointerPool:AcquireObject()
        pointerTexture:SetTexture("MapRadar/textures/pointer.dds")
        pointerTexture:SetAnchor(BOTTOM, MR.playerPinTexture, CENTER)
        pointerTexture:SetAlpha(0.5)
        pointerTexture:SetDimensions(8, 64)
        pointerTexture:SetHidden(true)
        radarPin.pointer = pointerTexture
        radarPin.pointerKey = pointerKey
    end

    callbackManager:FireCallbacks("OnMapRadar_NewPin", radarPin)

    return radarPin
end

-- ========================================================================================
-- deconstruct
function MapRadarPinBase:Dispose()

    callbackManager:FireCallbacks("OnMapRadar_RemovePin", self)

    if self.animationTimeline then
        self.animationTimeline:Stop()
        self.animationTimeline = nil
        self.animation = nil
    end

    self.texture:ClearAnchors()
    MR.pinPool:ReleaseObject(self.textureKey)
    self.textureKey = nil
    self.texture = nil

    if self.pointer ~= nil then
        self.pointer:ClearAnchors()
        MR.pointerPool:ReleaseObject(self.pointerKey)
        self.pointerKey = nil
        self.pointer = nil
    end

    if self.label ~= nil then
        self.label:SetText("")
        MR.pinLabelPool:ReleaseObject(self.labelKey)
        self.labelKey = nil
        self.label = nil
    end

    self.pin = nil
    self.distance = nil
    self.size = nil
    self.scaledSize = nil
end
