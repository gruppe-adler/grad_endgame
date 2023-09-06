disableSerialization;

#define SELF  					{ _this call (missionNamespace getVariable ["bis_fnc_moduleMPTypeHvt_downloadProgress", {}]); }
#define PHASE 					{ _this call (uiNamespace getVariable ["RscHvtPhase_script", {}]); }

#define VAR_DOWNLOAD_INITIALIZED		"BIS_download_initialized"
#define VAR_DOWNLOAD_THREAD			"BIS_download_thread"
#define VAR_DOWNLOAD_THREAD_UI			"BIS_download_threadUi"
#define VAR_DOWNLOAD_OBJECT			"BIS_download_object"

#define VAR_DOWNLOAD_SHOWN			"BIS_download_uiShown"

#define VAR_DOWNLOAD_SIDE			"BIS_download_side"
#define VAR_DOWNLOAD_PROGRESS			"BIS_download_progress"
#define VAR_DOWNLOAD_SPEED			"BIS_download_speed"

#define VAR_DOWNLOAD_TIME_LOSING_CONNECTION	"BIS_download_timeLosingConnection"

private ["_mode", "_params"];
_mode 	= _this param [0, "", [""]];
_params	= _this param [1, [], [[]]];

switch (_mode) do
{
	case "Initialize" :
	{
		// Initialize main update loop
		missionNamespace setVariable [VAR_DOWNLOAD_THREAD, ["Update", _params] spawn SELF];

		// Flag as initialized
		missionNamespace setVariable [VAR_DOWNLOAD_INITIALIZED, true];
	};

	case "Terminate" :
	{
		// Stop main thread
		terminate (missionNamespace getVariable VAR_DOWNLOAD_THREAD);

		// Flag as initialized
		missionNamespace setVariable [VAR_DOWNLOAD_INITIALIZED, nil];
	};

	case "Update" :
	{
		scriptName "DownloadProgress: Update";
		disableSerialization;

		private ["_maxDistance"];
		_maxDistance = _params param [0, 10, [0]];

		while { true } do
		{
			// Make sure player is alive and could, eventually, download
			if
			(
				alive player &&
				vehicle player == player &&
				!(player getVariable ["BIS_revive_incapacitated", false])
			)
			then
			{
				// Let's see if we are near any downloadable object
				private ["_nearObjects", "_downloadableObjects"];
				_nearObjects 		= player nearObjects 100; // 100 m is a lot!
				_downloadableObjects 	= [];

				// Filter out objects which are not downloadable
				{
					if (!isNil { _x getVariable VAR_DOWNLOAD_SIDE } && { _x getVariable VAR_DOWNLOAD_SIDE == side group player }) then
					{
						private ["_objective", "_downloadDistance"];
						_objective		= _x getVariable ["BIS_hvt_objectObjective", objNull];
						_downloadDistance 	= ["GetDownloadRadius", [_objective]] call BIS_fnc_moduleHvtObjective;

						if (!isNull _objective && { player distance _x < _downloadDistance }) then
						{
							_downloadableObjects pushBack _x;
						};
					};
				} forEach _nearObjects;

				// Order the downloadable objects from the nearest to the farthest
				private "_orderedObjects";
				_orderedObjects = [_downloadableObjects, [player], { _input0 distance _x }, "ASCEND"] call BIS_fnc_sortBy;

				private ["_lastPlayerRespawnTime", "_timePassedSinceRespawn"];
				_lastPlayerRespawnTime 	= player getVariable ["BIS_hvt_playerRespawnTime", -1];
				_timePassedSinceRespawn	= time - _lastPlayerRespawnTime;

				// Did we actually found any objects
				if (count _orderedObjects > 0 && !(uiNamespace getVariable ["BIS_hvtPhase_changing", false]) && _timePassedSinceRespawn > 10) then
				{
					private ["_object", "_objective", "_downloadDistance"];
					_object 		= _orderedObjects select 0;
					_objective		= _object getVariable ["BIS_hvt_objectObjective", objNull];
					_downloadDistance 	= ["GetDownloadRadius", [_objective]] call BIS_fnc_moduleHvtObjective;

					// Set the current download object being downloaded by side
					missionNamespace setVariable [VAR_DOWNLOAD_OBJECT, _object];

					// Show ui
					["Show", []] call SELF;

					// Wait while valid
					waitUntil
					{
						if (isNil { player getVariable VAR_DOWNLOAD_TIME_LOSING_CONNECTION } && player distance _object > _downloadDistance && player distance _object < _downloadDistance + 5) then
						{
							player setVariable [VAR_DOWNLOAD_TIME_LOSING_CONNECTION, time];
						};

						if (!isNil { player getVariable VAR_DOWNLOAD_TIME_LOSING_CONNECTION } && player distance _object <= _downloadDistance) then
						{
							player setVariable [VAR_DOWNLOAD_TIME_LOSING_CONNECTION, nil];
						};

						private ["_losingConnection", "_losingConnectionFor", "_losingConnectionTimedOut"];
						_losingConnection 		= !isNil { player getVariable VAR_DOWNLOAD_TIME_LOSING_CONNECTION };
						_losingConnectionFor		= if (_losingConnection) then { time - (player getVariable [VAR_DOWNLOAD_TIME_LOSING_CONNECTION, 0]); } else { 0; };
						_losingConnectionTimedOut	= _losingConnectionFor >= 5;

						//hintSilent format ["Losing Con: %1\nLosing Con For: %2\nCon Timed Out: %3", _losingConnection, _losingConnectionFor, _losingConnectionTimedOut];

						_losingConnectionTimedOut ||
						!alive player ||
						vehicle player != player ||
						player getVariable ["BIS_revive_incapacitated", false] ||
						player distance _object > _downloadDistance + 5 ||
						_object getVariable [VAR_DOWNLOAD_SIDE, sideUnknown] != side group player
					};

					// Reset the current download object
					missionNamespace setVariable [VAR_DOWNLOAD_OBJECT, nil];

					// Reset variable for losing connection
					player setVariable [VAR_DOWNLOAD_TIME_LOSING_CONNECTION, nil];

					// Hide ui
					["Hide", []] call SELF;
				};
			};

			sleep 1.0;
		};
	};

	case "UpdateUi" :
	{
		scriptName "DownloadProgress: UpdateUi";
		disableSerialization;

		private ["_object", "_maxDistance", "_isUpload"];
		_object		= _params param [0, missionNamespace getVariable [VAR_DOWNLOAD_OBJECT, objNull], [objNull]];
		_maxDistance 	= _params param [1, 10, [0]];
		_isUpload 	= _params param [2, ["HasEndGameStarted"] call BIS_fnc_moduleHvtObjectivesInstance, [false]];

		private ["_objective", "_downloadDistance"];
		_objective		= _object getVariable ["BIS_hvt_objectObjective", objNull];
		_downloadDistance 	= ["GetDownloadRadius", [_objective]] call BIS_fnc_moduleHvtObjective;

		while
		{
			alive player &&
			vehicle player == player &&
			!(player getVariable ["BIS_revive_incapacitated", false]) &&
			player distance _object <= _downloadDistance + 5 &&
			side group player == (_object getVariable [VAR_DOWNLOAD_SIDE, sideUnknown]) &&
			uiNamespace getVariable ["BIS_download_uiShown", false]
		}
		do
		{
			private ["_side", "_progress", "_speed", "_paused"];
			_side		= _object getVariable [VAR_DOWNLOAD_SIDE, sideUnknown];
			_progress 	= _object getVariable [VAR_DOWNLOAD_PROGRESS, 0.0];
			_speed		= _object getVariable [VAR_DOWNLOAD_SPEED, 0.0];
			_paused		= _speed == 0.0;

			private ["_distance", "_rangeStep", "_range"];
			_distance	= _object distance player;
			_rangeStep	= _downloadDistance / 4;
			_range		= floor (_downloadDistance / _distance);

			private ["_nearEntities", "_nearPlayers"];
			_nearEntities 	= _object nearEntities ["Man", _downloadDistance];
			_nearPlayers 	= [];

			{
				if (isPlayer _x && vehicle _x == _x && side group _x == _side && !(_x getVariable ["BIS_revive_incapacitated", false])) then
				{
					_nearPlayers pushBack _x;
				};
			} forEach _nearEntities;

			if (_paused || (_object distance player > _downloadDistance && _object distance player < _downloadDistance + 5)) then
			{
				["SetTitle", [localize "STR_A3_EndGame_Download_Paused"]] call PHASE;
				["SetProgressText", [0, true]] call PHASE;
				["SetProgressColor", [1]] call PHASE;
				["SetMultiplier", ["-"]] call PHASE;
				["SetRange", [0]] call PHASE;
			}
			else
			{
				private "_titleText";
				_titleText = if (_isUpload) then { localize "STR_A3_EndGame_Download_Uploading" } else { localize "STR_A3_EndGame_Download_Downloading" };

				["SetProgressColor", [0]] call PHASE;
				["SetTitle", [_titleText]] call PHASE;
				["SetProgress", [_progress]] call PHASE;
				["SetMultiplier", [count _nearPlayers]] call PHASE;
				["SetRange", [_range]] call PHASE;
			};

			sleep 0.2;
		};
	};

	case "Show" :
	{
		uiNamespace setVariable [VAR_DOWNLOAD_SHOWN, true];
		["ShowDownloadProgress", []] call PHASE;

		missionNamespace setVariable [VAR_DOWNLOAD_THREAD_UI, ["UpdateUi", [nil, nil, nil]] spawn SELF];
	};

	case "Hide" :
	{
		terminate (missionNamespace getVariable VAR_DOWNLOAD_THREAD_UI);
		missionNamespace setVariable [VAR_DOWNLOAD_THREAD_UI, nil];

		uiNamespace setVariable [VAR_DOWNLOAD_SHOWN, false];
		["HideDownloadProgress", []] call PHASE;
	};

	case "UnlockAchievement" :
	{
		private "_carrierTimes";
		_carrierTimes = (profileNamespace getVariable ["BIS_hvt_achievement_MarkHacker", 0])  + 1;
		profileNamespace setVariable ["BIS_hvt_achievement_MarkHacker", _carrierTimes];
		saveProfileNamespace;

		// Only if player did it for at least 5 times
		if (_carrierTimes >= 5) then
		{
			if (getStatValue "MarkHacker" == 0) then
			{
				setStatValue ["MarkHacker", 1];
			};
		};
	};

	case default
	{
		["Unknown mode: %1", _mode] call BIS_fnc_error;
	};
};