-- ==================================================================================================
-- Local generation methods
local function CreateLabel(name, parent, text)
    local label = CreateControl(name, parent, CT_LABEL)
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(
        unpack(
            {
                1,
                1,
                1,
                1
             }))

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

-- ==================================================================================================
-- Label stack
local LabelStack = {}
function LabelStack:New(name, parent, count)
    local control = CreateLabel(name, parent, " ") -- Empty space forces to render tabel text and calc its bottom position for anchors

    control.SetFontBase = control.SetFont
    control.SetColorBase = control.SetColor
    control.name = name
    control.count = count
    control.labels = {}

    local label = CreateLabel("$(parent)placeholder", control)
    label:SetAnchor(TOPLEFT, control, TOPRIGHT)

    -- Create list of label controls here and anchor them together
    for i = 1, count do
        local nextLabel = CreateLabel("$(parent)Label" .. i, control)
        nextLabel:SetAnchor(TOPLEFT, label, TOPRIGHT, 10)
        nextLabel:SetAnchor(BOTTOMLEFT, label, BOTTOMRIGHT, 10)
        control.labels[i] = nextLabel
        label = nextLabel
    end

    control.SetText = function(self, text)
        -- puch all label texts further 
        for i = self.count, 2, -1 do
            self.labels[i]:SetText(self.labels[i - 1]:GetText())
        end
        self.labels[1]:SetText(text)
    end

    control.SetFont = function(self, ...)
        self:SetFontBase(...)
        for i = 1, count do
            control.labels[i]:SetFont(...)
        end
    end

    control.SetColor = function(self, ...)
        self:SetColorBase(...)
        for i = 1, count do
            control.labels[i]:SetColor(...)
        end
    end

    return control
end

-- ==================================================================================================
-- Data form
local DataForm = {}
function DataForm:New(id, parent)
    local control = CreateControl("$(parent)DataAnchor" .. id, parent, CT_CONTROL)
    local lastTextLabel = {}

    control.labels = {}

    control.AddLabel = function(self, text, dataFunc)
        local index = table.maxn(self.labels) + 1

        local textLabel = CreateLabel("$(parent)TextLabel" .. index, self, text)
        local dataLabel = CreateLabel("$(parent)DataLabel" .. index, self)

        if (index == 1) then
            textLabel:SetAnchor(TOPRIGHT, self, TOPLEFT, -10)
            dataLabel:SetAnchor(TOPLEFT, self, TOPRIGHT, 10)
        else
            textLabel:SetAnchor(TOPRIGHT, lastTextLabel, BOTTOMRIGHT)
            dataLabel:SetAnchor(TOPLEFT, control.labels[index - 1].control, BOTTOMLEFT)
        end

        self.labels[index] = {
            control = dataLabel,
            fetch = dataFunc
         }

        local baseWidth, baseHeight = self:GetDimensions()
        local labelWidth, labelHeight = textLabel:GetDimensions()

        self:SetDimensions(baseWidth, baseHeight + labelHeight)

        lastTextLabel = textLabel
    end

    control.AddStack = function(self, text, dataFunc)
        -- TODO: Unify two methods

        local index = table.maxn(self.labels) + 1

        local textLabel = CreateLabel("$(parent)TextLabel" .. index, self, text)
        local dataLabel = MapRadarCommon.LabelStack:New("$(parent)DataLabel" .. index, self, 5)
        dataLabel:SetFont("$(BOLD_FONT)|16|outline")
        dataLabel:SetColor(1, 1, 1, 1)

        if (index == 1) then
            textLabel:SetAnchor(TOPRIGHT, self, TOPLEFT, -10)
            dataLabel:SetAnchor(TOPLEFT, self, TOPRIGHT, 10)
        else
            textLabel:SetAnchor(TOPRIGHT, lastTextLabel, BOTTOMRIGHT)
            dataLabel:SetAnchor(TOPLEFT, control.labels[index - 1].control, BOTTOMLEFT)
        end

        self.labels[index] = {
            control = dataLabel,
            fetch = dataFunc
         }

        local baseWidth, baseHeight = self:GetDimensions()
        local labelWidth, labelHeight = textLabel:GetDimensions()

        self:SetDimensions(baseWidth, baseHeight + labelHeight)

        lastTextLabel = textLabel
    end

    control.SetColor = function(self, ...)
        for key, label in pairs(self.labels) do
            label.control:SetColor(...)
        end
    end

    control.Update = function(self)
        for k, dataLabel in pairs(self.labels) do
            dataLabel.control:SetText(dataLabel.fetch() or " ")
        end
    end

    return control
end

