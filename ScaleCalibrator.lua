local scaleLabel = {}

local function setScaleLabel(val)
    MapRadar.scale = MapRadar.scale + val
    scaleLabel:SetText(MapRadar.scale)
    MapRadar.PinReset()
end

function MapRadar_InitScaleCalibrator(parent)

    local mgridTexture = CreateControl("$(parent)Mgrid", MapRadarContainer, CT_TEXTURE)
    mgridTexture:SetTexture("MapRadar/mgrid.dds")
    mgridTexture:SetAnchor(CENTER, parent, CENTER)
    mgridTexture:SetDimensions(329, 329)
    -- mgridTexture:SetAlpha(0.5)

    scaleLabel = CreateControl("$(parent)ScaleLabel", MapRadarContainer, CT_LABEL)
    scaleLabel:SetAnchor(TOPLEFT, MapRadarContainer, TOPRIGHT, 20, 40)
    scaleLabel:SetFont("$(MEDIUM_FONT)|14|outline")
    scaleLabel:SetColor(unpack({1, 1, 1, 1}))
    setScaleLabel(0)

    local btnAdd01 = CreateControlFromVirtual("$(parent)btnAdd01", MapRadarContainer, "plusButtonTemplate")
    btnAdd01:SetAnchor(TOPLEFT, scaleLabel, TOPRIGHT)
    btnAdd01:SetHandler("OnClicked", function()
        setScaleLabel(0.1)
    end)

    local btnSub01 = CreateControlFromVirtual("$(parent)btnSub01", MapRadarContainer, "minusButtonTemplate")
    btnSub01:SetAnchor(TOPLEFT, btnAdd01, BOTTOMLEFT)
    btnSub01:SetHandler("OnClicked", function()
        setScaleLabel(-0.1)
    end)

    local btnAdd001 = CreateControlFromVirtual("$(parent)btnAdd001", MapRadarContainer, "plusButtonTemplate")
    btnAdd001:SetAnchor(TOPLEFT, btnAdd01, TOPRIGHT)
    btnAdd001:SetHandler("OnClicked", function()
        setScaleLabel(0.01)
    end)

    local btnSub001 = CreateControlFromVirtual("$(parent)btnSub001", MapRadarContainer, "minusButtonTemplate")
    btnSub001:SetAnchor(TOPLEFT, btnAdd001, BOTTOMLEFT)
    btnSub001:SetHandler("OnClicked", function()
        setScaleLabel(-0.01)
    end)

    local btnAdd0001 = CreateControlFromVirtual("$(parent)btnAdd0001", MapRadarContainer, "plusButtonTemplate")
    btnAdd0001:SetAnchor(TOPLEFT, btnAdd001, TOPRIGHT)
    btnAdd0001:SetHandler("OnClicked", function()
        setScaleLabel(0.001)
    end)

    local btnSub0001 = CreateControlFromVirtual("$(parent)btnSub0001", MapRadarContainer, "minusButtonTemplate")
    btnSub0001:SetAnchor(TOPLEFT, btnAdd0001, BOTTOMLEFT)
    btnSub0001:SetHandler("OnClicked", function()
        setScaleLabel(-0.001)
    end)

end
