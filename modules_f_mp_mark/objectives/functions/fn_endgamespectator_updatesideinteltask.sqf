#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

// Function that updates side task text
private _side 		= _this param [0, sideUnknown, [sideUnknown]];
private _isUpload 	= _this param [1, false, [false]];

if (!_isUpload) then
{
	private _all		= ["GetAllObjectives"] call INSTANCE;
	private _westCount	= 0;
	private _eastCount	= 0;

	{
		private _isStartGame 	= ["GetIsStartGame", [_x]] call OBJECTIVE;
		private _isEndGame 	= ["GetIsEndGame", [_x]] call OBJECTIVE;

		if (!_isStartGame && !_isEndGame) then
		{
			if (WEST in (["GetWinners", [_x]] call OBJECTIVE)) then { _westCount = _westCount + 1; };
			if (East in (["GetWinners", [_x]] call OBJECTIVE)) then { _eastCount = _eastCount + 1; };
		};
	} forEach _all;

	if (_side == WEST) then
	{
		["SetSideTask", [0, format ["INTEL [%1]", _westCount]]] call DISPLAY;	// TODO: Localize
	}
	else
	{
		["SetSideTask", [1, format ["[%1] INTEL", _eastCount]]] call DISPLAY;	// TODO: Localize
	};
};
