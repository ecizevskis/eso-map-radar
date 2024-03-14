local function SettingsInit()
    -- local accountDefaults = {}
    -- MapRadar.aData = ZO_SavedVars:NewAccountWide("MapRadar_Data", 1, nil, accountDefaults)

    local defaults = {
        isOverlayMode = false,
        radarSettings = {
            maxDistance = 800,
            showDistance = false,
            showQuests = true,
            showSkyshards = true,
            showWayshrines = true,
            showDungeons = true,
            showDelves = true,
            showGroup = true,
            showPortals = true
        },
        overlaySettings = {
            maxDistance = 1200,
            showDistance = false,
            showQuests = true,
            showSkyshards = true,
            showWayshrines = true,
            showDungeons = true,
            showDelves = true,
            showGroup = true,
            showPortals = true
        }
    }

    MapRadar.config = ZO_SavedVars:NewCharacterIdSettings("MapRadar_Data", 1, nil, defaults)
end

local function CreatePinOptionStack(id, parent, config)
    local control = WINDOW_MANAGER:CreateControl(id, parent, CT_CONTROL)

    control.config = config
    control.buttons = {}

    control.addPinButton = function(self, optionKey, texture)
        local index = table.maxn(self.buttons) + 1
        local btn = WINDOW_MANAGER:CreateControl("$(parent)Button" .. index, self, CT_BUTTON)
        btn.config = self.config
        btn:SetDimensions(40, 40)
        btn:SetNormalTexture(texture)
        btn:SetAlpha(self.config[optionKey] and 1 or 0.3)
        btn:SetHandler("OnClicked", function(self)
            self.config[optionKey] = not self.config[optionKey]
            self:SetAlpha(self.config[optionKey] and 1 or 0.3)
            CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
        end)

        if (index == 1) then
            btn:SetAnchor(TOPLEFT, self, TOPLEFT)
        else
            btn:SetAnchor(TOPLEFT, control.buttons[index - 1], TOPRIGHT, 10)
        end

        self.buttons[index] = btn
    end

    return control
end

local function CreateForm()

    local radarLabel = MapRadarCommon.CreateLabel("radarLabel", MapRadar_Settings, "Radar mode settings")
    radarLabel:SetAnchor(TOPLEFT, MapRadar_Settings, TOPLEFT, 30, 30)

    local radarSectionDivider = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_radarSectionDivider", MapRadar_Settings, "ZO_Options_Divider")
    radarSectionDivider:SetAnchor(TOPLEFT, radarLabel, BOTTOMLEFT)

    local radarOptionStack = CreatePinOptionStack("$(parent)radarOptionStack", MapRadar_Settings, MapRadar.config.radarSettings)
    radarOptionStack:SetAnchor(TOPLEFT, radarSectionDivider, BOTTOMLEFT)

    radarOptionStack:addPinButton("showQuests", "EsoUi/Art/Compass/quest_icon_assisted.dds")
    radarOptionStack:addPinButton("showWayshrines", "/esoui/art/icons/poi/poi_wayshrine_complete.dds")
    radarOptionStack:addPinButton("showGroup", "/esoui/art/compass/groupleader.dds")
    radarOptionStack:addPinButton("showDelves", "/esoui/art/icons/poi/poi_delve_complete.dds")
    radarOptionStack:addPinButton("showDungeons", "/esoui/art/icons/poi/poi_dungeon_complete.dds")
    radarOptionStack:addPinButton("showPortals", "/esoui/art/icons/poi/poi_portal_complete.dds")

    -- To add!!
    -- LostTreasure  LostTreasure_SurveyReportPin
    -- LostTreasure_TreasureMapPin
    -- Map Pins  pinType_Treasure_Maps

    -- Check if skushards addon is active
    radarOptionStack:addPinButton("showSkyshards", "SkyShards/Icons/Skyshard-unknown.dds")
    -- radarOptionStack:addPinButton("showSkyshards", "/esoui/art/mappins/skyshard_seen.dds")
    -- radarOptionStack:addPinButton("showSkyshards", "/esoui/art/mappins/skyshard_complete.dds")
    --
end

CALLBACK_MANAGER:RegisterCallback("OnMapRadarInitializing", function()
    SettingsInit()
    CreateForm()
end)

