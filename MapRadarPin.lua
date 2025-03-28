-- TODO: 
-- area pins / blobs - Is it worth trying to do?
MapRadarPin = {}

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

local function customPinName(pinType)
    local cpin = pinManager.customPins[pinType]
    if (cpin ~= nil) then
        return cpin.pinTypeString
    end

    return nil
end

local function IsCustomPin(pinType)
    if MapRadar.modeSettings.showQuests and (customPinName(pinType) == "QuestMap_uncompleted" or customPinName(pinType) == "QuestMap_zonestory") -- Quest map
    or customPinName(pinType) == "pinType_Treasure_Maps" -- from "Map Pins" by Hoft
    or MapRadar.modeSettings.showMapPinsChests and customPinName(pinType) == "pinType_Treasure_Chests" -- from "Map Pins" by Hoft
    or customPinName(pinType) == "LostTreasure_SurveyReportPin" -- Survey from LostTreasure
    or customPinName(pinType) == "LostTreasure_TreasureMapPin" -- Treasure from LostTreasure
    or MapRadar.modeSettings.showSkyshards and (customPinName(pinType) == "pinType_Skyshards" -- Map Pins addon
    or customPinName(pinType) == "SkySMapPin_unknown" -- SkyShards addon
    ) then
        return true
    end

    return false
end

local function IsValidPOI(pin)
    local pinType = pin:GetPinType()
    local pinData = zoMapPin.PIN_DATA[pinType]
    local texturePath = MapRadar.value(pinData.texture, pin)

    if texturePath ~= nil then
        if texturePath:find("poi_wayshrine") and MapRadar.modeSettings.showWayshrines -- Wayshrine
        or texturePath:find("poi_dungeon") and MapRadar.modeSettings.showDungeons --
        or texturePath:find("poi_groupinstance") and MapRadar.modeSettings.showDungeons --
        or (texturePath:find("poi_delve") or texturePath:find("poi_groupdelve")) and MapRadar.modeSettings.showDelves --
        or texturePath:find("poi_portal") and MapRadar.modeSettings.showPortals -- dolmen but also other portals :/
        or texturePath:find("poi_groupboss") and MapRadar.modeSettings.showWorldBosses -- 
        or texturePath:find("LoreBooks") and MapRadar.modeSettings.showLoreBooks -- Show pins from LoreBooks addon
        then
            return true
        end
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

function MapRadarPin:SetVisibility(isCalibrated)
    -- Most pin types they should be visible only in certain range
    if not self.isRangeUnlimited and self.distance > MapRadar.modeSettings.maxDistance then
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

function MapRadarPin:SetPinDimensions()

    -- TODO: somehow add scaling for radar and overlay
    -- if self.size ~= nil and self.size == MapRadar.pinSize then
    --    return
    -- end
    local pinType = self.pin:GetPinType()
    local pinData = zoMapPin.PIN_DATA[pinType]

    if (pinData ~= nil and pinData.size ~= nil) then
        self.size = pinData.size
    else
        self.size = MapRadar.pinSize
    end

    local minScale = MapRadar.modeSettings.minScale / 100
    local maxScale = MapRadar.modeSettings.maxScale / 100

    local distanceScale = math.max(minScale, maxScale - self.distance / MapRadar.maxRadarDistance / 2)

    self.scaledSize = self.size * distanceScale
    self.texture:SetDimensions(self.scaledSize, self.scaledSize)
end

function MapRadarPin:ApplyTexture()
    local texture = "EsoUI/Art/MapPins/UI_Worldmap_pin_customDestination.dds" -- unknown pin

    -- Just in case check
    if self.animationTimeline then
        self.animationTimeline:Stop()
    end

    local pinData = zoMapPin.PIN_DATA[self.pin:GetPinType()]

    if (pinData ~= nil and pinData.texture ~= nil) then
        texture = MapRadar.value(pinData.texture, self.pin)

        if MapRadar.value(pinData.isAnimated, self.pin) then
            self.animation, self.animationTimeline = CreateSimpleAnimation(ANIMATION_TEXTURE, self.texture)
            self.animation:SetImageData(pinData.framesWide, pinData.framesHigh)
            self.animation:SetFramerate(pinData.framesPerSecond)

            -- returns texture to default state 
            self.animation:SetHandler(
                "OnStop", function()
                    self.texture:SetTextureCoords(0, 1, 0, 1)
                end)

            self.animationTimeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
            self.animationTimeline:PlayFromStart()
        end
    end

    self.texture:SetTexture(texture)
    self.texturePath = texture
