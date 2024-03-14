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

CALLBACK_MANAGER:RegisterCallback("OnMapRadarInitializing", function()
    SettingsInit()
end)
