#include "briefing.sqf"

// Disable sound and hide scene
0 fadeSound 0;
0 fadeMusic 0;
0 fadeRadio 0;
enableRadio false;
enableSentences false;
enableEnvironment false;
cutText ["", "BLACK FADED", 99];
showHud false;
showCommandingMenu "";

// Post preload
if (isMultiplayer) then
{
	onPreloadFinished
	{
		onPreloadFinished {};
		[player, didJIP, time] spawn compile preprocessFileLineNumbers "\a3\Modules_F_MP_Mark\Objectives\scripts\postPreload.sqf";
	};
}
else
{
	// In single player, we need to re enable widget on mission loaded
	addMissionEventHandler ["Loaded",
	{
		private ["_stage", "_index"];
		_stage = ["GetStageSide", [side group player]] call BIS_fnc_moduleHvtObjectivesInstance;
		_index = if (side group player == west) then { 0 } else { 1 };

		("RscHvtPhase" call BIS_fnc_rscLayer) cutRsc ["RscHvtPhase", "PLAIN"];

		if (_stage >= 0) then
		{
			["SetStage", [_stage]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
		};

		"Mission loaded and RscHvtPhase was re-initialized" call BIS_fnc_log;
	}];

	waitUntil { !isNil { bis_fnc_moduleMPTypeHvt_postPreload } };
	[player, didJIP, time] spawn bis_fnc_moduleMPTypeHvt_postPreload;
};

// Make sure functions already exist
waitUntil
{
	!isNil { bis_fnc_moduleMPTypeHvt_areaManager } &&
	!isNil { bis_fnc_moduleMPTypeHvt_carrier } &&
	!isNil { bis_fnc_moduleMPTypeHvt_carrier_canPickup } &&
	!isNil { bis_fnc_moduleMPTypeHvt_carrier_canUpload } &&
	!isNil { bis_fnc_moduleMPTypeHvt_downloadObject } &&
	!isNil { bis_fnc_moduleMPTypeHvt_rules } &&
	!isNil { bis_fnc_moduleMPTypeHvt_postPreload }
};

// Dynamic Groups
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

// Area Manager
["ClientLoop"] call bis_fnc_moduleMPTypeHvt_areaManager;

// Download object
[] spawn bis_fnc_moduleMPTypeHvt_downloadObject;

// Download progress
["Initialize", []] spawn bis_fnc_moduleMPTypeHvt_downloadProgress;

// Add pickup action
["AddPickupAction"] call bis_fnc_moduleMPTypeHvt_carrier;

// Do not allow player to leave FOB area unless they already completed the FOB objective
if !(side group player in (missionNamespace getVariable ["BIS_moduleHvtObjectivesInstance_sidesWithFob", []])) then
{
	[] spawn
	{
		scriptName "initPlayerLocal.sqf: Fob area limiter";

		private ["_base", "_restrictionRadius"];
		_base 			= ["GetBaseOfSide", [side group player]] call BIS_fnc_moduleHvtObjectivesInstance;
		_restrictionRadius	= _base getVariable ["RestrictionRadius", 500];

		while { !(side group player in (missionNamespace getVariable ["BIS_moduleHvtObjectivesInstance_sidesWithFob", []])) } do
		{
			if (player distance _base > _restrictionRadius) then
			{
				player setDamage 1;
			};

			sleep 1;
		};
	};
};

// On killed
player addEventHandler ["Killed",
{
	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];

	[] spawn
	{
		scriptName "initPlayerLocal: Respawn";
		disableSerialization;
		sleep 4;

		private ["_stage", "_index"];
		_stage = ["GetStageSide", [side group player]] call BIS_fnc_moduleHvtObjectivesInstance;
		_index = if (side group player == west) then { 0 } else { 1 };

		("RscHvtPhase" call BIS_fnc_rscLayer) cutRsc ["RscHvtPhase", "PLAIN"];

		if (_stage >= 0) then
		{
			["SetStage", [_stage]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
		};

		"Player killed and RscHvtPhase was re-initialized" call BIS_fnc_log;
	};

	if (isNil {BIS_playersHaveControl}) then
	{
		private _instance	= ["GetLogic"] call BIS_fnc_moduleHvtObjectivesInstance;
		private _timeToWait = _instance getVariable ["WarmupDelay", 45];
		private _timeLeft	= (_timeToWait - time) max 0;

		setPlayerRespawnTime _timeLeft;
	};
}];

// On respawn
player addEventHandler ["Respawn",
{
	private ["_player", "_body"];
	_player	= _this select 0;
	_body	= _this select 1;

	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];

	[] spawn
	{
		scriptName "initPlayerLocal: Respawn";
		disableSerialization;
		sleep 3;

		private ["_stage", "_index"];
		_stage = ["GetStageSide", [side group player]] call BIS_fnc_moduleHvtObjectivesInstance;
		_index = if (side group player == west) then { 0 } else { 1 };

		("RscHvtPhase" call BIS_fnc_rscLayer) cutRsc ["RscHvtPhase", "PLAIN"];

		if (_stage >= 0) then
		{
			["SetStage", [_stage]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
		};

		"Player respawned and RscHvtPhase was re-initialized" call BIS_fnc_log;
	};

	// Add pickup action
	["AddPickupAction"] call bis_fnc_moduleMPTypeHvt_carrier;

	// Reset revive variable
	_player setVariable ["BIS_revive_disableRevive", false, true];

	// Player respawn time
	_player setVariable ["BIS_hvt_playerRespawnTime", time];

	// Delete old body
	deleteVehicle _body;
}];