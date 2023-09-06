#include "script_component.hpp"

private ["_objective", "_side"];
_objective 	= _parameters param [0, objNull, [objNull]];
_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

if (isNull _objective) exitWith
{
	"Reveal: Unable to create a NULL objective" call BIS_fnc_error;
};

if (_side == sideUnknown) exitWith
{
	"Reveal: Reveal to side is sideUnknown" call BIS_fnc_error;
};

if (["WasRevealedTo", [_objective, _side]] call SELF) exitWith
{
	["Reveal: Already revealed to side %1", _side] call BIS_fnc_error;
};

if (["HasEnded", [_objective]] call SELF) exitWith
{
	"Reveal: Objective already ended, ignoring reveal" call BIS_fnc_log;
};

if (["HasEndGameStarted"] call INSTANCE) exitWith
{
	["Reveal: EndGame already started, ignoring updates to prevous objectives", _side] call BIS_fnc_logFormat;
};

private ["_isStartGame", "_isEndGame"];
_isStartGame = ["GetIsStartGame", [_objective]] call SELF;
_isEndGame = ["GetIsEndGame", [_objective]] call SELF;

// Flag as revealed to side
private "_revealedTo";
_revealedTo = _objective getVariable [VAR_REVEALED_TO, []];
_revealedTo pushBack _side;
_objective setVariable [VAR_REVEALED_TO, _revealedTo, IS_PUBLIC];

// Initial dialogue
private ["_objectiveId", "_objectiveType", "_sides"];
_objectiveId	= [_objective] call BIS_fnc_objectVar;
_objectiveType	= ["GetType", [_objective]] call SELF;
_sides		= ["GetSides"] call INSTANCE;

if (!_isStartGame && !_isEndGame) then
{
	// Task
	private ["_taskId", "_taskParams", "_taskType"];
	_taskId 	= ["GetTaskId", [_objective, _side]] call SELF;
	_taskParams 	= ["GetTaskParams", [_objective]] call SELF;
	_taskType	= ["GetTaskTypeLetter", [_objective]] call SELF;

	_taskParams set [1, _taskParams select 1];

	// Create the task
	[_taskId, _side, _taskParams, [["GetSimpleObjectiveObject", [_objective]] call SELF, true], "CREATED", -1, true, true, _taskType, true] call BIS_fnc_setTask;

	// Conversation
	if (time >= (missionNamespace getVariable ["BIS_hvt_conversationTime", 0]) + 30) then
	{
		missionNamespace setVariable ["BIS_hvt_conversationTime", time];
		["IntelWanted", _side] call bis_fnc_moduleMPTypeHvt_conversations;
	};
};

// Show objects if hidden
["SetObjectsVisibility", [_objective, true]] call SELF;
