--[[ 
    Change this value to reflect the maximum permitted speed of your train.
    Common examples:
        - Train witt 4xxx headcode: MAXIMUM_PERMITTED_SPEED = 75;
        - Train with 6xxx headcode: MAXIMUM_PERMITTED_SPEED = 60;
        - Train with 7xxx headcode: MAXIMUM_PERMITTED_SPEED = 45;
        - Train with 8xxx headcode: MAXIMUM_PERMITTED_SPEED = 35;
]]
MAXIMUM_PERMITTED_SPEED = 60;

-- Speed at which the train is going too fast.
FAILURE_SPEED = (MAXIMUM_PERMITTED_SPEED + 1);

--  This message will be displayed when the train has exceeded the maximum permitted speed.
FAILURE_MESSAGE = "Scenario failed! Train speed exceeded " .. MAXIMUM_PERMITTED_SPEED .. "mph.";

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