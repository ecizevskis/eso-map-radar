-- ==================================================================================================
-- Local generation methods
local function CreateLabel(name, parent, text)
    local label = CreateControl(name, parent, CT_LABEL)
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(unpack({1, 1, 1, 1}))

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
-- Label stack
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
        dataLabel:SetColor(unpack({1, 1, 1, 1}))

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

    control.Update = function(self)
        for k, dataLabel in pairs(self.labels) do
            dataLabel.control:SetText(dataLabel.fetch())
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
-- namespace to export class to public
MapRadarCommon = {
    -- simple construcotr metods
    CreateLabel = CreateLabel,

    -- components
    LabelStack = LabelStack,
    DataForm = DataForm,
    Debouncer = Debouncer
}

EVENT_MANAGER:RegisterForEvent(
    "MapRadar", EVENT_PLAYER_ACTIVATED, function()
        --[[
    local ls2 = MapRadarCommon.LabelStack:New("$(parent)Stacktest1", MapRadarContainer, 2)
    ls2:SetAnchor(TOP, GuiRoot, TOP, 0, 150)
    ls2:SetFont("$(BOLD_FONT)|14|outline")

    local ls5 = MapRadarCommon.LabelStack:New("$(parent)StackTest2", MapRadarContainer, 5)
    ls5:SetAnchor(TOPLEFT, ls2, BOTTOMLEFT)
    ls5:SetColor(unpack({1, 0.4, 0.6, 1}))

    zo_callLater(function()
        ls2:SetText(123)
        ls5:SetText(123)
    end, 1000)

    zo_callLater(function()
        ls2:SetText(234)
        ls5:SetText(234)
    end, 3000)

    zo_callLater(function()
        ls2:SetText(345)
        ls5:SetText(345)
    end, 5000)

    zo_callLater(function()
        ls2:SetText(456)
        ls5:SetText(456)
    end, 7000)

    zo_callLater(function()
        ls2:SetText(567)
        ls5:SetText(567)
    end, 9000)
    --]]

    end)
