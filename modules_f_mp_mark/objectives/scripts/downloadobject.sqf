#include "\a3\modules_f_mp_mark\objectives\defines.inc"

scriptName "downloadObject.sqf";

BIS_downloadObject_context = objNull;
BIS_downloadObject_players = [];
BIS_downloadObject_usedObject = objNull;

// Checks whether current player can see the downloadable object
BIS_fnc_downloadObject_canSee = BIS_fnc_downloadObject_canSee_module;

// Checks whether current player can use the downloadable object

BIS_fnc_downloadObject_canUse = BIS_fnc_downloadObject_canUse_module;

// Returns nearest downloadable object in range
BIS_fnc_downloadObject_nearObject = BIS_fnc_downloadObject_nearObject_module;

// Code that runs when action is succeeded (bar filled)
BIS_fnc_downloadObject_onSucceeded = BIS_fnc_downloadObject_onSucceeded_module;

// Draw 3D
BIS_downloadObject_draw3D = addMissionEventHandler ["Draw3D",
{
	private _context			= BIS_downloadObject_context;
	private _nearPlayers		= BIS_downloadObject_players;

	if (!isNull _context) then
	{
		private _oldTickTime 	= missionNamespace getVariable ["BIS_downloadObject_lastTickTime", time];
		private _newTickTime 	= time;
		private _deltaTime		= _newTickTime - _oldTickTime;
		private _iconPosition 	= ASLToAGL (getPosASL _context);

		missionNamespace setVariable ["BIS_downloadObject_lastTickTime", _newTickTime];

		if (typeOf player != "VirtualSpectator_F") then
		{
			private _iconColor = [1.0, 1.0, 1.0, 0.5];
			private _iconAngle = 0;

			// Icon effects when object is being downloaded
			if ((_context getVariable [VAR_DOWNLOADING, sideUnknown]) != sideUnknown) then
			{
				private ["_oldAngle", "_newAngle"];
				_lastAngle = missionNamespace getVariable ["BIS_downloadObject_lastAngle", 0];
				_newAngle  = _lastAngle  - (720.0 * _deltaTime);
				missionNamespace setVariable ["BIS_downloadObject_lastAngle", _newAngle];

				_iconColor = [0.8, 1.0, 0.8, 0.5];
				_iconAngle = _newAngle;
			};

			// Icon effects when object is being connected to
			if (!isNull BIS_downloadObject_usedObject) then
			{
				private ["_oldAngle", "_newAngle"];
				_lastAngle = missionNamespace getVariable ["BIS_downloadObject_lastAngle", 0];
				_newAngle  = _lastAngle  - (360.0 * _deltaTime);
				missionNamespace setVariable ["BIS_downloadObject_lastAngle", _newAngle];

				_iconColor = [0.8, 0.8, 0.1, 0.5];
				_iconAngle = _newAngle;
			};

			// Draw icon
			if ([_context] call BIS_fnc_downloadObject_canSee_module) then
			{
				drawIcon3D ["a3\Ui_f\data\Map\Diary\signal_ca.paa", _iconColor, _iconPosition, 1.1, 1.1, _iconAngle, "", 0, 0.03, "PuristaMedium"];
			};
		};

		// Draw lines between downloading players and context object
		if (typeOf player == "VirtualSpectator_F" || { player in _nearPlayers }) then
		{
			{
				drawLine3D [_iconPosition, _x modelToWorldVisual (_x selectionPosition "Spine3"), [0.8, 1.0, 0.8, 0.3]];
			}
			forEach _nearPlayers;
		};

		// If uploading, draw line between context and pickup object
		if (!isNil { missionNamespace getVariable ["BIS_hvt_endGame", false] }) then
		{
			private _pickup = ["GetPickupObject"] call (missionNamespace getVariable ["bis_fnc_moduleMPTypeHvt_carrier", {}]);

			if (!isNull _pickup && { _context getVariable ["BIS_download_side", sideUnknown] == side group player || { typeOf player == "VirtualSpectator_F" && { _context getVariable ["BIS_download_side", sideUnknown] != sideUnknown } } }) then
			{
				drawLine3D [_iconPosition, getPosATLVisual _pickup, [0.8, 1.0, 0.8, 0.3]];
			};
		};
	};
}];

// Update context
while { true } do
{
	BIS_downloadObject_context = [] call BIS_fnc_downloadObject_nearObject_module;
	BIS_downloadObject_players = [];

	if (!isNull BIS_downloadObject_context) then
	{
		player reveal [BIS_downloadObject_context, 4];

		private _objective = BIS_downloadObject_context getVariable ["BIS_hvt_objectObjective", objNull];

		if ([BIS_downloadObject_context] call BIS_fnc_downloadObject_canSee_module) then
		{
			private _downloadSide 		= BIS_downloadObject_context getVariable [VAR_DOWNLOADING, sideUnknown];
			private _downloadDistance 	= if (!isNil { _objective getVariable VAR_DOWNLOAD_RADIUS }) then {_objective getVariable [VAR_DOWNLOAD_RADIUS, 20]} else {_objective getVariable [VAR_UPLOAD_RADIUS, 20]};

			BIS_downloadObject_players = allPlayers select {_x distance BIS_downloadObject_context < MAX_DISTANCE && {alive _x} && {isNull objectParent _x} && {side group _x isEqualTo _downloadSide} && {lifeState _x != "INCAPACITATED"}};

			if (isNull BIS_downloadObject_usedObject && {[BIS_downloadObject_context] call BIS_fnc_downloadObject_canUse_module}) then
			{
				BIS_downloadObject_usedObject = BIS_downloadObject_context;

				private _objective 			= BIS_downloadObject_usedObject getVariable ["BIS_hvt_objectObjective", objNull];
				private _isImediateDownload	= _objective getVariable [VAR_IMEDIATE_DOWNLOAD, false];
				private _text				= if (_isImediateDownload) then { localize "STR_A3_EndGame_Download_Searching" } else { localize "STR_A3_EndGame_Download_Connecting" };
				private _succeeded 			= [_text, 3.5, { [BIS_downloadObject_context] call BIS_fnc_downloadObject_canUse_module }] call BIS_fnc_keyHold;

				if (_succeeded) then
				{
					[BIS_downloadObject_context, player] call BIS_fnc_downloadObject_onSucceeded_module;
				};

				BIS_downloadObject_usedObject = objNull;
			};
		};
	};

	sleep MAX_RATE;
};