end

function MapRadarPin:ApplyTint()
    local pinType = self.pin:GetPinType()
    local pinData = zoMapPin.PIN_DATA[pinType]

    if (pinData ~= nil and pinData.tint ~= nil) then
        self.texture:SetColor(MapRadar.value(pinData.tint, self.pin):UnpackRGBA())
        return
    end

    self.texture:SetColor(1, 1, 1, 1)
end

function MapRadarPin:CheckIntegrity()
    local pinType = self.pin:GetPinType()
    if pinType == nil then
        return false
    end

    -- If pin type chnaged then not valid
    if self.pinType ~= pinType then
        return false
    end

    local pinData = zoMapPin.PIN_DATA[self.pin:GetPinType()]
    if pinData == nil then
        return false
    end

    -- If there is no texture pin is not valid
    if pinData.texture == nil then
        return false
    end

    -- Check if texture changed
    local texture = MapRadar.value(pinData.texture, self.pin)
    if texture ~= self.texturePath then
        return false
    end

    return true
end

function MapRadarPin:UpdatePin(playerX, playerY, heading, hasPlayerMoved)
    local pinType = self.pin:GetPinType()

    if pinType == nil then
        -- Somehow pin gets corrupted (maybe because of pin reload on map change) and will be filtered out later
        return
    end

    local pinX = self.pin.normalizedX
    local pinY = self.pin.normalizedY

    -- TODO: perhaps move that to separate method with checking also texture, tint or something else?
    if not hasPlayerMoved and self.x == pinX and self.y == pinY then
        return -- If nothing changed then skip update. 
    end

    self.x = pinX
    self.y = pinY

    local dx = pinX - playerX
    local dy = pinY - playerY

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

    -- Pointer points only for quests (not affected by range)
    -- TODO: need to add fading a bit on distance??? Maybe it ok like that to be visible
    if self.pointer ~= nil then
        self.pointer:SetTextureRotation(angle, 0.5, 1)
        if radarDistance < 64 then
            self.pointer:SetDimensions(8, radarDistance)
        end
    end

    -- Show distance (or other test data) near pin on radar
    if self.label ~= nil then
        local text = ""

        if MapRadar.modeSettings.showDistance then
            text = zo_strformat("<<1>>", self.distance)
        end

        if MapRadar.showPinLoc then
            text = zo_strformat("<<1>>   <<2>>", ZO_LocalizeDecimalNumber(self.pin.normalizedX), ZO_LocalizeDecimalNumber(self.pin.normalizedY))
        end

        if MapRadar.showPinNames then
            local name = MR_PinTypeNames[pinType] or customPinName(pinType)
            text = zo_strformat("<<1>> <<2>>", pinType, name)
        end

        if MapRadar.showPinParams then
            local pinData = zoMapPin.PIN_DATA[pinType]
            if pinData ~= nil then
                local animatedStr = MapRadar.value(pinData.isAnimated, self.pin) and "[A]" or "[N]"
                local texturePath = MapRadar.value(pinData.texture, self.pin)
                -- later add more
                text = zo_strformat("<<1>> <<2>>", animatedStr, texturePath)
            end
        end

        self.label:SetText(text)
    end

    if self.pointer ~= nil then
        self.pointer:SetHidden(not MapRadar.modeSettings.showPointers)
    end

    -- Resize pin 
    self:SetPinDimensions()

    -- Reposition pin
    self.texture:ClearAnchors()
    self.texture:SetAnchor(CENTER, MapRadar.playerPinTexture, CENTER, dx, dy)

    -- Reset texture params
    -- self:ApplyTexture()
    -- self:ApplyTint()

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_UpdatePin", self)
end

