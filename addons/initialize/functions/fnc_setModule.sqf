#include "script_component.hpp"

params [
    ["_logic", objNull, [objNull]], 
    ["_units", [], [[]]], 
    ["_activated", true, [true]]
];

if (_activated) then
{
    // The type of module
    switch (typeOf _logic) do
    {
        case QGVAR(ModuleHvt{ _this call BIS_fnc_moduleHvtObjective; }sInstance) :
        {
            private _endGameThreshold = _logic getVariable ["EndGameThreshold", 3];

            [_logic, _endGameThreshold] call FUNC(init);
        };

        case QGVAR(ModuleHvtSimple{ _this call BIS_fnc_moduleHvtObjective; }) :
        {
            (_this select 0) setVariable ["typeCustom", "Simple"];
        };

        case QGVAR(ModuleHvtStartGame{ _this call BIS_fnc_moduleHvtObjective; }) :
        {
            (_this select 0) setVariable ["typeCustom", "StartGame"];
        };

        case QGVAR(ModuleHvtEndGame{ _this call BIS_fnc_moduleHvtObjective; }) :
        {
            (_this select 0) setVariable ["typeCustom", "EndGame"];
        };
    };
};

true;