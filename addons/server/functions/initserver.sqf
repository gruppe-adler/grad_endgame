// Dynamic Groups
["Initialize"] call BIS_fnc_dynamicGroups;

// Calculate initial respawn delay
private "_respawnDelay";
_respawnDelay = 30;

if (!isNil { BIS_initialRespawnDelay }) then
{
	_respawnDelay = BIS_initialRespawnDelay;
};

// Set respawn delay
missionNamespace setVariable ["BIS_selectRespawnTemplate_delay", _respawnDelay];
publicVariable "BIS_selectRespawnTemplate_delay";

// Group leader respawn
BIS_west_respawnPosition = [WEST, grpNull] call BIS_fnc_addRespawnPosition;
BIS_east_respawnPosition = [EAST, grpNull] call BIS_fnc_addRespawnPosition;

// Initial conversation
[] spawn
{
	scriptName "initServer.sqf: Initial conversation delay";

	waitUntil { time >= 5 };

	["Wait", WEST] call bis_fnc_moduleMPTypeHvt_conversations;
	["Wait", EAST] call bis_fnc_moduleMPTypeHvt_conversations;
};

// Handle players stuck at the start
if (isMultiplayer) then
{
	[] spawn
	{
		scriptName "Players stuck at start - Server";

		private ["_instance", "_timeToWait"];
		_instance	= ["GetLogic"] call BIS_fnc_moduleHvtObjectivesInstance;
		_timeToWait 	= _instance getVariable ["WarmupDelay", 45];

		waitUntil { time >= _timeToWait || !isNil { BIS_skipWarmup } };

		BIS_playersHaveControl = true;
		publicVariable "BIS_playersHaveControl";

		["SetStage", [0, west]] call BIS_fnc_moduleHvtObjectivesInstance;
		["SetStage", [0, east]] call BIS_fnc_moduleHvtObjectivesInstance;
		["Start", WEST] call bis_fnc_moduleMPTypeHvt_conversations;
		["Start", EAST] call bis_fnc_moduleMPTypeHvt_conversations;
	};
}
else
{
	["SetStage", [0, west]] call BIS_fnc_moduleHvtObjectivesInstance;
	["SetStage", [0, east]] call BIS_fnc_moduleHvtObjectivesInstance;
};