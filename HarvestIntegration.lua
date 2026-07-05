-- ==================================================================================================
-- HarvestMap integration
-- Builds MapRadar's custom pin layer from the HarvestMap addon's node cache and keeps it in sync
-- with HarvestMap's zone/map/filter events.

local MR = MapRadar

-- Localize global objects for better performance
local getPlayerCameraHeading = GetPlayerCameraHeading
local getMapPlayerPosition = GetMapPlayerPosition

-- ==================================================================================================
-- Custom pin layer methods

local function MapRadar_ClearHarvestPins()
    -- Dispose pins
    for k, _ in pairs(MR.customPinLayer) do
        MR.customPinLayer[k]:Dispose()
        MR.customPinLayer[k] = nil
    end
end

-- Global: also invoked from MapRadar.lua (MapRadar_Reset callback in initialize)
function MapRadar_LoadHarvestPins()
    MapRadar_ClearHarvestPins()

    if not MapRadar.modeSettings.showHarvestMap then
        return
    end

    local harvestMapPins = Harvest["mapPins"]

    -- -- List Harvest mapPins module elements
    -- MR.debug("harvestMapPins module -------------------------------------------------")
    -- for key, v in pairs(harvestMapPins) do
    --     MR.debug("<<1>>: <<2>>", key, MR.getStrVal(v))
    -- end

    -- This can be null if Harvest has disabled "Show on minimap"
    if (harvestMapPins.mapCache) then
        -- MR.debug("harvestMapPins.mapCache --------------------------------------------------")
        -- for key, v in pairs(harvestMapPins.mapCache) do
        --     MR.debug("<<1>>: <<2>>", key, MR.getStrVal(v))
        -- end

        local playerX, playerY = getMapPlayerPosition("player")
        local heading = getPlayerCameraHeading()

        -- MR.debug("harvestMapPins.mapCache.divisions --------------------------------------------------")
        for pinTypeId, division in pairs(harvestMapPins.mapCache.divisions) do
            if Harvest.InRangePins.worldFilterProfile[pinTypeId] then
                -- MR.debug("-------------------- PinTypeId <<1>>", MR.getStrVal(pinTypeId))

                for diviKey, divI in pairs(division) do
                    -- MR.debug("<<1>>: <<2>> --------------", diviKey, MR.getStrVal(divI))

                    for nodeKey, nodeId in pairs(divI) do
                        local x, y = harvestMapPins.mapCache:GetLocal(nodeId)
                        local texturePath = Harvest.settings.savedVars.settings.pinLayouts[pinTypeId].texture
                        -- MR.debug("<<1>>: <<2>>  (<<3>> <<4>>) <<5>>", nodeKey, MR.getStrVal(nodeId), MR.getStrVal(x), MR.getStrVal(y), texturePath)

                        local customPin = MapRadarHarvestPin:New(nodeId, x, y, pinTypeId, texturePath)
                        customPin:UpdatePin(playerX, playerY, heading, true)
                        MR.customPinLayer[nodeId] = customPin
                        -- MR.debug("Added customPin with key: <<1>>", nodeId)
                    end
                end
            end
        end
    end
end

-- ==================================================================================================
-- Event handlers

local function onPlayerActivated(eventCode, initial)
    -- All addons already loaded at this stage.
    if Harvest then
        -- Guard against HarvestMap renaming/removing events (e.g. NEW_NODES_LOADED_TO_CACHE
        -- was replaced by NEW_ZONE_ENTERED), so a missing event degrades gracefully
        -- instead of crashing on login inside CallbackManager:RegisterCallback.
        local function safeRegister(eventId, callback)
            if eventId then
                Harvest.callbackManager:RegisterCallback(eventId, callback)
            end
        end

        safeRegister(
            Harvest.events.NEW_ZONE_ENTERED, function()
                MapRadar_LoadHarvestPins()
            end
        )

        safeRegister(
            Harvest.events.MAP_CHANGE, function()
                MapRadar_LoadHarvestPins()
            end
        )

        safeRegister(
            Harvest.events.FILTER_PROFILE_CHANGED, function()
                MapRadar_LoadHarvestPins()
            end
        )
    end

    -- Prevents from firing this event each zone change
    EVENT_MANAGER:UnregisterForEvent("MapRadar", EVENT_PLAYER_ACTIVATED)
end

EVENT_MANAGER:RegisterForEvent("MapRadar", EVENT_PLAYER_ACTIVATED, onPlayerActivated)
