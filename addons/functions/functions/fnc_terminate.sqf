#include "script_component.hpp"

// Reset data
missionNamespace setVariable [VAR_INITIALIZED, nil];
missionNamespace setVariable [VAR_LOGIC, nil, true];
missionNamespace setVariable [VAR_RANDOMISERS, nil];
missionNamespace setVariable [VAR_SIDES, nil, true];
missionNamespace setVariable [VAR_BASES, nil, true];
missionNamespace setVariable [VAR_OBJECTIVES, nil, true];
missionNamespace setVariable [VAR_ENDGAME_OBJECTIVE, nil];
missionNamespace setVariable [VAR_COMPLETED_OBJECTIVES, nil];
missionNamespace setVariable [VAR_MISSION_FLOW_FSM, nil];

// Log
"Terminate" call BIS_fnc_log;