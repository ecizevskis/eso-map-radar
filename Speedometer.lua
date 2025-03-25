local mr = MapRadar
local zoneData = MapRadarZoneData
local getCurrentMapId = GetCurrentMapId

local speedometer = nil
local worldMap = ZO_WorldMap
local getMapPlayerPosition = GetMapPlayerPosition
local getUnitRawWorldPosition = GetUnitRawWorldPosition
local latestMapId = 0
local data = {
    px = 0,
    py = 0
 }

local function getMeterCoefficient()
    local zData = zoneData[getCurrentMapId()]
    if zData ~= nil then
        return zData
    end

    local calibratedData = mr.config.scaleData[getCurrentMapId()]
    if calibratedData ~= nil and calibratedData.unit1 ~= nil then
        return calibratedData.unit1
    end

    return 0
end

local function CreateLabel(anchorPoint, anchor, targetAnchorPoint, text)
    local label, labelKey = labelPool:AcquireObject()
    label:SetFont("$(BOLD_FONT)|16|outline")
    label:SetColor(1, 1, 1, 1)
    label:SetAnchor(anchorPoint, anchor, targetAnchorPoint)

    if text ~= nil then
        label:SetText(text)
    end

    return label;
end

local function CreateSpeedometer()

    local speedPos = MapRadar.config.speedPosition
    speedometer = MapRadarCommon.CreateLabel("$(parent)speedLabel", MapRadarContainer, "")
    speedometer:SetAnchor(speedPos.point, GuiRoot, speedPos.relativePoint, speedPos.offsetX, speedPos.offsetY)
    speedometer:SetMouseEnabled(true)
    speedometer:SetMovable(true)

    speedometer:SetFont("$(BOLD_FONT)|28|outline")

    speedometer:SetHandler(
        "OnMoveStop", function()
            local _, point, _, relativePoint, offsetX, offsetY = speedometer:GetAnchor(0)
            MapRadar.config.speedPosition = {
                point = point,
                relativePoint = relativePoint,
                offsetX = offsetX,
                offsetY = offsetY
             }
        end)
end

local function MapRadar_InitSpeedometer()
    CreateSpeedometer()
end

local function EnableOrDisableSpeedometer()
    if (speedometer ~= nil and speedometer.SetHidden ~= nil) then
        speedometer:SetHidden(not MapRadar.config.showSpeedometer)
    end

    if MapRadar.config.showSpeedometer then
        EVENT_MANAGER:RegisterForUpdate(
            "MapRadar_Speedometer", 200, function()
                local playerX, playerY = getMapPlayerPosition("player")
                local mps = 0

                if (data.px ~= 0 and data.py ~= 0) then
                    local dx = data.px - playerX
                    local dy = data.py - playerY

                    local distance = math.sqrt(dx ^ 2 + dy ^ 2) -- distance in percentage

                    local coefficient = getMeterCoefficient()

                    if (coefficient > 0) then
                        local meters = math.sqrt(dx ^ 2 + dy ^ 2) / coefficient -- distance in meters
                        mps = meters * 5 -- Update triggers 5 times per second
                    end
                end

                data.px = playerX
                data.py = playerY

                speedometer:SetText(zo_strformat("<<1>> m/s", mps))
            end)
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_Speedometer")
    end
end

local function MapRadar_ToggleSpeedometer()
    if MapRadar.config.showSpeedometer and speedometer == nil then
        MapRadar_InitSpeedometer()
    end

    EnableOrDisableSpeedometer()
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized", function()
        if MapRadar.config.scaleData == nil then
            MapRadar.config.scaleData = {}
        end

        MapRadar_ToggleSpeedometer()

    end)

CALLBACK_MANAGER:RegisterCallback("OnMapRadarSlashCommand", MapRadar_ToggleSpeedometer)
CALLBACK_MANAGER:RegisterCallback("MapRadar_Reset", MapRadar_ToggleSpeedometer)
