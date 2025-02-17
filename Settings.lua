local HarvestMapFilterProfile = {}

local function SettingsInit()
    -- local accountDefaults = {}
    -- MapRadar.aData = ZO_SavedVars:NewAccountWide("MapRadar_Data", 1, nil, accountDefaults)

    local defaults = {
        radarPosition = {
            point = BOTTOMRIGHT,
            relativePoint = BOTTOMRIGHT,
            offsetX = -300,
            offsetY = -40
         },
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
            showPortals = true,
            showWorldBosses = true,
            showLoreBooks = false,
            showHarvestMap = false,

            minAlpha = 40,
            maxAlpha = 100,
            minScale = 60,
            maxScale = 100
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
            showPortals = true,
            showWorldBosses = true,
            showLoreBooks = false,
            showHarvestMap = false,

            minAlpha = 40,
            maxAlpha = 100,
            minScale = 60,
            maxScale = 100
         },

        -- Debug 
        showCalibrate = false,
        calibrationDistance1 = 40,
        calibrationDistance2 = 0,

        showAnalyzer = false
     }

    MapRadar.config = ZO_SavedVars:NewCharacterIdSettings("MapRadar_Data", 1, nil, defaults)

    local radarPos = MapRadar.config.radarPosition
    MapRadarContainer:SetAnchor(radarPos.point, GuiRoot, radarPos.relativePoint, radarPos.offsetX, radarPos.offsetY)
    MapRadarContainer:SetHandler(
        "OnMoveStop", function()
            local _, point, _, relativePoint, offsetX, offsetY = MapRadarContainer:GetAnchor(0)
            MapRadar.config.radarPosition = {
                point = point,
                relativePoint = relativePoint,
                offsetX = offsetX,
                offsetY = offsetY
             }
        end)
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
    optionStack:addPinButton("showWorldBosses", "/esoui/art/icons/poi/poi_groupboss_complete.dds", "Show world bosses")

    if LoreBooks then
        optionStack:addPinButton("showLoreBooks", "/LoreBooks/Icons/book1-invert.dds", "Show LoreBooks pins")
    end

    if Harvest then
        optionStack:addPinButton("showHarvestMap", "/HarvestMap/Textures/Map/flower.dds", "Show HarvestMap pins")
    end

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

    -- Pin alpha sliders
    local minAlphaSlider = MapRadarCommon.CreateSlider("$(parent)_minAlphaSlider", control, config, "minAlpha", "Min Alpha", "", 300, 30)
    minAlphaSlider:SetAnchor(TOPLEFT, maxDistanceSlider, BOTTOMLEFT)
    minAlphaSlider:SetMinMaxStep(10, 100, 5)

    local maxAlphaSlider = MapRadarCommon.CreateSlider("$(parent)_maxAlphaSlider", control, config, "maxAlpha", "Max Alpha", "", 100, 30)
    maxAlphaSlider:SetAnchor(TOPLEFT, minAlphaSlider, TOPRIGHT)
    maxAlphaSlider:SetMinMaxStep(10, 100, 5)

    -- Pin scale sliders
    local minScaleSlider = MapRadarCommon.CreateSlider("$(parent)_minScaleSlider", control, config, "minScale", "Min Scale", "", 300, 30)
    minScaleSlider:SetAnchor(TOPLEFT, minAlphaSlider, BOTTOMLEFT)
    minScaleSlider:SetMinMaxStep(50, 200, 5)

    local maxScaleSlider = MapRadarCommon.CreateSlider("$(parent)_maxScaleSlider", control, config, "maxScale", "Max Scale", "", 100, 30)
    maxScaleSlider:SetAnchor(TOPLEFT, minScaleSlider, TOPRIGHT)
    maxScaleSlider:SetMinMaxStep(50, 200, 5)

    return control
end

function MapRadar_toggleSettings()
    local isOpen = MapRadar_Settings:IsHidden()
    MapRadar_Settings:SetHidden(not isOpen)
    SetGameCameraUIMode(isOpen)
    -- MapRadar.debug("This will open configuration")
end

