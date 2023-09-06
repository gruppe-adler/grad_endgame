#include "script_component.hpp"

params [
    ["_logic", objNull, [objNull]], 
    ["_units", [], [[]]], 
    ["_activated", true, [true]]
];

diag_log format ["GRAD ENDGAME: Set Module, Logic: %1", _logic];

if (_activated) then
{
    // The type of module
    switch (typeOf _logic) do
    {
        case QGVAR(ModuleHvtObjectivesInstance) :
        {
            private _endGameThreshold = _logic getVariable ["EndGameThreshold", 3];

            [_logic, _endGameThreshold] call FUNC(init);
        };

        case QGVAR(ModuleHvtSimpleObjective) :
        {
            (_this select 0) setVariable ["typeCustom", "Simple"];
        };

        case QGVAR(ModuleHvtStartGameObjective) :
        {
            (_this select 0) setVariable ["typeCustom", "StartGame"];
        };

        case QGVAR(ModuleHvtEndGameObjective) :
        {
            (_this select 0) setVariable ["typeCustom", "EndGame"];
        };
    };
};

true;