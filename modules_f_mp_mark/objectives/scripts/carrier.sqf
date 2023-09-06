#define SELF 				{ _this call (missionNamespace getVariable ["bis_fnc_moduleMPTypeHvt_carrier", {}]) }
#define INSTANCE			{ _this call (missionNamespace getVariable ["BIS_fnc_moduleHvtObjectivesInstance", {}]) }
#define OBJECTIVE			{ _this call (missionNamespace getVariable ["BIS_fnc_moduleHvtObjective", {}]) }
#define PHASE 				{ _this call (uiNamespace getVariable ["RscHvtPhase_script", {}]) }
#define PICKUP_CONDITION		"[_target, _this] call bis_fnc_moduleMPTypeHvt_carrier_canPickup;"
#define UPLOAD_CONDITION		"[_target, _this] call bis_fnc_moduleMPTypeHvt_carrier_canUpload;"
#define STATES				["NeedsPickup", "OnCarrier", "Uploading", "Uploaded"]
#define ACTION_PICKUP			localize "STR_A3_EndGame_Misc_Pickup"
#define ACTION_UPLOAD			localize "STR_A3_EndGame_Misc_Upload"
#define TEXT_CARRIER			localize "STR_A3_EndGame_Misc_Carrier"
#define VISIBILITY_INTERVAL		1.0
#define LINE_TRACE_DISTANCE		50
#define PICKUP_UPLOAD_DISTANCE		3.5
#define PICKUP_VISIBILITY_INTERVAL	0.5
#define VAR_PICKUP			"BIS_hvt_pickup"
#define VAR_EVER_PICKED			"BIS_hvt_wasEverPicked"
#define VAR_VISIBLE			"BIS_hvt_pickupVisible"
#define VAR_MP_KILLED			"BIS_hvt_mpKilled"
#define VAR_VISIBILITY_TIME		"BIS_hvt_visibilityTime"
#define VAR_CARRIER_VISIBLE		"BIS_hvt_carrierVisible"
#define VAR_PICKUP_ID			"BIS_hvt_pickupId"
#define VAR_LAST_CARRIER_NAME		"BIS_hvt_lastCarrierName"
#define VAR_HAS_PICKUP_LOS		"BIS_hvt_hasPickupLOS"
#define VAR_PICKUP_LOS_CHECK_TIME	"BIS_hvt_pickupLOSCheckTime"

private ["_mode", "_params"];
_mode 	= _this param [0, "", [""]];
_params	= _this param [1, [], [[]]];