-- ==================================================================================================
-- Debouncer
local Debouncer = {}
function Debouncer:New(callback, waitTimeMs)
    local instance = {
        callback = callback,
        debounce = false,
        timeout = 0,
        count = 0,
        waitTimeMs = waitTimeMs or 300
     }

    local function waitForTimeout(self)
        self.timeout = self.timeout - 100

        if self.timeout > 0 then
            zo_callLater(
                function()
                    waitForTimeout(self)
                end, 100)
        else
            self.callback(self.count)
            self.debounce = false
            self.count = 0
        end
    end

    instance.Invoke = function(self)
        self.timeout = self.waitTimeMs
        self.count = self.count + 1
        if self.debounce then
            return
        end
        self.debounce = true

        waitForTimeout(self)
    end

    return instance
end

-- ==================================================================================================
-- CheckBox
local function CreateCheckBox(id, parent, data, key, text, tooltip, w, h)
    local control = WINDOW_MANAGER:CreateControl(id, parent, CT_CONTROL)
    control:SetMouseEnabled(true)
    control:SetDimensions(w or 150, h or 35)

    control.checkbox = WINDOW_MANAGER:CreateControl("$(parent)_cbx", control, CT_TEXTURE)
    control.checkbox:SetDimensions(35, 35)
    control.checkbox:SetAnchor(TOPLEFT, control, TOPLEFT)

    control.label = MapRadarCommon.CreateLabel("$(parent)_label", control, text)
    control.label:SetAnchor(LEFT, control.checkbox, RIGHT, 0, 1)

    control.SetChecked = function(self, value)
        data[key] = value
        self.checkbox:SetTexture(value and "esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
    end

    control:SetHandler(
        "OnMouseEnter", function(self)
            if tooltip then
                ZO_Tooltips_ShowTextTooltip(self, BOTTOM, tooltip)
            end
        end)
    control:SetHandler(
        "OnMouseExit", function(self)
            if tooltip then
                ZO_Tooltips_HideTextTooltip()
            end
        end)
    control:SetHandler(
        "OnMouseDown", function(self, button, ctrl, alt, shift)
            self:SetChecked(not data[key])
            CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
        end)

    -- Init state
    control:SetChecked(data[key])
    return control
end

-- ==================================================================================================
-- Slider
local function CreateSlider(id, parent, data, key, text, tooltip, w, h)
    local control = WINDOW_MANAGER:CreateControl(id, parent, CT_CONTROL)
    control:SetMouseEnabled(true)
    control:SetDimensions(w or 500, h or 35)

    control.label = MapRadarCommon.CreateLabel("$(parent)_label", control, text)
    control.label:SetAnchor(TOPLEFT, control, TOPLEFT)
    control.label:SetDimensions(100, 30)

    control.slider = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_slider", control, "ZO_Slider")
    control.slider:SetAnchor(TOPLEFT, control.label, TOPRIGHT, 5, 0)

    control.SetMinMaxStep = function(self, min, max, step)
        self.slider:SetValueStep(step)
        self.slider:SetMinMax(min, max)

        self.slider:SetValue(data[key])
        self.value:SetText(data[key])
    end

    control.SetLabelDimensions = function(self, w, h)
        self.lable:SetDimensions(w, h)
    end

    -- Value label
    control.value = CreateLabel("$(parent)_valueLabel", control, text)
    control.value:SetAnchor(LEFT, control.slider, RIGHT, 10)

    control.slider:SetHandler(
        "OnValueChanged", function(self, value, eventReason)
            -- This gets fired on some internal creation or something else and provides minimum value. Need to ignore it then
            if eventReason == EVENT_REASON_SOFTWARE then
                return
            end
            control.value:SetText(value)
            data[key] = value
            CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
        end)

    control.slider:SetHandler(
        "OnSliderReleased", function(self, value)

        end)

    -- Tooltip
    control:SetHandler(
        "OnMouseEnter", function(self)
            if tooltip then
                ZO_Tooltips_ShowTextTooltip(self, BOTTOM, tooltip)
            end
        end)
    control:SetHandler(
        "OnMouseExit", function(self)
            if tooltip then
                ZO_Tooltips_HideTextTooltip()
            end
        end)

    -- Init values
    control:SetMinMaxStep(0, 100, 1)

    return control
end

-- ==================================================================================================
-- namespace to export class to public
MapRadarCommon = {
    -- simple construcotr metods
    CreateLabel = CreateLabel,
    CreateCheckBox = CreateCheckBox,
    CreateSlider = CreateSlider,

    -- components
    LabelStack = LabelStack,
    DataForm = DataForm,
    Debouncer = Debouncer
 }

-- Just event to load some test demo
--[[
EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_PLAYER_ACTIVATED, function()

    end)
]]
