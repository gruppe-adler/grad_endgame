scriptName "[EndGame] PostPreload.sqf: Thread";

private ["_player", "_didJip", "_joinTime"];
_player 	= _this select 0;
_didJip 	= _this select 1;
_joinTime 	= _this select 2;

// Enable sound and show scene
5 fadeSound 1;
5 fadeMusic 0.3;
5 fadeRadio 1;
enableRadio true;
enableSentences true;
enableEnvironment true;
cutText ["", "BLACK IN", 5];
showHud false;
showCommandingMenu "";

// The warmup index, used to select proper, unique animation
private _warmupIndex = player getVariable ["BIS_warmpupIndex", 1];

// Play warmup animation
player switchMove format ["Acts_AidlPercMstpSlowWrflDnon_warmup_%1", _warmupIndex];
player playMove format ["Acts_AidlPercMstpSlowWrflDnon_warmup_%1", _warmupIndex];

// Rules
private ["_side", "_fob"];
_side 	= side group _player;
_fob	= ["GetBaseOfSide", [_side]] call BIS_fnc_moduleHvtObjectivesInstance;

// Initialize rules intro
[_fob, 50, 75, 0, 0] call bis_fnc_moduleMPTypeHvt_rules;

waitUntil { !(missionNamespace getVariable ["BIS_rules_playing", true]) };

// Jip respawn
if (_didJip && _joinTime > 60) then
{
	private "_body";
	_body = _player;

	_body setVariable ["BIS_revive_disableRevive", true, true];
	_body enableSimulation false;
	_body enableSimulationGlobal false;
	_body hideObject true;
	_body hideObjectGlobal true;
	forceRespawn _body;
	deleteVehicle _body;

	sleep 1;
	setPlayerRespawnTime 1;
}
else
{
	// RscHvtStage
	private ["_stage", "_index"];
	_stage = ["GetStage"] call BIS_fnc_moduleHvtObjectivesInstance;
	_index = if (side group _player == west) then { 0 } else { 1 };

	("RscHvtPhase" call BIS_fnc_rscLayer) cutRsc ["RscHvtPhase", "PLAIN"];

	(_stage select _index) spawn
	{
		scriptName "initPlayerLocal.sqf RscHvtPhase";
		disableSerialization;
		sleep 3;

		if (_this >= 0) then
		{
			["SetStage", [_this]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
		};
	};
};

// Dynamic Groups hint
[["Multiplayer","DynamicGroups"],nil,nil,nil,nil,nil,nil,true] call BIS_fnc_advHint;

// Handle players stuck at start
if (isMultiplayer && isNil { BIS_playersHaveControl }) then
{
	private ["_instance", "_timeToWait"];
	_instance	= ["GetLogic"] call BIS_fnc_moduleHvtObjectivesInstance;
	_timeToWait 	= _instance getVariable ["WarmupDelay", 45];

	// Add respawn event handler
	// In case a player forces respawn during countdown we need to force animation upon this event
	// Otherwise he would be able to move while the countdown is active
	private _respawnEH = player addEventHandler ["Respawn",
	{
		private _warmupIndex = player getVariable ["BIS_warmpupIndex", 1];

		// Play warmup animation
		player switchMove format ["Acts_AidlPercMstpSlowWrflDnon_warmup_%1", _warmupIndex];
		player playMove format ["Acts_AidlPercMstpSlowWrflDnon_warmup_%1", _warmupIndex];
	}];

	// Block throwing grenades
	[] spawn
	{
		disableSerialization;
		scriptName "initPlayerLocal.sqf: Players stuck at start";
		waitUntil { !isNull (findDisplay 46) };
		BIS_lockThrow = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) in actionKeys 'Throw') then { true } else { false };"];
	};

	missionnamespace setVariable ["RscRespawnCounter_Custom", _timeToWait];
	[] spawn
	{
		disableSerialization;
		scriptName "RscRespawnCounter initPlayerLocal.sqf";

		sleep 1;
		("RscRespawnCounter" call BIS_fnc_rscLayer) cutRsc ["RscRespawnCounter", "Plain", 1, true];
	};

	// Wait for server flag
	waitUntil
	{
		sleep 0.5;

		missionnamespace setVariable ["RscRespawnCounter_Custom", _timeToWait - time];

		// Condition
		(!isNil { BIS_playersHaveControl } || !isNil { BIS_skipWarmup });
	};

	("RscRespawnCounter" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	missionnamespace setVariable ["RscRespawnCounter_Custom", -1];
	[] spawn
	{
		disableSerialization;
		scriptName "postPreload.sqf: Safe respawn counter removal";
		sleep 10;
		("RscRespawnCounter" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	// Show notification
	private _taskReal	= currentTask player;

	if (!isNull _taskReal) then
	{
		private _customData 	= player getVariable ["bis_fnc_setTaskLocal_customData",[]];
		private _i		= _customData find _taskReal;

		if (_i >= 0) then
		{
			private _data = _customData select (_i + 1);

			if (typeName _data == typeName [] && {count _data >= 2}) then
			{
				["TaskAssignedIcon", [_data select 1, (taskDescription _taskReal) select 1]] call bis_fnc_showNotification;
			};
		};
	};

	// Un-block grenade throwing
	if (!isNil { BIS_lockThrow }) then
	{
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", BIS_lockThrow];
	};

	// Remove respawn event handler
	player removeEventHandler ["Respawn", _respawnEH];
};

// Select correct out animation depending on the current weapon of the player
private _animOut = switch (true) do
{
	case (currentWeapon player == primaryWeapon player) : 	{"Acts_AidlPercMstpSlowWrflDnon_warmup_%1_out"};
	case (currentWeapon player == secondaryWeapon player) : {"Acts_AidlPercMstpSlowWpstDnon_warmup_%1_out"};
	default 						{"Acts_AidlPercMstpSnonWnonDnon_warmup_%1_out"};
};

// Unstuck player
player selectWeapon primaryWeapon player;
player playMove format [_animOut, _warmupIndex];

// Show the HUD
showHud true;

// Flag as completed
BIS_postPreload_completed = true;