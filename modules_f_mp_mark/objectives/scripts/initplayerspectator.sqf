// Script name
scriptName "initPlayerSpectator.sqf";

// Do not serialize this script
disableSerialization;

// Briefing
#include "briefing.sqf"

// Common spectator defines
#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

waitUntil
{
	!isNil { missionNamespace getVariable "BIS_fnc_EGSpectator" }
	&&
	!isNil { missionNamespace getVariable "BIS_fnc_moduleHvtObjectivesInstance" }
	&&
	!isNil { missionNamespace getVariable "BIS_fnc_moduleHvtObjective" }
	&&
	!isNil { missionNamespace getVariable "bis_fnc_moduleMPTypeHvt_carrier" }
	&&
	!isNil { missionNamespace getVariable "BIS_fnc_EGObjectiveVisualizer" }
	&&
	!isNil { missionNamespace getVariable "bis_fnc_moduleMPTypeHvt_downloadObject" }
};

sleep 5;

// Initialize EG Objective Visualizer
["Initialize"] call OBJECTIVE_VIZUALIZER;

// The current stage spectator thinks it is in currently
BIS_endGameSpectator_currentStage = -1;

waitUntil { !isNull (["GetDisplay"] call DISPLAY) };

// Show head to head visualization
["SetHeadToHeadVisibility", [true]] call DISPLAY;

// The current end game stage
private ["_stage", "_stageWest", "_stageEast"];
_stage = ["GetStageMain"] call INSTANCE;
_stageWest = ["GetStageSide", [WEST]] call INSTANCE;
_stageEast = ["GetStageSide", [EAST]] call INSTANCE;

// Initial stage
if (_stage > -1) then
{
	[_stage] call BIS_fnc_endGameSpectator_onStageChanged;

	[_stageWest, WEST] call BIS_fnc_endGameSpectator_onSideStageChanged;
	[_stageEast, EAST] call BIS_fnc_endGameSpectator_onSideStageChanged;

	if (!isNil { BIS_hvt_pickupInfo }) then
	{
		BIS_hvt_pickupInfo call BIS_fnc_endGameSpectator_onCarrierPickupInfoChanged;
	};

	if (!isNil { missionNamespace getVariable "BIS_upload_side" }) then
	{
		(missionNamespace getVariable "BIS_upload_side") call BIS_fnc_endGameSpectator_onUploadStateChanged;
	};
}
else
{
	["SetGamePhase", [localize "STR_A3_Spectator_Warmup"]] call DISPLAY;

	["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Waiting"]] call DISPLAY;
	["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Waiting"]] call DISPLAY;
};

// Events for stage changes
[missionNamespace, "EndGame_OnStageChanged",
{
	private ["_stage", "_side"];
	_stage = _this param [0, -1, [-1]];
	_side = _this param [1, sideUnknown, [sideUnknown]];

	if (_stage > -1) then
	{
		[_stage] call BIS_fnc_endGameSpectator_onStageChanged;
		[_stage, _side] call BIS_fnc_endGameSpectator_onSideStageChanged;
	};
}] call BIS_fnc_addScriptedEventHandler;

// Event for End Game mission ended
[missionNamespace, "EndGame_Ended",
{
	private ["_winner", "_loser", "_isDraw"];
	_winner = _this param [0, sideUnknown, [sideUnknown]];
	_loser = _this param [1, sideUnknown, [sideUnknown]];
	_isDraw = _this param [2, false, [false]];

	["SetHeadToHeadVisibility", [false]] call DISPLAY;
	["Terminate"] call OBJECTIVE_VIZUALIZER;
}] call BIS_fnc_addScriptedEventHandler;

// Event for Download / Upload completed
[missionNamespace, "EndGame_OnDownloadCompleted",
{
	_this call BIS_fnc_endGameSpectator_updateSideIntelTask;
}] call BIS_fnc_addScriptedEventHandler;

// Download object
[] spawn bis_fnc_moduleMPTypeHvt_downloadObject;

// FOB's
private ["_fobs"];
_fobs = ["GetBases"] call INSTANCE;

{
	private ["_base", "_side"];
	_base = _x;
	_side = _base getVariable ["BIS_moduleHvtObjectivesInstance_baseSide", sideUnknown];

	if (_side != sideUnknown) then
	{
		private ["_id", "_center", "_dirTo", "_dirFrom", "_loc", "_dir"];
		_id = format ["FOB_%1", _side];
		_center = getPosASL _base;
		_dirTo = vectorDir _base;
		_dirFrom = _dirTo vectorMultiply -1;
		_loc = _center vectorAdd (_dirFrom vectorMultiply 50);
		_loc set [2, (_loc select 2) + 10.0];
		_dir = [_loc, _center] call BIS_fnc_dirTo;

		["AddLocation", [_id, str _side, "", ICON_BASE, [_loc, [0,0,0], [0,0,0], [_dir, true]]]] call BIS_fnc_EGSpectator;

		private ["_colorBackground", "_params", "_conditionShow"];
		_colorBackground 	= [_side] call BIS_fnc_sideColor; _colorBackground set [3, FADE_BACKGROUND];
		_params			= [ICON_BASE, [1, 1, 1, FADE_ICON], [0,0,0], 1.0, 1.0, 0, "", 1, 0.05, "PuristaMedium"];
		_conditionShow		= { true };

		// Add icon
		["AddCustomIcon", [_id, _base, _params, [true, _colorBackground], _conditionShow]] call SPEC;
	};
} forEach _fobs;

// Pickup info changed
[missionNamespace, "onPickupInfoChanged",
{
	_this call BIS_fnc_endGameSpectator_onCarrierPickupInfoChanged;
}] call BIS_fnc_addScriptedEventHandler;

// Upload start / end
[missionNamespace, "onUploadStateChanged",
{
	_this call BIS_fnc_endGameSpectator_onUploadStateChanged;
}] call BIS_fnc_addScriptedEventHandler;

// Do not draw locations in 3D
missionNamespace setvariable [VAR_DRAW_3D_LOCATIONS, false];

// Log
["initPlayerSpectator.sqf: Finished at %1", time] call BIS_fnc_logFormat;