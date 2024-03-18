local function SettingsInit()
    -- local accountDefaults = {}
    -- MapRadar.aData = ZO_SavedVars:NewAccountWide("MapRadar_Data", 1, nil, accountDefaults)

    local defaults = {
        isOverlayMode = false,
        radarSettings = {
            maxDistance = 800,
            showDistance = false,
            showPointers = false,
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
            showPointers = false,
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

    control.addPinButton = function(self, optionKey, texture, tooltip)
        local index = table.maxn(self.buttons) + 1
        local btn = WINDOW_MANAGER:CreateControl("$(parent)Button" .. index, self, CT_BUTTON)
        btn.config = self.config
        btn:SetDimensions(40, 40)
        btn:SetNormalTexture(texture)
        btn:SetAlpha(self.config[optionKey] and 1 or 0.3)
        btn:SetHandler(
            "OnClicked", function(self)
                self.config[optionKey] = not self.config[optionKey]
                self:SetAlpha(self.config[optionKey] and 1 or 0.3)
                CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
            end)

        btn:SetHandler(
            "OnMouseEnter", function(self)
                if tooltip then
                    ZO_Tooltips_ShowTextTooltip(self, BOTTOM, tooltip)
                end
            end)
        btn:SetHandler(
            "OnMouseExit", function(self)
                if tooltip then
                    ZO_Tooltips_HideTextTooltip()
                end
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

local function CreateModeSection(id, parent, title, config, w, h)
    local control = WINDOW_MANAGER:CreateControl(id, parent, CT_CONTROL)
    control:SetDimensions(w or 500, h or 300)

    local title = MapRadarCommon.CreateLabel("$(parent)_title", control, title)
    title:SetAnchor(TOPLEFT, control, TOPLEFT)

    local sectionDivider = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_sectionDivider", control, "ZO_Options_Divider")
    sectionDivider:SetAnchor(TOPLEFT, title, BOTTOMLEFT)

    local optionStack = CreatePinOptionStack("$(parent)_optionStack", control, config)
    optionStack:SetAnchor(TOPLEFT, sectionDivider, BOTTOMLEFT)
    optionStack:SetDimensions(200, 50)

    optionStack:addPinButton("showQuests", "EsoUi/Art/Compass/quest_icon_assisted.dds", "Show quests (from Quest Map too)")
    optionStack:addPinButton("showWayshrines", "/esoui/art/icons/poi/poi_wayshrine_complete.dds", "Show wayshrines")
    optionStack:addPinButton("showGroup", "/esoui/art/compass/groupleader.dds", "Show your group units")
    optionStack:addPinButton("showDelves", "/esoui/art/icons/poi/poi_delve_complete.dds", "Show delves")
    optionStack:addPinButton("showDungeons", "/esoui/art/icons/poi/poi_dungeon_complete.dds", "Show dungeons")
    optionStack:addPinButton(
        "showPortals", "/esoui/art/icons/poi/poi_portal_complete.dds",
        "Show porals (originally those are Dolmens but MapPins can add more of portals)")

    local showDistanceCbx = MapRadarCommon.CreateCheckBox(
        "$(parent)_distCbx", control, config, "showDistance", "Show distance", "Show distance in meters for each radar pin")
    showDistanceCbx:SetAnchor(TOPLEFT, optionStack, BOTTOMLEFT)

    local showPointersCbx = MapRadarCommon.CreateCheckBox(
        "$(parent)_pointerCbx", control, config, "showPointers", "Show poiners", "Show pointers from player pin towards all quest pins")
    showPointersCbx:SetAnchor(TOPLEFT, showDistanceCbx, TOPRIGHT)

    local maxDistanceSlider = MapRadarCommon.CreateSlider(
        "$(parent)_maxDistanceSlider", control, config, "maxDistance", "Max distance",
        "Set maximum distance for pin to be displayed in radar (Quest and Group pins ingnore this)", 100, 30)
    maxDistanceSlider:SetAnchor(TOPLEFT, showDistanceCbx, BOTTOMLEFT, 0, 10)
    maxDistanceSlider:SetMinMaxStep(400, 2500, 50)

    -- TODO: 
    -- Check for custom pin types by names and show filter option
    -- LostTreasure survey maps
    -- LostTreasure treasure maps
    -- MapPins Survey maps
    -- MapPins Treasure maps
    -- MapPins Skyshards
    -- SkyShard skyshards

    return control
end

local function CreateForm()

    local radarModeSection = CreateModeSection("$(parent)_radarSection", MapRadar_Settings, "Radar mode settings", MapRadar.config.radarSettings)
    radarModeSection:SetAnchor(TOPLEFT, MapRadar_Settings, TOPLEFT, 30, 30)

    local overlayModeSection = CreateModeSection(
        "$(parent)_overlaySection", MapRadar_Settings, "Overlay mode settings", MapRadar.config.overlaySettings)
    overlayModeSection:SetAnchor(TOPLEFT, radarModeSection, BOTTOMLEFT)

    --[[
    if hasSkyShardAddon then
        overlayOptionStack:addPinButton("showSkyshards", "/esoui/art/mappins/skyshard_seen.dds")
    end
    ]]
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitializing", function()
        SettingsInit()
        CreateForm()
    end)

-- WORLD_MAP_MANAGER:GetFilterValue(pinGroup)
