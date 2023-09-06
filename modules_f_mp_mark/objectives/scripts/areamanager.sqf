#define INDEX_OBJECTIVE 	0
#define INDEX_TRIGGERS	 	1

private ["_action", "_parameters"];
_action 	= _this param [0, "", [""]];
_parameters 	= _this param [1, [], [[]]];

switch (_action) do {
	case "InitializeArea" :
	{
		if (!isServer) exitWith {};

		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		private "_playableSides";
		_playableSides = ["GetSides"] call BIS_fnc_moduleHvtObjectivesInstance;

		private "_triggers";
		_triggers = [];

		for "_i" from 0 to ((count _playableSides) - 1) do {
			private "_sideString";
			_sideString = toLower str (_playableSides select _i);

			private "_trigger";
			_trigger = createTrigger ["EmptyDetector", position _objective];
			_trigger setTriggerArea [250.0, 250.0, 0, false];
			_trigger setTriggerActivation [_sideString, "PRESENT", true];
			_trigger setTriggerStatements [
				"this && { isPlayer _x } count thislist > 0",
				format["['OnAreaEnter', [missionNamespace getVariable '%1', '%2']] call bis_fnc_moduleMPTypeHvt_areaManager;", [_objective] call bis_fnc_objectVar, _sideString],
				format["['OnAreaLeave', [missionNamespace getVariable '%1', '%2']] call bis_fnc_moduleMPTypeHvt_areaManager;", [_objective] call bis_fnc_objectVar, _sideString]
			];

			_triggers pushBack _trigger;
		};

		// Store triggers within the objective
		_objective setVariable ["BIS_areaManager_triggers", _triggers];

		if (isNil { BIS_areaManager_areas }) then {
			BIS_areaManager_areas = [_objective];
			publicVariable "BIS_areaManager_areas";
		} else {
			private "_areas";
			_areas = BIS_areaManager_areas;
			_areas pushBack _objective;
			BIS_areaManager_areas = _areas;
			publicVariable "BIS_areaManager_areas";
		};
	};

	case "TerminateArea" :
	{
		if (!isServer) exitWith {};

		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		private "_triggers";
		_triggers = _objective getVariable ["BIS_areaManager_triggers", []];

		// Delete triggers
		{ deleteVehicle _x; } forEach _triggers;

		// Remove area
		if (!isNil { BIS_areaManager_areas }) then {
			private ["_areas", "_index"];
			_areas = BIS_areaManager_areas;
			_index = _areas find _objective;

			if !(_index isEqualTo -1) then {
				_areas deleteAt _index;
				BIS_areaManager_areas = _areas;
			};
		};

		// Reset triggers data
		_objective setVariable ["BIS_areaManager_triggers", nil];

		// Delete marker on client machines
		[[[str _objective], { deleteMarkerLocal (_this select 0); }], "BIS_fnc_spawn"] call BIS_fnc_mp;
	};

	case "ClientLoop" :
	{
		if (!hasInterface) exitWith {};

		[] spawn
		{
			scriptName "AreaManager client loop";

			while { isNil { BIS_hvt_endGame } } do
			{
				private "_areas";
				_areas = if (!isNil { BIS_areaManager_areas }) then { BIS_areaManager_areas } else { [] };

				{
					["UpdateAreaMarker", [_x]] call bis_fnc_moduleMPTypeHvt_areaManager;
					sleep 5;
				} forEach _areas;

				sleep 5;
			};

			private "_areas";
			_areas = if (!isNil { BIS_areaManager_areas }) then { BIS_areaManager_areas } else { [] };

			{
				deleteMarkerLocal str _x;
			} forEach _areas;
		};
	};

	case "UpdateAreaMarker" :
	{
		if (!hasInterface) exitWith {};

		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		// Make sure this objective was revealed to side of player
		if !(["WasRevealedTo", [_objective, side group player]] call BIS_fnc_moduleHvtObjective) exitWith {};

		private ["_side", "_sideEnemy"];
		_side = side group player;
		_sideEnemy = ["GetOppositeSide", [_side]] call BIS_fnc_moduleHvtObjectivesInstance;

		private ["_position", "_radius"];
		_position = position _objective;
		_radius = 250.0;

		private ["_friendlyUnits", "_enemyUnits"];
		_friendlyUnits 	= { _x distance _position <= _radius && side group _x == _side && isPlayer _x } count allUnits;
		_enemyUnits 	= { _x distance _position <= _radius && side group _x == _sideEnemy && isPlayer _x } count allUnits;


		if (_friendlyUnits < 1 && _enemyUnits < 1) exitWith
		{
			if (str _objective in allMapMarkers) then
			{
				deleteMarkerLocal str _objective;
			};
		};

		private ["_colorSide", "_colorEnemy"];
		_colorSide = switch (_side) do {
			case WEST : { "ColorWEST" };
			case EAST : { "ColorEAST" };
			case default { "ColorGUER" };
		};
		_colorEnemy = switch (_sideEnemy) do
		{
			case WEST : { "ColorWEST" };
			case EAST : { "ColorEAST" };
			case default { "ColorGUER" };
		};

		private "_marker";
		_marker = str _objective;

		if (_friendlyUnits > _enemyUnits) then
		{
			if !(_marker in allMapMarkers) then {
				_marker = createMarkerLocal [str _objective, _position];
			};

			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "SolidFull";
			_marker setMarkerColorLocal _colorSide;
			_marker setMarkerSizeLocal [_radius, _radius];
			_marker setMarkerAlphaLocal 0.4;
		}
		else
		{
			if !(_marker in allMapMarkers) then
			{
				_marker = createMarkerLocal [str _objective, _position];
			};

			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "SolidFull";
			_marker setMarkerColorLocal _colorEnemy;
			_marker setMarkerSizeLocal [_radius, _radius];
			_marker setMarkerAlphaLocal 0.4;
		};
	};

	case "OnAreaEnter" :
	{
		if (!isServer) exitWith {};

		private ["_objective", "_sideString"];
		_objective	= _parameters param [0, objNull, [objNull]];
		_sideString 	= _parameters param [1, "", [""]];

		private "_side";
		_side = switch (toLower _sideString) do
		{
			case "west" : { WEST };
			case "east" : { EAST };
			case default { RESISTANCE };
		};

		// Make sure this objective was revealed to side of player
		if !(["WasRevealedTo", [_objective, _side]] call BIS_fnc_moduleHvtObjective) exitWith {};

		// First time this side enters the objective area
		if (isNil { _objective getVariable format ["BIS_fnc_moduleHvtObjective_sideInsideObjective_%1", _side] }) then
		{
			// Flag this objective that this side was revealed with it's area
			_objective setVariable [format ["BIS_fnc_moduleHvtObjective_sideInsideObjective_%1", _side], true];

			// Unlock respawn position
			["UnlockRespawnPositions", [_objective, _side]] call BIS_fnc_moduleHvtObjective;
		};

		// Log
		["OnAreaEnter: %1", _parameters] call BIS_fnc_logFormat;
	};

	case "OnAreaLeave" :
	{
		if (!isServer) exitWith {};

		// Log
		["OnAreaLeave: %1", _parameters] call BIS_fnc_logFormat;
	};

	case "IsAreaRevealedToSide" :
	{
		private ["_objective", "_side"];
		_objective	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, SIDEUNKNOWN, [SIDEUNKNOWN]];

		!isNil { _objective getVariable format ["BIS_fnc_moduleHvtObjective_sideInsideObjective", _side] };
	};

	case default
	{
		["Unknown action: %1", _action] call BIS_fnc_error;
	};
};