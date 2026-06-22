MapRadarHarvestPin =
    setmetatable(
    {},
    {
        __index = MapRadarPinBase
    }
)
-- ========================================================================================
-- ctor
function MapRadarHarvestPin:New(key, x, y, pinTypeId, texturePath)
    local pin = MapRadarPinBase:New(key, x, y)
    setmetatable(
        pin,
        {
            __index = self
        }
    )

    pin.pinTypeId = pinTypeId

    pin.texturePath = texturePath
    pin.texture:SetTexture(texturePath)

    local tint = Harvest.settings.defaultSettings.pinLayouts[pinTypeId].tint
    pin.texture:SetColor(tint.r, tint.g, tint.b, 1)

    -- pin:ApplyTexture()

    return pin
end
