#include "\a3\modules_f_mp_mark\objectives\defines.inc"

params [["_object", objNull, [objNull]], ["_player", objNull, [objNull]]];

if (!isNull _object && { !isNull _player } && { alive _player }) then
{
	private _objective 	= _object getVariable ["BIS_hvt_objectObjective", objNull];
	private _inUse		= _object getVariable [VAR_DOWNLOADING, sideUnknown] != sideUnknown;

	if (!isNull _objective && { !_inUse }) then
	{
		private _isImediateDownload 	= _objective getVariable [VAR_IMEDIATE_DOWNLOAD, false];
		private _isEndGame				= ["GetIsEndGame", [_objective]] call BIS_fnc_moduleHvtObjective;

		if (!_isEndGame) then
		{
			if (_isImediateDownload) then
			{
				private _side 	= side group _player;
				private _list 	= _object getVariable [VAR_DOWNLOADED_BY, []];

				if !(_side in _list) then
				{
					_list pushBack _side;
					_object setVariable [VAR_DOWNLOADED_BY, _list, true];
					[["RegisterWinner", [_objective, _side]], "BIS_fnc_moduleHvtObjective", false, false] call BIS_fnc_mp;
				};

				// Make object destructible
				[[_object, true], "allowDamage", true, true] call BIS_fnc_mp;

				// Download completed event handler, get's called from Download.fsm for non imediate pickups
				_side spawn
				{
					sleep 2.5;
					[[missionNamespace, "EndGame_OnDownloadCompleted", [_this, false], false], "BIS_fnc_callScriptedEventHandler", true, false, true] call BIS_fnc_mp;
				};
			}
			else
			{
				[[[_objective, _object, _player, nil, ["GetDownloadRadius", [_objective]] call BIS_fnc_moduleHvtObjective, true], "a3\Modules_F_MP_Mark\Objectives\fsms\Download.fsm"], "BIS_fnc_execFSM", _objective, false] call BIS_fnc_mp;
			};
		}
		else
		{
			["ServerExecute", ["UploadStart", [_player]]] call bis_fnc_moduleMPTypeHvt_carrier;
		};
	};
};
