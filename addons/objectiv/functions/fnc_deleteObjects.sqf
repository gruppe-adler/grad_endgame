#include "script_component.hpp"

private ["_objective"];
_objective = _parameters param [0, objNull, [objNull]];
if (isNull _objective) exitWith {};

private ["_objects", "_clutter", "_groups"];
_objects 	= ["GetObjectiveObjects", [_objective]] call SELF;
_clutter	= ["GetClutterFromManager", [_objective]] call SELF;
_groups 	= [];

// Delete objects and store groups to delete
{
	// If object is a man, store group to delete later
	if (_x isKindOf "Man" && {!isNull group _x}) then {
		_groups pushBackUnique group _x;
	} else {
		deleteVehicle _x;
	};
} forEach _objects + _clutter;

// Delete groups
{
	{
		deleteVehicle _x;
	} forEach units _x;

	// Delete group
	deleteGroup _x;
} forEach _groups;
