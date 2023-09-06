#include "script_component.hpp"

private ["_objectives", "_randomisers", "_objectivesFromRandomisers"];
_objectives 				= ["GetAllObjectives"] call SELF;
_randomisers 				= ["GetAllSyncedRandomisers"] call SELF;
_objectivesFromRandomisers	= [];

{
	private "_objectivesOfRandomiser";
	_objectivesOfRandomiser = ["GetAllSyncedObjectives", [_x]] call SELF;

	{
		_objectivesFromRandomisers pushBack _x;
	} forEach _objectivesOfRandomiser;
} forEach _randomisers;

_objectivesFromRandomisers - _objectives;