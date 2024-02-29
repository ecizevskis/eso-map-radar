-- ==================================================================================================
-- Local generation methods
local function CreateLabel(name, parent, text)
    local label = CreateControl(name, parent, CT_LABEL)
    label:SetFont("$(BOLD_FONT)|18|outline")
    label:SetColor(unpack({1, 1, 1, 1}))
    -- label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

-- ==================================================================================================
-- Label stack
local LabelStack = {}
function LabelStack:New(name, parent, count)
    local labelStack = {
        name = name,
        count = count,
        control = CreateControl(name, parent, CT_CONTROL),
        labels = {}
    }
    setmetatable(labelStack, self)
    self.__index = self

    local label = CreateLabel("$(parent)placeholder", labelStack.control)
    label:SetAnchor(TOPLEFT, labelStack.control, TOPLEFT)
    label:SetAnchor(BOTTOMLEFT, labelStack.control, BOTTOMLEFT) -- maybe would be required to keep parent control height in check

    -- Create list of label controls here and anchor them together
    for i = 1, count do
        local nextLabel = CreateLabel("$(parent)Label" .. i, labelStack.control)
        nextLabel:SetAnchor(TOPLEFT, label, TOPRIGHT, 10)
        labelStack.labels[i] = nextLabel
        label = nextLabel
    end

    return labelStack
end

function LabelStack:SetAnchor(...)
    self.control:SetAnchor(...)
end

function LabelStack:SetFont(...)
    -- maybe need to iterate child label components and set that
    self.control:SetFont(...)
end

function LabelStack:SetColor(...)
    -- maybe need to iterate child label components and set that
    self.control:SetColor(...)
end

function LabelStack:SetText(text)
    -- puch all label texts further 
    for i = self.count, 2, -1 do
        self.labels[i]:SetText(self.labels[i - 1]:GetText())
    end
    self.labels[1]:SetText(text)
end

function LabelStack:getName()
    return self.name
end

-- namespace to export class to public
MapRadarCommon = {
    LabelStack = LabelStack
}

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_PLAYER_ACTIVATED, function()
    local ls2 = MapRadarCommon.LabelStack:New("$(parent)Stacktest1", MapRadarContainer, 2)
    ls2:SetAnchor(TOP, GuiRoot, TOP, 0, 150)
    local ls5 = MapRadarCommon.LabelStack:New("$(parent)StackTest2", MapRadarContainer, 5)
    ls5:SetAnchor(TOPLEFT, ls2.control, BOTTOMLEFT, 0, 30)

    -- MapRadar.debug("C Name: <<1>>", MapRadar.getVal(ls2:getName()))
    -- MapRadar.debug("C2 Name: <<1>>", MapRadar.getVal(ls5:getName()))

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

end)
