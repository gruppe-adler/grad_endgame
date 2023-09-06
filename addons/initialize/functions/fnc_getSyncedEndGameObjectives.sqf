#include "script_component.hpp"

private _logic = missionNamespace getVariable VAR_LOGIC;

private _objects = synchronizedObjects _logic;
private _objectives	= [];

{
    if (_x isKindOf CLASS_ENDGAME_OBJECTIVE) then
    {
        _objectives pushBack _x;
    };
} forEach _objects;

_objectives;