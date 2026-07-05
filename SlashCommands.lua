-- ==================================================================================================
-- Slash commands (/mapradar, /mr)

local MR = MapRadar

-- Flip container[key] and echo its new state, e.g. "Show names: ON"
local function toggleFlag(container, key, label)
    container[key] = not container[key]
    d(label .. ": " .. (container[key] and "ON" or "OFF"))
end

local function slashCommands(args)
    if args == "config" then
        MapRadar_toggleSettings()
    end

    if args == "mode" then
        MR.setOverlayMode(not MR.config.isOverlayMode)
    end

    -- Simple on/off toggles: arg -> { container, key, label }.
    -- Built here rather than at module scope because MR.config only exists after init.
    local toggles = {
        all = {MR, "showAllPins", "Show all pins"},
        names = {MR, "showPinNames", "Show names"},
        para = {MR, "showPinParams", "Show params"},
        debug = {MR.config, "showDebug", "Show Debug"},
        simulate = {MR.config, "calibrationSimulation", "Simulate mode"},
        calibrate = {MR.config, "showCalibrate", "Show calibrate"},
        analyzer = {MR.config, "showAnalyzer", "Show analyzer"},
        speed = {MR.config, "showSpeedometer", "Show Speedometer"}
    }

    local toggle = toggles[args]
    if toggle then
        toggleFlag(toggle[1], toggle[2], toggle[3])
    end

    if args == "recalibrate" then
        local mapId = GetCurrentMapId()
        MapRadarAutoscaled[mapId] = nil
        MapRadar.accountData.worldScaleData[mapId] = nil
        d("Recalibrating mapId: " .. mapId)
    end

    CALLBACK_MANAGER:FireCallbacks("MapRadar_Reset")
    CALLBACK_MANAGER:FireCallbacks("OnMapRadarSlashCommand", args)
end

SLASH_COMMANDS["/mapradar"] = slashCommands
SLASH_COMMANDS["/mr"] = slashCommands
