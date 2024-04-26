local scaleLabel = {}
local labelPool = ZO_ControlPool:New("LabelTemplate", MapRadarContainer, "Data")
local dataForm = nil
local worldMap = ZO_WorldMap
local getMapPlayerPosition = GetMapPlayerPosition

local ScaleData = {
    px = 0,
    py = 0
 }

local storedPos1 = {}

-- TODO: 
-- Data save button to saved variables
-- Create label/data form component with confing methods
-- Create data stack component
-- Add data label/datastack to form component

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

local function calc1meter(x1, y1, x2, y2, measuredMeters)
    local dx = x1 - x2
    local dy = y1 - y2

    local distance = math.sqrt(dx ^ 2 + dy ^ 2) -- distance in percentage

    return distance / measuredMeters -- calculate map part for 1 meter
end

local function saveMeasuredDistance(measuredMeters)
    local data = {
        dx = ScaleData.px - storedPos1.px,
        dy = ScaleData.py - storedPos1.py,
        unit1 = calc1meter(ScaleData.px, ScaleData.py, storedPos1.px, storedPos1.py, measuredMeters),
        mapId = GetCurrentMapId(),
        name = worldMap.zoneName,
        distance = measuredMeters
     }

    MapRadar.config.scaleData[data.mapId] = data
    MapRadar.debug("Saved one meter unit data (<<1>>) for zone: <<2>>", MapRadar.getStrVal(data.unit1), worldMap.zoneName)
end

local function selfData()
    local playerX, playerY = getMapPlayerPosition("player")

    ScaleData.px = playerX
    ScaleData.py = playerY
end

local displayMultiplier = 10000000
local function CreateCalibrationDataForm()

    dataForm = MapRadarCommon.DataForm:New("CalibrateDataForm", MapRadarContainer)
    dataForm:SetAnchor(LEFT, GuiRoot, LEFT, 150, -100)

    dataForm:AddLabel(
        "GetCurrentMapId", function()
            return GetCurrentMapId()
        end)

    dataForm:AddLabel(
        "Active zone", function()
            return GetPlayerActiveZoneName()
        end)

    dataForm:AddLabel(
        "Zone", function()
            return worldMap.zoneName
        end)
    dataForm:AddLabel(
        "Rel PX", function()
            return ScaleData.px
        end)
    dataForm:AddLabel(
        "Rel PY", function()
            return ScaleData.py
        end)

    local btnSavePosition1 = CreateControlFromVirtual("$(parent)btnSavePosition1", dataForm, "ZO_NextArrowButton")
    btnSavePosition1:SetDimensions(40, 40)
    btnSavePosition1:SetAnchor(TOPLEFT, dataForm, BOTTOMLEFT, 0, 10)
    btnSavePosition1:SetHandler(
        "OnClicked", function()
            storedPos1.px = ScaleData.px
            storedPos1.py = ScaleData.py

            MapRadar.debug("Saved position one")
        end)
    btnSavePosition1:SetHandler(
        "OnMouseEnter", function(self)
            ZO_Tooltips_ShowTextTooltip(self, BOTTOM, "Save current player position")
        end)
    btnSavePosition1:SetHandler(
        "OnMouseExit", function(self)
            ZO_Tooltips_HideTextTooltip()
        end)

    local btnCalculate1 = CreateControlFromVirtual("$(parent)btnCalculate1", dataForm, "ZO_PlusButton")
    btnCalculate1:SetDimensions(40, 40)
    btnCalculate1:SetAnchor(TOPLEFT, btnSavePosition1, TOPRIGHT)
    btnCalculate1:SetHandler(
        "OnClicked", function()
            saveMeasuredDistance(40);
        end)
    btnCalculate1:SetHandler(
        "OnMouseEnter", function(self)
            ZO_Tooltips_ShowTextTooltip(self, BOTTOM, "Calculate and save calibration data")
        end)
    btnCalculate1:SetHandler(
        "OnMouseExit", function(self)
            ZO_Tooltips_HideTextTooltip()
        end)

    local btnCalculate2 = CreateControlFromVirtual("$(parent)btnCalculate2", dataForm, "ZO_PlusButton")
    btnCalculate2:SetDimensions(40, 40)
    btnCalculate2:SetAnchor(TOPLEFT, btnCalculate1, TOPRIGHT)
    btnCalculate2:SetHandler(
        "OnClicked", function()
            saveMeasuredDistance(12);
        end)
    btnCalculate2:SetHandler(
        "OnMouseEnter", function(self)
            ZO_Tooltips_ShowTextTooltip(self, BOTTOM, "Calculate and save calibration data 12m")
        end)
    btnCalculate2:SetHandler(
        "OnMouseExit", function(self)
            ZO_Tooltips_HideTextTooltip()
        end)

    local labelSoloCalibration = MapRadarCommon.CreateLabel("$(parent)labelSoloCalibration", dataForm, "Solo Calibration")
    labelSoloCalibration:SetAnchor(RIGHT, btnSavePosition1, LEFT)

end

local function MapRadar_InitScaleCalibrator()
    CreateCalibrationDataForm()

end

local function EnableOrDisableCalibrator()
    if (dataForm ~= nil and dataForm.SetHidden ~= nil) then
        dataForm:SetHidden(not MapRadar.config.showCalibrate)
    end

    if MapRadar.config.showCalibrate then
        EVENT_MANAGER:RegisterForUpdate(
            "MapRadar_CalibrationData", 100, function()
                selfData()
                dataForm:Update()
            end)
    else
        EVENT_MANAGER:UnregisterForUpdate("MapRadar_CalibrationData")
    end
end

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarInitialized", function()
        if MapRadar.config.scaleData == nil then
            MapRadar.config.scaleData = {}
        end

        if MapRadar.config.showCalibrate then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end)

CALLBACK_MANAGER:RegisterCallback(
    "OnMapRadarSlashCommand", function()
        if MapRadar.config.showCalibrate and dataForm == nil then
            MapRadar_InitScaleCalibrator()
        end

        EnableOrDisableCalibrator()
    end)
