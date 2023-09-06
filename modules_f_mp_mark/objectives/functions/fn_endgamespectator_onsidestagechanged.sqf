#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

// Function that handles stage changes for spectator
private ["_stage", "_side"];
_stage 	= _this param [0, -1, [-1]];
_side 	= _this param [1, sideUnknown, [sideUnknown]];

if (_side == sideUnknown) exitWith {};

private _pickupInfo = ["GetPickupInfo"] call CARRIER;
private _lockedTo 	= _pickupInfo select 3;
private _sideIndex 	= if (_side == WEST) then { 0 } else { 1 };
private _localized 	= if (_side == _lockedTo) then {"STR_A3_Sectator_HeadToHead_Retrieve"} else {"STR_A3_Sectator_HeadToHead_Defend"};

switch (_stage) do
{
	case 0 : { ["SetSideTask", [_sideIndex, localize "STR_A3_mp_groundsupport_logics_fob"]] call DISPLAY; };
	case 1 : { [_side, false] call BIS_fnc_endGameSpectator_updateSideIntelTask; };
	case 2 : { ["SetSideTask", [_sideIndex, localize _localized]] call DISPLAY; };
};
