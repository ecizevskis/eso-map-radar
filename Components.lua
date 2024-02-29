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
    local control = CreateLabel(name, parent, " ") -- Empty space forces to render tabel text and calc its bottom position for anchors

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

    return control
end

--[[
function LabelStack:SetFont(...)
    -- maybe need to iterate child label components and set that
    self.control:SetFont(...)
end

function LabelStack:SetColor(...)
    -- maybe need to iterate child label components and set that
    self.control:SetColor(...)
end

--]]

-- namespace to export class to public
MapRadarCommon = {
    LabelStack = LabelStack
}

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_PLAYER_ACTIVATED, function()
    local ls2 = MapRadarCommon.LabelStack:New("$(parent)Stacktest1", MapRadarContainer, 2)
    ls2:SetAnchor(TOP, GuiRoot, TOP, 0, 150)
    local ls5 = MapRadarCommon.LabelStack:New("$(parent)StackTest2", MapRadarContainer, 5)
    ls5:SetAnchor(TOPLEFT, ls2, BOTTOMLEFT)

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
