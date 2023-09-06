#include "script_component.hpp"

private _objects = synchronizedObjects (missionNamespace getVariable VAR_LOGIC);
private _bases = [];

{
    diag_log format ["GRAD ENDGAME: isKindBase: %1 == %2", _x, CLASS_STARTGAME_OBJECTIVE];
    if (_x isKindOf CLASS_STARTGAME_OBJECTIVE) then
    {
        _bases pushBack _x;
    };
} forEach _objects;

systemChat format ["GRAD ENDGAME: Synced Bases: %1 ", _bases];
diag_log format ["GRAD ENDGAME: Synced Bases: %1 ", _bases];

_bases;