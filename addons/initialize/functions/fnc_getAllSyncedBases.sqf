#include "script_component.hpp"

private _objects 	= synchronizedObjects (missionNamespace getVariable "BIS_MODULEHVTOBJECTIVESINSTANCE_LOGIC");
private _bases		= [];

{
    if (_x isKindOf CLASS_STARTGAME_OBJECTIVE) then
    {
        _bases pushBack _x;
    };
} forEach _objects;

_bases;