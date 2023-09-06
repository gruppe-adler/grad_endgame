#include "script_component.hpp"

private ["_phase", "_side"];
_phase = _parameters param [0, 0, [0]];
_side  = _parameters param [1, sideUnknown, [sideUnknown]];

private "_musicClass";
_musicClass = switch (_phase) do
{
	case 1 : { (["GetLogic"] call SELF) getVariable ["PhaseOneMusic", ""]; };
	case 2 : { (["GetLogic"] call SELF) getVariable ["PhaseTwoMusic", ""]; };
	case 3 : { (["GetLogic"] call SELF) getVariable ["PhaseThreeMusic", ""]; };
	default  { ""; };
};

if (_musicClass != "") then
{
	private "_target";
	_target = if (_side == sideUnknown) then { true } else { _side };

	// Play music
	[_musicClass, "playMusic", _target, _phase == 1] call BIS_fnc_mp;
};