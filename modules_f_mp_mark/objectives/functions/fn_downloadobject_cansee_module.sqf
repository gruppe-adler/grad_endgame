#include "\a3\modules_f_mp_mark\objectives\defines.inc"

private _object = _this select 0;
private _canSee	= false;

if (!isNull _object) then
{
	private _objective 		= _object getVariable ["BIS_hvt_objectObjective", objNull];
	private _isEndGame		= _objective getVariable [VAR_KIND, ""] == "EndGame";
	private _isImediateDownload	= _objective getVariable [VAR_IMEDIATE_DOWNLOAD, false];

	if (
			alive player &&
			{ !(player getVariable ["BIS_revive_incapacitated", false]) } &&
		{ isNil { _object getVariable "BIS_hvt_intelDestroyed" } } &&
		{ _isEndGame || { isNil { BIS_hvt_endGame } } } &&
		{ !_isImediateDownload || { count (_object getVariable [VAR_DOWNLOADED_BY, []]) < 1 } } &&
		{ !(side group player in (_object getVariable [VAR_DOWNLOADED_BY, []])) }
	) then
	{
		_canSee = true;
	};
};

_canSee;
