#include "script_component.hpp"

private _objects 	= synchronizedObjects (missionNamespace getVariable "BIS_MODULEHVTOBJECTIVESINSTANCE_LOGIC");
private _randomisers	= [];

{
    if (_x isKindOf CLASS_OBJECTIVE_RANDOMISER) then
    {
        _randomisers pushBack _x;
    };
} forEach _objects;

_randomisers;