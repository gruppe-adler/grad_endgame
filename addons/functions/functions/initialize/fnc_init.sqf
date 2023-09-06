#include "script_component.hpp"

#define SELF 							{ _this call BIS_fnc_moduleHvtObjectivesInstance; }
#define OBJECTIVE 						{ _this call BIS_fnc_moduleHvtObjective; }
#define VAR_INITIALIZED 				"BIS_moduleHvtObjectivesInstance_initialized"
#define VAR_LOGIC						"BIS_moduleHvtObjectivesInstance_logic"
#define VAR_SIDES_WITH_FOB				"BIS_moduleHvtObjectivesInstance_sidesWithFob"
#define VAR_ENDGAME_OBJECTIVE			"BIS_moduleHvtObjectivesInstance_endGameObjective"
#define VAR_ENDGAME_THRESHOLD			"BIS_moduleHvtObjectivesInstance_endGameThreshold"
#define VAR_RANDOMISERS					"BIS_moduleHvtObjectivesInstance_randomisers"
#define VAR_OBJECTIVES					"BIS_moduleHvtObjectivesInstance_objectives"
#define VAR_OBJECTIVES_ORDERED			"BIS_moduleHvtObjectivesInstance_objectivesOrdered"
#define VAR_COMPLETED_OBJECTIVES		"BIS_moduleHvtObjectivesInstance_completedObjectives"
#define VAR_SIDES						"BIS_moduleHvtObjectivesInstance_sides"
#define VAR_BASES						"BIS_moduleHvtObjectivesInstance_bases"
#define VAR_BASE_SIDE					"BIS_moduleHvtObjectivesInstance_baseSide"
#define VAR_MISSION_FLOW_FSM			"BIS_moduleHvtObjectivesInstance_fsm"
#define CLASS_OBJECTIVE_RANDOMISER		"ModuleHvtObjectiveRandomiser_F"
#define CLASS_SIMPLE_OBJECTIVE			"ModuleHvtSimpleObjective_F"
#define CLASS_STARTGAME_OBJECTIVE		"ModuleHvtStartGameObjective_F"
#define CLASS_ENDGAME_OBJECTIVE			"ModuleHvtEndGameObjective_F"
#define LOG_NETWORK_TRAFFIC				cheatsEnabled

params [
    ["_logic", objNull, [objNull]], 
    ["_endGameThreshold", 3, [0]]
];

// Validate the logic itself
if (isNull _logic) exitWith {
    "Initialize: Logic cannot be null" call BIS_fnc_error;
};

// Make sure module doesn't initialize multiple times
if (missionNamespace getVariable [VAR_INITIALIZED, false]) exitWith
{
    ["Initialize: Multiple initialization detected: %1 / Only one module can be placed", _logic] call BIS_fnc_error;
};

// EndGame threshold
missionNamespace setVariable [VAR_ENDGAME_THRESHOLD, _endGameThreshold];

// Flag as initialized and store logic
missionNamespace setVariable [VAR_INITIALIZED, true];
missionNamespace setVariable [VAR_LOGIC, _logic, true];
missionNamespace setVariable [VAR_SIDES, [WEST, EAST], true];

// Gather objectives and randomisers
private _objectives = [] call FUNCF(initalize,getAllSyncedObjectives);
private _randomisers = [] call FUNCF(initalize,getAllSyncedRandomisers);
private _bases = [] call FUNCF(initalize,getAllSyncedBases);
private _endGameObjectives = [] call FUNCF(initalize,getSyncedEndGameObjectives);

// Validate EndGame objective
if ({ !isNull _x } count _endGameObjectives < 1) exitWith {
    ["Initialize: EndGame objectives not valid (%1), at least one must be added to mission", _endGameObjectives] call BIS_fnc_error;
    [] call FUNCF(initalize,terminate);
};

private _endGameObjective = selectRandom _endGameObjectives;
_endGameObjectives = _endGameObjectives - [_endGameObjective];

// Go through all randomiser modules and gather a random objective from each
{
    private _randomObjective = [_x] call FUNCF(initalize,GetRandomObjectiveFromRandomiser);

    if (!isNull _randomObjective) then
    {
        _objectives pushBack _randomObjective;
    };
} forEach _randomisers;