local function addHarvestFilterButton(id, parent, pinTypeId)
    local btn = WINDOW_MANAGER:CreateControl(id, parent, CT_BUTTON)

    btn.texture = WINDOW_MANAGER:CreateControl(id .. "texture", btn, CT_TEXTURE)
    btn.texture:SetAnchor(TOPLEFT, btn, TOPLEFT)

    local tint = Harvest.settings.defaultSettings.pinLayouts[pinTypeId].tint
    local texturePath = Harvest.settings.savedVars.settings.pinLayouts[pinTypeId].texture
    local tooltip = Harvest.GetLocalization("pintype" .. pinTypeId)

    btn:SetDimensions(30, 30)
    btn.texture:SetTexture(texturePath)
    btn.texture:SetColor(tint.r, tint.g, tint.b, 1)
    btn.texture:SetDimensions(30, 30)
    btn:SetAlpha(HarvestMapFilterProfile[pinTypeId] and 1 or 0.3)
    btn:SetHandler(
        "OnClicked", function(self)
            local isVisible = not HarvestMapFilterProfile[pinTypeId]
            HarvestMapFilterProfile[pinTypeId] = isVisible
            self:SetAlpha(HarvestMapFilterProfile[pinTypeId] and 1 or 0.3)
            -- CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
            Harvest.callbackManager:FireCallbacks(Harvest.events.FILTER_PROFILE_CHANGED, HarvestMapFilterProfile, pinTypeId, isVisible)
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

    return btn
end

local function CreateHarvestMapSettings()
    local control = WINDOW_MANAGER:CreateControl("$(parent)harvestMapSettings", MapRadar_Settings, CT_CONTROL)
    control:SetDimensions(100, 600)
    control:SetAnchor(TOPLEFT, MapRadar_Settings, TOPRIGHT, 20)

    WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_bg", control, "ZO_MinorMungeBackdrop_SemiTransparentBlack")

    local title = MapRadarCommon.CreateLabel("$(parent)_title", control, "Harvest")
    title:SetFont("$(BOLD_FONT)|24|outline")
    title:SetAnchor(TOPLEFT, control, TOPLEFT, 15, 15)

    local harvestPinAnchor = WINDOW_MANAGER:CreateControl("$(parent)harvestPinAnchor", control, CT_CONTROL)
    harvestPinAnchor:SetAnchor(TOPLEFT, title, BOTTOMLEFT, 20)

    local anchorControl = harvestPinAnchor
    for index, pinTypeId in ipairs(Harvest.PINTYPES) do
        if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
            local harvestPinBtn = addHarvestFilterButton("$(parent)pin" .. index, control, pinTypeId)
            harvestPinBtn:SetAnchor(TOPLEFT, anchorControl, BOTTOMLEFT, 0, 2)
            anchorControl = harvestPinBtn
        end
    end

end

local function CreateForm()
    local closeButton = CreateControlFromVirtual("$(parent)closeButton", MapRadar_Settings, "ZO_DialogButton")
    closeButton:SetAnchor(BOTTOMRIGHT, btnSavePosition2, BOTTOMRIGHT, -20, -20)
    ZO_KeybindButtonTemplate_Setup(
        closeButton, "TOGGLE_SYSTEM", function()
            MapRadar_toggleSettings()
        end, "Close")

    local radarModeSection = CreateModeSection("$(parent)_radarSection", MapRadar_Settings, "Radar mode settings", MapRadar.config.radarSettings)
    radarModeSection:SetAnchor(TOPLEFT, MapRadar_Settings, TOPLEFT, 30, 30)

    local overlayModeSection = CreateModeSection(
        "$(parent)_overlaySection", MapRadar_Settings, "Overlay mode settings", MapRadar.config.overlaySettings)
    overlayModeSection:SetAnchor(TOPLEFT, radarModeSection, BOTTOMLEFT)

    CreateHarvestMapSettings()

    -- Escape key handling
    ZO_PreHook(
        "ZO_SceneManager_ToggleGameMenuBinding", function()
            local isOpen = not MapRadar_Settings:IsHidden()
            if isOpen then
                MapRadar_toggleSettings()
                return true
            end

            return false
        end)

end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitializing", function()
        HarvestMapFilterProfile = Harvest.filterProfiles["GetMapProfile"](Harvest.filterProfiles)

        SettingsInit()
        CreateForm()
    end)

-- WORLD_MAP_MANAGER:GetFilterValue(pinGroup)
