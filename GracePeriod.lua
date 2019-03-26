-- Change this value to reflect the maximum permitted speed of your train.
MAXIMUM_PERMITTED_SPEED = 60;

-- Time in seconds the player is allowed to correct their speed before the scenario fails.
GRACE_PERIOD = 10;

-- Speed at which the train is going too fast.
FAILURE_SPEED = (MAXIMUM_PERMITTED_SPEED + 1);

FAILURE_MESSAGE = "Scenario failed! Train speed exceeded " .. MAX_SPEED .. "mph for too long.";

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
        SysCall("ScenarioManager:TriggerDeferredEvent", "GracePeriod", GRACE_PERIOD);
        return CONDITION_SUCCEEDED;
    end
    return CONDITION_NOT_YET_MET;
end

function OnEventGracePeriod()
    if (speed == FAILURE_SPEED)
        SysCall ("ScenarioManager:TriggerScenarioFailure", FAILURE_MESSAGE);
        return CONDITION_SUCCEEDED;
    end
    return CONDITION_NOT_YET_MET;
end

function GetSpeedInMPH()
    return math.abs(SysCall("PlayerEngine:GetSpeed")) * 2.23693629;
end