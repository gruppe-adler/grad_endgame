params [
	["_objective", objNull, [objNull]], 
	["_sideA", WEST, [sideUnknown]], 
	["_sideB", EAST, [sideUnknown]]
];

if (isNull _objective) exitWith {
	"InitializeObjective: Unable to initialize a NULL objective" call BIS_fnc_error;
};

// Extract objective info from config
private _cfg = configFile >> CLASS_OBJECTIVES;
private _type = _objective getVariable ["typeCustom", "StartGame"];
private _kind = getText (_cfg >> _type >> "kind");
private _isStartGame = _kind == "StartGame";
private _isEndGame = _kind == "EndGame";
private _fsmPath = getText (_cfg >> _type >> "fsmPath");
private _isIndependent = getNumber (_cfg >> _type >> "isIndependent") > 0;

_objective setVariable [VAR_INITIALIZED, true, IS_PUBLIC];
_objective setVariable [VAR_REVEALED_TO, [], IS_PUBLIC];
_objective setVariable [VAR_IS_INDEPENDENT, _isIndependent];
_objective setVariable [VAR_TYPE, _type, IS_PUBLIC];
_objective setVariable [VAR_KIND, _kind, IS_PUBLIC];
_objective setVariable [VAR_VISIBLE, true];
_objective setVariable [VAR_FSM_PATH, _fsmPath];

if (_fsmPath != "") then {
	private _fsm = [_objective, _sideA, _sideB] execFSM _fsmPath;
	_objective setVariable [VAR_FSM, _fsm];
};

if (!_isStartGame && !_isEndGame) then {
	// Area
	["InitializeArea", [_objective]] call bis_fnc_moduleMPTypeHvt_areaManager;

	// Reveal objective objects
	["SetObjectsVisibility", [_objective, true]] call SELF;
};

(["GetSimpleObjectiveObject", [_objective]] call SELF) setVariable [VAR_OBJECTIVE_OWNER, _objective, true];
(["GetSimpleObjectiveObject", [_objective]] call SELF) setVariable [VAR_OBJECTIVE_LETTER, ["GetTaskTypeLetter", [_objective]] call SELF, true];

// Log
diag_log format ["Initialize: %1 / %2 / %3 / %4 / %5 / %6 / %7", _objective, _type, _kind, _isStartGame, _isEndGame, _fsmPath, _isIndependent]k;