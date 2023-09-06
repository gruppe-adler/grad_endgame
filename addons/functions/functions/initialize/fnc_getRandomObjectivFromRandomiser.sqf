#include "script_component.hpp"

params [["_randomiser", objNull, [objNull]]];

private _syncedObjectives = [_randomiser] call FUNC(getAllSyncedObjectives);
private _objective = objNull;

if (count _syncedObjectives > 0) then {
    _objective = selectRandom _syncedObjectives;
    _randomiser setVariable ["BIS_selectedObjective", _objective];
};

_objective;