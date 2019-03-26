-- Change this value to reflect the maximum permitted speed of your train.
MAXIMUM_PERMITTED_SPEED = 60;

--[[
    Threshold can be set to a value or expression that the amount of leeway the player has if they exceeded
    the maximum permitted speed.

    Examples:
        - Train can travel 3mph above the speed limit without penalty:     
              THRESHOLD = 3;                    
        - Train can travel 5% above the speed limit (rounded down) without penalty: 
              THRESHOLD = math.floor((MAX_SPEED * 0.05));
]]
THRESHOLD = 3

FAILURE_SPEED = ((MAXIMUM_PERMITTED_SPEED + THRESHOLD) + 1);
FAILURE_MESSAGE = "Scenario failed! Train speed exceeded threshold limit.";

-- Condition check constants
CONDITION_NOT_YET_MET = 0;
CONDITION_SUCCEEDED = 1;
CONDITION_FAILED = 2;

function TestCondition(condition)
    _G["TestCondition" .. condition]();
end

function OnEvent(event)
    _G["OnEvent" .. event]();
end

--[[
    Entry point for the script.
    Add a Trigger Instruction to your player train with the Trigger Event named 'MonitorSpeed'
]]
function OnEventMonitorSpeed()
    SysCall("ScenarioManager:BeginConditionCheck", "IsPlayerTrainSpeeding");
end

function TestConditionIsPlayerTrainSpeeding()
    speed = GetSpeedInMPH();

    if (speed == FAILURE_SPEED) then 
        SysCall ("ScenarioManager:TriggerScenarioFailure", FAILURE_MESSAGE);
        return CONDITION_SUCCEEDED;
    end

    return CONDITION_NOT_YET_MET;
end

function GetSpeedInMPH()
    return math.abs(SysCall("PlayerEngine:GetSpeed")) * 2.23693629;
end