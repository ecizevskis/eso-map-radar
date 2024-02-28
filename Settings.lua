local function SettingsInit()
    -- local accountDefaults = {}
    -- MapRadar.aData = ZO_SavedVars:NewAccountWide("MapRadar_Data", 1, nil, accountDefaults)

    local defaults = {
        isOverlayMode = false
    }

    MapRadar.config = ZO_SavedVars:NewCharacterIdSettings("MapRadar_Data", 1, nil, defaults)

end

CALLBACK_MANAGER:RegisterCallback("OnMapRadarInitializing", function()
    SettingsInit()
end)