switch (_mode) do {

	case "Initialize" :
	{
		if (!isServer || !isNil { BIS_hvt_pickupInfo }) exitWith {};

		private ["_pickup", "_upload", "_lockedTo", "_lockedFrom"];
		_pickup 	= _params param [0, objNull, [objNull]];
		_uploads	= _params param [1, [], [[]]];
		_lockedTo	= _params param [2, sideUnknown, [sideUnknown]];
		_lockedFrom	= _params param [3, sideUnknown, [sideUnknown]];

		_pickup setVariable [VAR_PICKUP_ID, true, true];

		private "_pickupInfo";
		_pickupInfo =
		[
			_pickup,				// The pickup object
			[objNull, "", sideUnknown],		// The player object, player name and player side
			"NeedsPickup",				// Current state
			_lockedTo,				// The side to which pickup is locked to
			_uploads				// The upload objects
		];

		["SetPickupInfo", _pickupInfo] call SELF;

		// Object starts visible
		["SetVisibility", [true]] call SELF;

		// Handle destruction of pickup/schematics
		_pickup addEventHandler ["Killed",
		{
			["OnSchematicsDestroyed", _this] call SELF;
		}];

		// Handle player deaths, so carrier can drop schematics
		addMissionEventHandler ["EntityKilled",
		{
			params [["_dead", objNull, [objNull]], ["_killer", objNull, [objNull]]];

			// Make sure dead is the carrier
			if (["IsCarrier", [_dead]] call SELF) then
			{
				// Drop the schematics
				["Drop", [_dead, getPosASL _dead, getDir _dead, velocity _dead]] call SELF;

				// Log
				["Carrier (%1) Killed by %2", name _dead, name _killer] call BIS_fnc_logFormat;
			};
		}];

		// Log
		["Initialize: %1 / %2 / %3 / %4", _pickup, _uploads, _lockedTo, _pickupInfo] call BIS_fnc_logFormat;
	};

	case "InitializeClient" :
	{
		if (!hasInterface || !isNil { BIS_hvt_pickupDraw }) exitWith {};

		waitUntil { !isNull ((findDisplay 12) displayCtrl 51) };

		BIS_hvt_pickupDraw = addMissionEventHandler ["Draw3D", { [controlnull] call bis_fnc_moduleMPTypeHvt_carrier_draw; }];
		BIS_hvt_pickupDraw2D = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", { [_this select 0] call bis_fnc_moduleMPTypeHvt_carrier_draw; }];
		BIS_hvt_carrierThread = ["Thread"] spawn SELF;

		// Log
		["InitializeClient: %1 / %2 / %3", BIS_hvt_pickupDraw, BIS_hvt_pickupDraw2D, BIS_hvt_carrierThread] call BIS_fnc_logFormat;
	};

	case "AddPickupAction" :
	{
		player addAction [ACTION_PICKUP, { ["ServerExecute", ["Pickup", [_this select 0, _this select 1]]] call SELF; }, [], 10, true, true, "", PICKUP_CONDITION];
	};

	case "GetLastCarrierName" :
	{
		missionNamespace getVariable [VAR_LAST_CARRIER_NAME, ""];
	};

	case "SetLastCarrierName" :
	{
		private ["_name"];
		_name = _params param [0, "", [""]];

		missionNamespace setVariable [VAR_LAST_CARRIER_NAME, _name];
		publicVariable VAR_LAST_CARRIER_NAME;
	};

	case "Thread" :
	{
		disableSerialization;

		while { true } do
		{
			if (player == ["GetCarrier"] call SELF) then
			{
				if (player getVariable [VAR_CARRIER_VISIBLE, false]) then
				{
					if !(["IsCarrierIconVisible"] call PHASE) then
					{
						["ShowCarrierIcon", [true]] call PHASE;
					};
				}
				else
				{
					if (["IsCarrierIconVisible"] call PHASE) then
					{
						["ShowCarrierIcon", [false]] call PHASE;
					};
				};
			}
			else
			{
				if (["IsCarrierIconVisible"] call PHASE) then
				{
					["ShowCarrierIcon", [false]] call PHASE;
				};
			};

			sleep 1.0;
		};
	};

	case "ShouldDrawCarrier" :
	{
		private "_carrier";
		_carrier = _params select 0;

		private ["_lastCheckTime", "_sameSide", "_isSpectator", "_isVisible", "_isPlayer"];
		_lastCheckTime 	= _carrier getVariable [VAR_VISIBILITY_TIME, 0];
		_sameSide	= side group player == side group _carrier;
		_isSpectator	= typeOf player == "VirtualSpectator_F";
		_isVisible 	= _carrier getVariable [VAR_CARRIER_VISIBLE, true];
		_isPlayer	= _carrier == player;

		if (time >= _lastCheckTime + VISIBILITY_INTERVAL) then
		{
			_carrier setVariable [VAR_VISIBILITY_TIME, time];
			_isVisible = ["DoCarrierLineTrace", [_carrier]] call SELF;
		};

		_carrier setVariable [VAR_CARRIER_VISIBLE, _isVisible];

		!_isPlayer && {(_sameSide || {_isVisible} || {_isSpectator})};
	};

	case "DoCarrierLineTrace" :
	{
		private _carrier = _params select 0;

		if (!isNull _carrier) then
		{
			private _vehicle 		= vehicle _carrier;
			private _positionStart	= if (_vehicle == _carrier) then { eyePos _carrier } else { [getPosASLVisual _vehicle select 0, getPosASLVisual _vehicle select 1, (getPosASLVisual _vehicle select 2) + 2.0] };
			private _positionEnd 	= [_positionStart select 0, _positionStart select 1, (_positionStart select 2) + LINE_TRACE_DISTANCE];
			private _collided 		= lineIntersects [_positionStart, _positionEnd, _carrier, _vehicle];

			!_collided;
		}
		else
		{
			false;
		};
	};

	case "OnSchematicsDestroyed" :
	{
		if (!isServer) exitWith {};

		private ["_schematics", "_killer"];
		_schematics 	= _params param [0, objNull, [objNull]];
		_killer		= _params param [1, objNull, [objNull]];

		private ["_looser", "_winner"];
		_looser = side group _killer;
		_winner = ["GetOppositeSide", [_looser]] call INSTANCE;

		["EndMissionSchematics", [_winner, _looser]] call INSTANCE;
	};

	case "Pickup" :
	{
		if (!isServer) exitWith {};

		private ["_obj", "_carrier"];
		_obj 		= _params param [0, objNull, [objNull]];
		_carrier 	= _params param [1, objNull, [objNull]];

		// Make sure we don't have a carrier already
		if (!isNull _obj && { !isNull _carrier } && { alive _carrier } && { isNull (["GetCarrier"] call SELF) }) then
		{
			private ["_pickup", "_side", "_oppositeSide"];
			_pickup 	= ["GetPickupObject"] call SELF;
			_side 		= side group _carrier;
			_oppositeSide	= ["GetOppositeSide", [_side]] call INSTANCE;

			if !(["WasEverPicked", [_pickup]] call SELF) then
			{
				_pickup setVariable [VAR_EVER_PICKED, true, true];
			};

			["SetVisibility", [false]] call SELF;

			private "_pickupInfo";
			_pickupInfo = ["GetPickupInfo"] call SELF;
			_pickupInfo set [1, [_carrier, name _carrier, _side]];
			_pickupInfo set [2, "OnCarrier"];
			_pickupInfo set [3, sideUnknown];

			// Store new pickup info
			["SetPickupInfo", _pickupInfo] call SELF;

			// If the enemy is currently uploading, we abort it here
			private _upload = ["GetUploadObject", [_oppositeSide]] call SELF;

			if (_upload getVariable ["BIS_download_side", sideUnknown] != sideUnknown) then
			{
				_upload setVariable ["BIS_download_aborted", true];
			};

			["SetLastCarrierName", [name _carrier]] call SELF;

			BIS_carrierRespawnPosition = [side group _carrier, _carrier, toUpper TEXT_CARRIER] call bis_fnc_addRespawnPosition;

			[["OnPickup", [_carrier]], "bis_fnc_moduleMPTypeHvt_carrier", true, false] call BIS_fnc_mp;
		};
	};

	case "Drop" :
	{
		if (!isServer) exitWith {};

		private ["_carrier", "_location", "_direction", "_velocity"];
		_carrier	= _params param [0, objNull, [objNull]];
		_location 	= _params param [1, [0,0,0], [[]]];
		_direction 	= _params param [2, 0, [0]];
		_velocity	= _params param [3, [0,0,0], [[]]];

		private "_pickup";
		_pickup = ["GetPickupObject"] call SELF;

		["SetVisibility", [true]] call SELF;
		_pickup setDir _direction;
		_pickup setPosASL _location;
		_pickup setVelocity _velocity;

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo set [1, [objNull, "", sideUnknown]];
		_pickupInfo set [2, "NeedsPickup"];
		_pickupInfo set [3, sideUnknown];

		["SetPickupInfo", _pickupInfo] call SELF;

		if (!isNil { BIS_carrierRespawnPosition }) then
		{
			[side group _carrier, BIS_carrierRespawnPosition select 1] call bis_fnc_removeRespawnPosition;
			BIS_carrierRespawnPosition = nil;
		};

		[["OnDrop", [_carrier]], "bis_fnc_moduleMPTypeHvt_carrier", true, false] call BIS_fnc_mp;

		// Are the schematics outside the AO
		if (!isNil { BIS_carrierArea }) then
		{
			if !([BIS_carrierArea, _pickup] call bis_fnc_inTrigger) then
			{
				private ["_winner", "_looser"];
				_winner = ["GetOppositeSide", [side group _carrier]] call INSTANCE;
				_looser = side group _carrier;

				["EndMissionCarrier", [_winner, _looser]] call INSTANCE;
			};
		};
	};

	case "UploadStart" :
	{
		if (!isServer) exitWith {};

		private ["_carrier"];
		_carrier = _params param [0, objNull, [objNull]];

		if (!isNull _carrier && { alive _carrier }) then
		{
			private ["_side", "_upload", "_endGameObjective", "_downloadRadius"];
			_side			= side group _carrier;
			_upload 		= ["GetUploadObject", [_side]] call SELF;
			_endGameObjective 	= ["GetEndGameObjective"] call INSTANCE;
			_downloadRadius		= ["GetDownloadRadius", [_endGameObjective]] call OBJECTIVE;

			if (!isNull _upload) then
			{
				// Start download sequence
				[objNull, _upload, _carrier, nil, _downloadRadius, false, nil, true] execFSM "a3\Modules_F_MP_Mark\Objectives\fsms\Download.fsm";
			};
		};
	};

	case "UploadEnd" :
	{
		if (!isServer) exitWith {};

		["SetState", ["Uploaded"]] call SELF;
	};

	case "HasPickupLOS" :
	{
		private ["_pickup", "_player"];
		_pickup = _params param [0, objNull, [objNull]];
		_player = _params param [1, objNull, [objNull]];

		if (!isNull _pickup && !isNull _player && getPosASL _pickup distance eyePos _player <= PICKUP_UPLOAD_DISTANCE) then
		{
			private ["_positionStart", "_positionEnd"];
			_positionStart	= eyePos _player;
			_positionEnd 	= getPosASL _pickup;
			_positionEnd set [2, (_positionEnd select 2) + 0.25];

			!lineIntersects [_positionStart, _positionEnd, _player, _pickup];
		}
		else
		{
			false;
		};
	};

	case "WasEverPicked" :
	{
		!isNil { (["GetPickupObject"] call SELF) getVariable VAR_EVER_PICKED };
	};

	case "ServerExecute" :
	{
		private ["_wantedMode", "_wantedParams"];
		_wantedMode	= _params param [0, "", [""]];
		_wantedParams	= _params param [1, [], [[]]];

		[[_wantedMode, _wantedParams], "bis_fnc_moduleMPTypeHvt_carrier", ["GetPickupObject"] call SELF, false, true] call BIS_fnc_mp;
	};

	case "SetVisibility" :
	{
		if (!isServer) exitWith {};

		private ["_visible"];
		_visible = _params param [0, true, [false]];

		private "_pickup";
		_pickup = ["GetPickupObject"] call SELF;

		if (isMultiplayer) then
		{
			_pickup hideObjectGlobal !_visible;
			_pickup enableSimulationGlobal _visible;
		} else {
			_pickup hideObject !_visible;
			_pickup enableSimulation _visible;
		};

		_pickup setVariable [VAR_VISIBLE, _visible, true];
	};

	case "IsVisible" :
	{
		private "_pickup";
		_pickup = ["GetPickupObject"] call SELF;

		_pickup getVariable [VAR_VISIBLE, true];
	};

	case "GetPickupObject" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo select 0;
	};

	case "GetUploadObject" :
	{
		private ["_side"];
		_side = _params param [0, sideUnknown, [sideUnknown]];

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		private "_sideIndex";
		_sideIndex = switch (_side) do
		{
			case WEST : 	{ 0 };
			case EAST : 	{ 1 };
			case DEFAULT 	{ -1 };
		};

		if (_sideIndex == -1) then
		{
			objNull;
		}
		else
		{
			(_pickupInfo select 4) select _sideIndex;
		};
	};

	case "GetUploadObjects" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo select 4;
	};

	case "GetPickupInfo" :
	{
		if (isNil { BIS_hvt_pickupInfo }) then
		{
			["GetPickupInfoTemplate"] call SELF;
		}
		else
		{
			BIS_hvt_pickupInfo;
		};
	};

	case "SetPickupInfo" :
	{
		if (!isServer) exitWith {};

		private ["_pickupObject", "_pickupPlayer", "_pickupState", "_pickupLockedTo", "_uploadObjects"];
		_pickupObject 	= _params param [0, objNull, [objNull]];
		_pickupPlayer 	= _params param [1, [objNull, "", sideUnknown], [[]]];
		_pickupState 	= _params param [2, "NeedsPickup", [""]];
		_pickupLockedTo = _params param [3, sideUnknown, [sideUnknown]];
		_uploadObjects	= _params param [4, [], [[]]];

		BIS_hvt_pickupInfo = [_pickupObject, _pickupPlayer, _pickupState, _pickupLockedTo, _uploadObjects];
		publicVariable "BIS_hvt_pickupInfo";

		[true, "onPickupInfoChanged", BIS_hvt_pickupInfo] remoteExec ["BIS_fnc_callScriptedEventHandler"];
	};

	case "IsLocked" : {
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 3) != sideUnknown;
	};

	case "IsLockedTo" : {
		private ["_side"];
		_side = _params param [0, sideUnknown, [sideUnknown]];

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 3) == _side;
	};

	case "IsLockedFrom" : {
		private ["_side"];
		_side = _params param [0, sideUnknown, [sideUnknown]];

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 3) != _side && (_pickupInfo select 3) != sideUnknown;
	};

	case "Unlock" : {
		if (!isServer) exitWith {};

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo set [3, sideUnknown];

		["SetPickupInfo", _pickupInfo] call SELF;
	};

	case "Lock" : {
		if (!isServer) exitWith {};

		private ["_side"];
		_side = _params param [0, sideUnknown, [sideUnknown]];

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo set [3, _side];

		["SetPickupInfo", _pickupInfo] call SELF;
	};

	case "GetState" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo select 2;
	};

	case "SetState" :
	{
		if (!isServer) exitWith {};

		private ["_newState"];
		_newState = _params param [0, "", [""]];

		if !(_newState in STATES) exitWith
		{
			["Invalid state: %1", _newState] call BIS_fnc_error;
		};

		if (_newState == ["GetState"] call SELF) exitWith
		{
			["Invalid state: Ignored because it would change to the same state"] call BIS_fnc_log;
		};

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_pickupInfo set [2, _newState];

		["SetPickupInfo", _pickupInfo] call SELF;
	};

	case "GetPickupInfoTemplate" :
	{
		[
			objNull,				// The pickup object
			[objNull, "", sideUnknown],		// The player object, player uid and player side
			"NeedsPickup",				// Current state
			sideUnknown,				// The side to which this pickup is locked to
			[]					// The upload objects
		];
	};

	case "IsPickupInfoValid" :
	{
		private ["_pickupInfo"];
		_pickupInfo = _params param [0, [], [[]]];

		if (_pickupInfo isEqualTo []) then
		{
			_pickupInfo = ["GetPickupInfo"] call SELF;
		};

		!isNull (_pickupInfo select 0)
		&&
		count (_pickupInfo select 4) >= 2
	};

	case "GetCarrier" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 1) select 0;
	};

	case "SetCarrier" :
	{
		if (!isServer) exitWith {};

		private ["_player"];
		_player = _params param [0, objNull, [objNull, ""]];

		// Reset carrier
		if (isNull _player) exitWith
		{
			["ResetCarrier", []] call SELF;
		};

		private ["_name", "_side"];
		_name 	= name _player;
		_side 	= side group _player;

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;
		_pickupInfo set [1, [_player, _name, _side]];

		["SetPickupInfo", _pickupInfo] call SELF;
	};

	case "ResetCarrier" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;
		_pickupInfo set [1, [objNull, "", sideUnknown]];

		["SetPickupInfo", _pickupInfo] call SELF;
	};

	case "GetCarrierName" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 1) select 1;
	};

	case "GetCarrierSide" :
	{
		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		(_pickupInfo select 1) select 2;
	};

	case "IsCarrier" :
	{
		private ["_player"];
		_player = _params param [0, objNull, [objNull]];

		private "_pickupInfo";
		_pickupInfo = ["GetPickupInfo"] call SELF;

		_player == (_pickupInfo select 1) select 0;
	};

	case "OnPickup" :
	{
		private ["_carrier"];
		_carrier = _params param [0, objNull, [objNull]];

		["HVT_OnPickup", [["GetCarrierName"] call SELF]] call bis_fnc_shownotification;

		if (local _carrier) then
		{
			if (getStatValue "MarkCarrier" == 0) then
			{
				setStatValue ["MarkCarrier", 1];
				["OnPickup: Achievement unlocked (%1)", "MarkCarrier"] call BIS_fnc_logFormat;
			};
		};
	};

	case "OnDrop" :
	{
		private ["_carrier"];
		_carrier = _params param [0, objNull, [objNull]];

		["HVT_OnDrop", [["GetLastCarrierName"] call SELF]] call bis_fnc_shownotification;
	};

	case default
	{
		["Unknown mode: %1", _mode] call BIS_fnc_logFormat;
	};

};