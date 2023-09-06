#include "\a3\modules_f_mp_mark\objectives\defines.inc"

private _object = _this param [0, objNull, [objNull]];
private _canUse	= false;

if (
		alive player &&
		{ !(player getVariable ["BIS_revive_incapacitated", false]) } &&
	{ !isNull _object } &&
	{ !isNull cursorTarget } &&
	{ vehicle player == player } &&
	{ cursorTarget == _object } &&
	{ _object distance player <= 7.5 } &&
	{ (_object getVariable [VAR_DOWNLOADING, sideUnknown]) == sideUnknown } &&
	{ count (_object getVariable [VAR_DOWNLOADED_BY, []]) <= 1 } &&
	{ !(side group player in (_object getVariable [VAR_DOWNLOADED_BY, []])) }
) then
{
	_canUse = true;

	private _objective = _object getVariable ["BIS_hvt_objectObjective", objNull];

	if (!isNull _objective && {_objective getVariable [VAR_KIND, ""] == "EndGame"}) then
	{
		_canUse = [_object, player] call bis_fnc_moduleMPTypeHvt_carrier_canUpload;
	};
};

_canUse;
