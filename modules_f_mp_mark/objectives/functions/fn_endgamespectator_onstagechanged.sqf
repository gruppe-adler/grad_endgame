#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

// Function that handles stage changes for spectator
private "_stage";
_stage = _this param [0, -1, [-1]];

if (_stage > BIS_endGameSpectator_currentStage && ["IsInitialized"] call SPEC) then
{
	BIS_endGameSpectator_currentStage = _stage;

	switch (_stage) do
	{
		// Stage 1
		case 0 :
		{
			// Phase
			["SetGamePhase", [localize "STR_A3_Spectator_Phase1"]] call DISPLAY;
		};

		// Stage 2
		case 1 :
		{
			// Phase
			["SetGamePhase", [localize "STR_A3_Spectator_Phase2"]] call DISPLAY;

			BIS_stageTwoIds = [];

			// Add intel icons
			private ["_allObjectives", "_allDownloads"];
			_allObjectives = ["GetAllObjectives"] call INSTANCE;
			_allDownloads = [];

			{
				private ["_objects", "_object"];
				_objects = ["GetObjectiveObjects", [_x]] call OBJECTIVE;
				_object = if (count _objects > 0) then { _objects select 0 } else { objNull };

				if (!isNull _object) then
				{
					_allDownloads pushBack _object;
				};
			} forEach _allObjectives;

			missionNamespace setVariable [VAR_DOWNLOADS, _allDownloads];

			{
				private ["_id", "_center", "_dirTo", "_dirFrom", "_loc", "_dir"];
				_id = format ["Objective_%1", _x];
				_center = getPosASL _x;
				_dirTo = vectorDir _x;
				_dirFrom = _dirTo vectorMultiply -1;
				_loc = _center vectorAdd (_dirFrom vectorMultiply 50);
				_loc set [2, (_loc select 2) + 10.0];
				_dir = [_loc, _center] call BIS_fnc_dirTo;

				// Add download location
				["AddLocation", [_id, _center call BIS_fnc_locationDescription, "", ICON_DOWNLOAD, [_loc, [0,0,0], [0,0,0], [_dir, true]]]] call SPEC;

				// Store id so we can remove icons and locations later
				BIS_stageTwoIds pushBack _id;

				// Object Visualizer
				["InitializeContext", [_x]] call OBJECTIVE_VIZUALIZER;

				private _display = ["GetAssociatedDisplay", [_x]] call OBJECTIVE_VIZUALIZER;
				private _letter = _x getVariable [VAR_OBJECTIVE_LETTER, "X"];

				if (!isNull _display) then
				{
					["SetLetter", [_display, _x, _letter]] call WIDGET;
				};
			} forEach _allDownloads;
		};

		// Stage 3
		case 2 :
		{
			// Phase
			["SetGamePhase", [localize "STR_A3_Spectator_Phase3"]] call DISPLAY;

			// Remove all stage two objective icons
			if (!isNil { BIS_stageTwoIds } && { count BIS_stageTwoIds > 0 }) then
			{
				{
					["RemoveLocation", [_x]] call SPEC;
				} forEach BIS_stageTwoIds;

				BIS_stageTwoIds = nil;
			};

			{
				// Object Visualizer
				["TerminateContext", [_x]] call OBJECTIVE_VIZUALIZER;
			} forEach (missionNamespace getVariable [VAR_DOWNLOADS, []]);

			// Schematics
			private _endGameObjective = ["GetEndGameObjective"] call INSTANCE;
			private _uploads = ["GetEndGameObjectiveUploads", [_endGameObjective]] call OBJECTIVE;
			private _schematics = ["GetEndGameObjectivePickups", [_endGameObjective]] call OBJECTIVE;

			{
				// Object Visualizer
				["InitializeContext", [_x]] call OBJECTIVE_VIZUALIZER;

				private _display = ["GetAssociatedDisplay", [_x]] call OBJECTIVE_VIZUALIZER;
				private _letter = _x getVariable [VAR_OBJECTIVE_LETTER, "X"];

				if (!isNil { _display } && !isNull _display) then
				{
					["SetLetter", [_display, _x, _letter]] call WIDGET;
				};
			} forEach _uploads;

			{
				private ["_id", "_colorBackground", "_params", "_conditionShow"];
				_id			= format ["Schematics_%1", _x];
				_colorBackground 	= [RESISTANCE] call BIS_fnc_sideColor; _colorBackground set [3, FADE_BACKGROUND];
				_params			= [ICON_SCHEMATICS, [1, 1, 1, FADE_ICON], [0,0,0], 1.0, 1.0, 0, "", 1, 0.05, "PuristaMedium"];
				_conditionShow		= { !isNull _this && { !isObjectHidden _this } && { _this == ["GetPickupObject"] call CARRIER; } };

				// Add icon
				["AddCustomIcon", [_id, _x, _params, [true, _colorBackground], _conditionShow]] call SPEC;
			} forEach _schematics;
		};
	};
};
