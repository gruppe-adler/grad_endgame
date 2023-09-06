#include "script_component.hpp"

params [
    ["_stageOfSide", 0, [0]],
    ["_side", sideUnknown, [sideUnknown]]
];

// Do not allow setting the same stage
if (_side isEqualTo sideUnknown ) exitWith {};

private _stage = missionNamespace getVariable [QGVAR(stage), [0, 0];

if (_stageOfSide != _stage) then {

    private _index = if (_side == WEST) then { 0 } else { 1 };

    _stage set [_index, _stageOfSide];
    missionNamespace getVariable [QGVAR(stage), _stage, true];

    [QGVAR(OnStageChanged), _stage, _side] call CBA_fnc_targetEvent;
};