#include "script_component.hpp"

private ["_objective", "_show"];
_objective 	= _parameters param [0, objNull, [objNull]];
_show		= _parameters param [1, true, [true]];
if (isNull _objective) exitWith {};

private ["_objects", "_clutter"];
_objects 	= ["GetObjectiveObjects", [_objective]] call SELF;
_clutter	= ["GetClutterFromManager", [_objective]] call SELF;

{
	if (_show) then
	{
		if (!isMultiplayer) then
		{
			if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulation true; };
			_x hideObject false;
		}
		else
		{
			if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulationGlobal true; };
			_x hideObjectGlobal false;
		};

	} else {
		if (!isMultiplayer) then
		{
			if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulation false; };
			_x hideObject true;
		}
		else
		{
			if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulationGlobal false; };
			_x hideObjectGlobal true;
		};
	};
} forEach _objects + _clutter;

// Flag
_objective setVariable [VAR_VISIBLE, _show];