function MapRadarPin:IsValidPin(pin)
    local pinType = pin:GetPinType()

    if pinType == nil then
        return false
    end

    if pinType == MAP_PIN_TYPE_PLAYER -- or pinType == MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY or pinType == MAP_PIN_TYPE_DRAGON_IDLE_WEAK 
    or pin:IsCompanion() then
        return false
    end

    -- MAP_PIN_TYPW_SKYSHARD_SEEN

    -- zoneStoryQuest_icon_door
    -- quest_icon_door
    -- repeatableQuest_icon_door
    -- zoneStoryQuest_icon_door_assisted

    if (pin:IsQuest() or pinType == MAP_PIN_TYPE_TRACKED_QUEST_OFFER_ZONE_STORY) and MapRadar.modeSettings.showQuests -- or pin:IsObjective() -- or pin:IsAvAObjective()
    or pinType == MAP_PIN_TYPE_TRACKED_ANTIQUITY_DIG_SITE -- Antiquity
    or pin:IsUnit() and MapRadar.modeSettings.showGroup -- Player/Group/Companion units
    or pin:IsWorldEventPOIPin() -- Active Dolmens
    -- or pin:IsAssisted() -- or pin:IsMapPing()
    -- or pin:IsKillLocation()
    or pin:IsWorldEventUnitPin() -- Dragons and whatnot
    -- or pin:IsZoneStory() or pin:IsSuggestion() -- or pin:IsAreaPin()
    -- or pin:IsFastTravelWayShrine() -- Somehow some houses are in this category "MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE" (Some addon shitting?)
    or IsCustomPin(pinType) -- Custom pins from other addons. Maybe valid POI method can handle it?
    or IsValidPOI(pin) -- Filters POIs by texture
    then
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

    local texture, textureKey = MapRadar.pinPool:AcquireObject()

    radarPin.texture = texture
    radarPin.textureKey = textureKey

    radarPin.key = key
    radarPin.pin = pin
    radarPin.pinType = pin:GetPinType()

    -- To track changes in position
    radarPin.x = 0
    radarPin.y = 0

    radarPin:ApplyTexture()
    radarPin:ApplyTint()

    local label, labelKey = MapRadar.pinLabelPool:AcquireObject()
    label:SetAnchor(BOTTOMLEFT, radarPin.texture, BOTTOMRIGHT)
    radarPin.label = label
    radarPin.labelKey = labelKey

    if IsValidForPointer(pin) then
        local pointerTexture, pointerKey = MapRadar.pointerPool:AcquireObject()
        pointerTexture:SetTexture("MapRadar/textures/pointer.dds")
        pointerTexture:SetAnchor(BOTTOM, MapRadar.playerPinTexture, CENTER)
        pointerTexture:SetAlpha(0.5)
        pointerTexture:SetDimensions(8, 64)
        pointerTexture:SetHidden(true)
        radarPin.pointer = pointerTexture
        radarPin.pointerKey = pointerKey
    end

    radarPin.isRangeUnlimited = pin:IsQuest() or pin:IsUnit() or pin:IsWorldEventPOIPin()

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_NewPin", radarPin)

    return radarPin
end

-- ========================================================================================
-- deconstruct
function MapRadarPin:Dispose()

    CALLBACK_MANAGER:FireCallbacks("OnMapRadar_RemovePin", self)

    if self.animationTimeline then
        self.animationTimeline:Stop()
        self.animationTimeline = nil
        self.animation = nil
    end

    self.texture:ClearAnchors()
    MapRadar.pinPool:ReleaseObject(self.textureKey)
    self.textureKey = nil
    self.texture = nil

    if self.pointer ~= nil then
        self.pointer:ClearAnchors()
        MapRadar.pointerPool:ReleaseObject(self.pointerKey)
        self.pointerKey = nil
        self.pointer = nil
    end

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