// Validate number of middle game objectives
if (count _objectives < _endGameThreshold) exitWith {
    ["Initialize: Not enough objectives", _endGameThreshold, _objectives] call BIS_fnc_error;
    [] call FUNCF(initalize,terminate);
};

private ["_countBasesWest", "_countBasesEast"];
_countBasesWest = { _x getVariable ["AttackingSide", "SideUnknown"] == "WEST" } count _bases;
_countBasesEast = { _x getVariable ["AttackingSide", "SideUnknown"] == "EAST" } count _bases;

// Validate number of bases per side
if (
    _countBasesWest < 1 ||
    _countBasesEast < 1
) exitWith {
    ["Not enough bases were set: West (%1) / East (%2)", _countBasesWest, _countBasesEast] call BIS_fnc_error;
};

private _basesWest = [];
private _basesEast = [];

// Go through all the bases and retrieve a random one for each side
{
    private _ownerSide = _x getVariable ["AttackingSide", "WEST"];

    switch (_ownerSide) do {
        case "WEST" : 		{ _basesWest pushBack _x; };
        case "EAST" : 		{ _basesEast pushBack _x; };
        case "RESISTANCE" : 	{ RESISTANCE };
        case default 		{ CIVILIAN };
    };
} forEach _bases;

// Select a random base for each side
private _baseWest = selectRandom _basesWest;
private _baseEast = selectRandom _basesEast;

// Get each side base
{
    private _ownerSide = _x getVariable ["AttackingSide", "WEST"];

    // Convert the side string to actual side object
    private _side = switch (_ownerSide) do {
        case "WEST" : 		{ WEST };
        case "EAST" : 		{ EAST };
        case "RESISTANCE" : 	{ RESISTANCE };
        case default 		{ CIVILIAN };
    };

    // Flag the objective with the owner side
    _x setVariable [VAR_BASE_SIDE, _side, true];

    // Initialize objective
    ["InitializeObjective", [_x, _side, ["GetOppositeSide", [_side]] call SELF]] call SELF;
    ["Reveal", [_x, _side]] call OBJECTIVE;
    ["SetObjectsVisibility", [_x, true]] call OBJECTIVE;

    // Log
    ["Initialize: Base (%1) registered for (%2)", _x, _side] call BIS_fnc_logFormat;
} forEach [_baseWest, _baseEast];

        // Delete objects and clutter from bases which were not used
        private "_toDeleteBases";
        _toDeleteBases = _bases - [_baseWest, _baseEast];

        {
            ["DeleteObjects", [_x]] call OBJECTIVE;
        } forEach _toDeleteBases;

        // Store data
        missionNamespace setVariable [VAR_RANDOMISERS, _randomisers];
        missionNamespace setVariable [VAR_BASES, [_baseWest, _baseEast], true];
        missionNamespace setVariable [VAR_OBJECTIVES, _objectives, true];
        missionNamespace setVariable [VAR_ENDGAME_OBJECTIVE, _endGameObjective, true];
        missionNamespace setVariable [VAR_COMPLETED_OBJECTIVES, []];

        // Hide all objectives
        {
            ["SetObjectsVisibility", [_x, false]] call OBJECTIVE;
        } forEach _objectives + [_endGameObjective];

        // Delete objects from unwanted objectives
        {
            ["DeleteObjects", [_x]] call OBJECTIVE;
        } forEach (["GetAllUnwantedObjectives"] call SELF) + _endGameObjectives;

        // Suflle objectives
        private "_shuffledObjectives";
        _shuffledObjectives = _objectives call bis_fnc_arrayShuffle;
        missionNamespace setVariable [VAR_OBJECTIVES_ORDERED, _shuffledObjectives];

        // Init server and players
        [[], "BIS_fnc_moduleHvtInit", true, true] call BIS_fnc_mp;

        // Music
        ["PlayMusic", [1, sideUnknown]] call SELF;

        // Log
        ["Initialize: %1 / %2 / %3 / %4", _logic, _randomisers, _objectives] call BIS_fnc_logFormat;