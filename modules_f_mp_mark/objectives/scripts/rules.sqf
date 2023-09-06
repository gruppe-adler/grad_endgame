disableSerialization;

#include "\a3\Ui_f\hpp\defineresincldesign.inc"
#include "\a3\Ui_f\hpp\definecommongrids.inc"

private ["_target", "_alt", "_radius", "_startAzimuth", "_dir"];
_target = _this param [0, objNull, [objNull, []], 3];	// Target (object or position)
_alt = _this param [1, 500, [500]];			// Altitude in meters
_radius = _this param [2, 200, [200]];			// Radius in meters
_startAzimuth = _this param [3, random 360, [0]];		// Azimuth that the camera faces to start with (in degrees)
_dir = _this param [4, round random 1, [0]];		// Direction of camera movement (0: clockwise, 1: anti-clockwise)

// Establish control variables
BIS_rules_ended = false;
BIS_rules_skip = false;
BIS_rules_playing = false;

// Hide screen
("BIS_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK FADED", 10e10];

// Disable sound
[] spawn {waitUntil {time > 0}; 0 fadeSound 0};

// Create camera
private ["_camera"];
_camera = "Camera" camCreate [10,10,10];
_camera cameraEffect ["INTERNAL", "BACK"];

// Calculate start position (reverse azimuth so camera FACES the defined direction)
private ["_pos"];
_pos = [_target, _radius, (_startAzimuth * -1)] call BIS_fnc_relPos;
_pos set [2, _alt];

// Position camera
_camera camPrepareTarget _target;
_camera camPreparePos _pos;
_camera camPrepareFOV 0.700;
_camera camCommitPrepared 0;

// Timeout the preload after 3 seconds
_camera camPreload 3;

// Enable camera HUD effects
cameraEffectEnableHUD true;

// Disable cinema borders
[] spawn {waitUntil {time > 0}; showCinemaBorder false};

// Apply post-process effects
private ["_ppColor"];
_ppColor = ppEffectCreate ["ColorCorrections", 1999];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [0.8, 0.8, 0.8, 0.65], [1, 1, 1, 1]];
_ppColor ppEffectCommit 0;

private ["_ppGrain"];
_ppGrain = ppEffectCreate ["FilmGrain", 2012];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [0.1, 1, 1, 0, 1];
_ppGrain ppEffectCommit 0;

[] spawn {
	disableSerialization;

	scriptName "rules.sqf: add skip eventhandler";

	waitUntil {!(isNull ([] call BIS_fnc_displayMission))};

	// Remove eventhandler if it exists (only happens when restarting)
	if (!(isNil {uiNamespace getVariable "BIS_rules_skipEH"})) then {
		([] call BIS_fnc_displayMission) displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_rules_skipEH"];
		uiNamespace setVariable ["BIS_rules_skipEH", nil];
	};

	// Add skipping eventhandler
	private ["_skipEH"];
	_skipEH = ([] call BIS_fnc_displayMission) displayAddEventHandler [
		"KeyDown",
		{
			private ["_key"];
			_key = _this select 1;

			if (_key == 57) then {
				// Remove eventhandler
				([] call BIS_fnc_displayMission) displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_rules_skipEH"];
				uiNamespace setVariable ["BIS_rules_skipEH", nil];

				// Play sound
				playSound ["click", true];

				// Register skip
				BIS_rules_skip = true;
			};

			// Block all keys except for Esc
			if (_key != 1) then {true};
		}
	];

	// Store skipping eventhandler
	uiNamespace setVariable ["BIS_rules_skipEH", _skipEH];
};

// Wait for the camera to preload
waitUntil {camPreloaded _camera || BIS_rules_skip};

if (!(BIS_rules_skip)) then {
	// Register that the rules screen is playing
	BIS_rules_playing = true;

	// Create logics to play sounds (only way to instantly stop sounds)
	BIS_rules_logicGroup = createGroup sideLogic;
	BIS_rules_logic1 = BIS_rules_logicGroup createUnit ["Logic", [10,10,10], [], 0, "NONE"];
	BIS_rules_logic2 = BIS_rules_logicGroup createUnit ["Logic", [10,10,10], [], 0, "NONE"];
	BIS_rules_logic3 = BIS_rules_logicGroup createUnit ["Logic", [10,10,10], [], 0, "NONE"];

	// Loop UAV sounds
	[] spawn {
		scriptName "rules.sqf: UAV sounds";

		// Determine duration
		private ["_sound", "_duration"];
		_sound = "UAV_loop";
		_duration = getNumber (configFile >> "CfgSounds" >> _sound >> "duration");

		// Play sounds in a loop
		while {!(isNull BIS_rules_logic1)} do {
			BIS_rules_logic1 say _sound;
			sleep _duration;

			if (!(isNull BIS_rules_logic2)) then {
				BIS_rules_logic2 say _sound;
				sleep _duration;
			};
		};
	};

	// Loop ambient chatter
	[] spawn {
		scriptName "rules.sqf: ambient chatter";

		while {!(isNull BIS_rules_logic3)} do {
			// Choose random sound
			private ["_sound", "_duration"];
			_sound = format ["UAV_0%1", round (1 + random 8)];
			_duration = getNumber (configFile >> "CfgSounds" >> _sound >> "duration");

			// Play sound
			BIS_rules_logic3 say _sound;

			sleep (_duration + (5 + random 5));
		};
	};

	// Make camera move in a circle
	[_camera, _target, _alt, _radius, _startAzimuth, _dir] spawn {
		scriptName (format ["rules.sqf: camera control - %1", _this]);

		private ["_camera", "_target", "_alt", "_radius", "_startAzimuth", "_dir"];
		_camera = _this select 0;
		_target = _this select 1;
		_alt = _this select 2;
		_radius = _this select 3;
		_startAzimuth = _this select 4;
		_dir = _this select 5;

		// Reverse azimuth so camera FACES the defined direction
		private ["_azimuth"];
		_azimuth = _startAzimuth * -1;

		while {BIS_rules_playing} do {
			// Calculate updated position
			private ["_pos"];
			_pos = [_target, _radius, _azimuth] call BIS_fnc_relPos;
			_pos set [2, _alt];

			// Position camera
			_camera camPreparePos _pos;
			_camera camCommitPrepared 0.5;

			waitUntil {!(BIS_rules_playing) || {camCommitted _camera}};

			// Instantly commit camera (prevents shaking)
			_camera camPreparePos _pos;
			_camera camCommitPrepared 0;

			// Make the camera move in the desired direction
			_azimuth = if (_dir == 0) then {_azimuth + 0.5} else {_azimuth - 0.5};
		};
	};

	sleep 1;

	if (!(BIS_rules_skip)) then {
		// Fade sound in
		2 fadeSound 1;

		// Static fade-in
		("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
		playSound "Spawn";

		waitUntil {!isNull (uiNamespace getVariable ["RscStatic_display", displayNull]) || BIS_rules_skip};
		waitUntil {isNull (uiNamespace getVariable ["RscStatic_display", displayNull]) || BIS_rules_skip};

		if (!(BIS_rules_skip)) then {
			// Create vignette & tiles
			("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];

			// Create interlacing
			("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];

			// Remove effects if video options opened
			optionsMenuOpened = {
				disableSerialization;
				{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];
			};

			// Add the effects back if closed
			optionsMenuClosed = {
				disableSerialization;
				("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
				("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];
			};

			// Bring screen in
			("BIS_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];

			// Spawn rules separately to allow for no delay in skipping
			[] spawn {
				disableSerialization;

				scriptName "rules.sqf: rules";

				// Create rules display
				private ["_layer"];
				_layer = "BIS_layerRules" call BIS_fnc_rscLayer;
				_layer cutRsc ["RscPhaseRules", "PLAIN"];

				// Grab display
				private ["_display"];
				_display = uiNamespace getVariable "BIS_rules_display";

				// Phase 1 controls
				private ["_number1", "_text1", "_info1"];
				_number1 = _display displayCtrl IDC_RSCPHASERULES_PHASE1NUMBER;
				_text1 = _display displayCtrl IDC_RSCPHASERULES_PHASE1TEXT;
				_info1 = _display displayCtrl IDC_RSCPHASERULES_PHASE1INFO;

				// Phase 2 controls
				private ["_number2", "_text2", "_info2"];
				_number2 = _display displayCtrl IDC_RSCPHASERULES_PHASE2NUMBER;
				_text2 = _display displayCtrl IDC_RSCPHASERULES_PHASE2TEXT;
				_info2 = _display displayCtrl IDC_RSCPHASERULES_PHASE2INFO;

				// Phase 3 controls
				private ["_number3", "_text3", "_info3"];
				_number3 = _display displayCtrl IDC_RSCPHASERULES_PHASE3NUMBER;
				_text3 = _display displayCtrl IDC_RSCPHASERULES_PHASE3TEXT;
				_info3 = _display displayCtrl IDC_RSCPHASERULES_PHASE3INFO;

				// Set up controls
				{
					_x ctrlSetFade 1;
					_x ctrlSetTextColor [1,1,1,1];
					_x ctrlSetBackgroundColor [0,0,0,1];
					_x ctrlCommit 0;
				} forEach [_number1, _number2, _number3, _text1, _text2, _text3, _info1, _info2, _info3];

				// Numbers
				_number1 ctrlSetText "I";
				_number2 ctrlSetText "II";
				_number3 ctrlSetText "III";

				// Texts
				private ["_text1Pos", "_text2Pos", "_text3Pos"];
				_text1Pos = ctrlPosition _text1;
				_text2Pos = ctrlPosition _text2;
				_text3Pos = ctrlPosition _text3;

				_text1 ctrlSetText (localize "STR_A3_RscHvtPhase_PhaseOne");
				_text2 ctrlSetText (localize "STR_A3_RscHvtPhase_PhaseTwo");
				_text3 ctrlSetText (localize "STR_A3_RscHvtPhase_PhaseThree");

				// Collapse text
				{
					private ["_pos"];
					_pos = ctrlPosition _x;
					_pos set [2,0];

					_x ctrlSetPosition _pos;
					_x ctrlSetFade 0;
					_x ctrlCommit 0;
				} forEach [_text1, _text2, _text3];

				// Info
				private ["_info1Pos", "_info2Pos", "_info3Pos"];
				_info1Pos = ctrlPosition _info1;
				_info2Pos = ctrlPosition _info2;
				_info3Pos = ctrlPosition _info3;

				_info1 ctrlSetStructuredText parseText ("<t size = '0.8' shadow = '0'>" + (localize "STR_A3_RscPhaseRules_PhaseOne") + "</t>");
				_info2 ctrlSetStructuredText parseText ("<t size = '0.8' shadow = '0'>" + (localize "STR_A3_RscPhaseRules_PhaseTwo") + "</t>");
				_info3 ctrlSetStructuredText parseText ("<t size = '0.8' shadow = '0'>" + (localize "STR_A3_RscPhaseRules_PhaseThree") + "</t>");

				// Collapse info
				{
					private ["_pos"];
					_pos = ctrlPosition _x;
					_pos set [3,0];

					_x ctrlSetPosition _pos;
					_x ctrlSetBackgroundColor [0,0,0,0.75];
					_x ctrlSetFade 0;
					_x ctrlCommit 0;
				} forEach [_info1, _info2, _info3];

				// Fade out elements when space is pressed
				[_number1, _number2, _number3, _text1, _text2, _text3, _info1, _info2, _info3] spawn {
					disableSerialization;

					scriptName "rules.sqf: rules fade";

					// Wait for rules to end or be skipped
					waitUntil {BIS_rules_ended || BIS_rules_skip};

					// Fade elements
					{
						_x ctrlSetFade 1;
						_x ctrlCommit 0.5;
					} forEach _this;
				};

				sleep 1;

				private ["_state"];
				_state = 1;

				while {_state < 3} do {
					switch (_state) do {
						case 1: {
							// Phase numbers
							private ["_ctrls"];
							_ctrls = [_number1, _number2, _number3];

							for "_i" from 1 to 3 do {
								// Fade in phase numbers
								private ["_ctrl"];
								_ctrl = _ctrls select (_i - 1);
								_ctrl ctrlSetFade 0;
								if (!(BIS_rules_skip)) then {_ctrl ctrlCommit 0.3};
								if (!(BIS_rules_skip)) then {playSound ["AddItemOK", true]};
								sleep 0.2;
							};

							sleep 2;
						};

						case 2: {
							// Phase texts and info
							private ["_ctrlsNumber", "_ctrlsText", "_ctrlsInfo", "_textPositions", "_infoPositions"];
							_ctrlsNumber = [_number1, _number2, _number3];
							_ctrlsText = [_text1, _text2, _text3];
							_ctrlsInfo = [_info1, _info2, _info3];
							_textPositions = [_text1Pos, _text2Pos, _text3Pos];
							_infoPositions = [_info1Pos, _info2Pos, _info3Pos];

							for "_i" from 1 to 3 do {
								private ["_index", "_ctrlNumber", "_ctrlText", "_ctrlInfo", "_textPos", "_infoPos"];
								_index = _i - 1;
								_ctrlNumber = _ctrlsNumber select _index;
								_ctrlText = _ctrlsText select _index;
								_ctrlInfo = _ctrlsInfo select _index;
								_textPos = _textPositions select _index;
								_infoPos = _infoPositions select _index;

								// Invert phase numbers
								_ctrlNumber ctrlSetTextColor [0,0,0,1];
								_ctrlNumber ctrlSetBackgroundColor [1,1,1,1];

								// Expand phase texts
								_ctrlText ctrlSetPosition _textPos;

								if (!(BIS_rules_skip)) then {{_x ctrlCommit 0.2} forEach [_ctrlNumber, _ctrlText]};
								if (!(BIS_rules_skip)) then {playSound ["defaultNotification", true]};

								waitUntil {{!(ctrlCommitted _x)} count [_ctrlNumber, _ctrlText] == 0};

								sleep 0.1;

								if (!(BIS_rules_skip)) then {playSound ["Beep_Target", true]};

								private ["_inverted"];
								_inverted = false;

								for "_i" from 1 to 5 do {
									private ["_colorText", "_colorBG"];
									_colorText = [0,0,0,1];
									_colorBG = [1,1,1,1];

									if (_inverted) then {
										_inverted = false;
									} else {
										_inverted = true;
										_colorText = [1,1,1,1];
										_colorBG = [0,0,0,1];
									};

									_ctrlText ctrlSetTextColor _colorText;
									_ctrlText ctrlSetBackgroundColor _colorBG;
									if (!(BIS_rules_skip)) then {_ctrlText ctrlCommit 0.05};
									waitUntil {ctrlCommitted _ctrlText};
								};

								sleep 0.5;

								// Expand info
								_ctrlInfo ctrlSetPosition _infoPos;
								if (!(BIS_rules_skip)) then {_ctrlInfo ctrlCommit 0.2};
								//playSound ["HintExpand", true];
								if (!(BIS_rules_skip)) then {playSound ["ZoomOut", true]};

								waitUntil {ctrlCommitted _ctrlInfo};
								sleep 2;
							};
						};
					};

					_state = _state + 1;
				};

				// Spawn instructions separately to allow for no delay in skipping
				[] spawn {
					disableSerialization;

					scriptName "rules.sqf: instructions";

					if (!(BIS_rules_skip)) then {
						// Create display
						private ["_layer"];
						_layer = "BIS_layerInstructions" call BIS_fnc_rscLayer;
						_layer cutRsc ["RscDynamicText", "PLAIN"];

						// Grab display and control
						private ["_display", "_ctrl"];
						_display = uiNamespace getVariable "BIS_dynamicText";
						_ctrl = _display displayCtrl 9999;

						// Position text in bottom center
						_ctrl ctrlSetPosition [
							0 * safeZoneW + safeZoneX,
							0.8 * safeZoneH + safeZoneY,
							safeZoneW,
							safeZoneH
						];

						// Determine key highlight
						private ["_color"];
						_color = (["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML;

						// Compose instructions string
						private ["_string", "_parsed"];
						_string = format [localize "STR_A3_BIS_fnc_titlecard_pressSpace", "<t size = '0.75'>", format ["<t color = '%1'>", _color], "</t>", "</t>"];
						_parsed = parseText _string;

						// Add text to element and hide it
						_ctrl ctrlSetStructuredText _parsed;
						_ctrl ctrlSetFade 1;
						_ctrl ctrlCommit 0;

						// Fade element in
						_ctrl ctrlSetFade 0;
						_ctrl ctrlCommit 1;

						// Wait for shot to finish
						waitUntil {BIS_rules_ended || BIS_rules_skip};

						// Fade element out
						_ctrl ctrlSetFade 1;
						_ctrl ctrlCommit 0.5;
					};
				};

				// Display info for 20 seconds
				private ["_time"];
				_time = time + 20;

				waitUntil {time >= _time || BIS_rules_skip};

				// Remove the rules
				BIS_rules_ended = true;
			};
		};
	};
};

waitUntil {BIS_rules_ended || BIS_rules_skip};

// Register that they ended
BIS_rules_ended = true;

// Remove skipping eventhandler if it wasn't removed already
if (!(isNil {uiNamespace getVariable "BIS_rules_skipEH"})) then {
	([] call BIS_fnc_displayMission) displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_rules_skipEH"];
	uiNamespace setVariable ["BIS_rules_skipEH", nil];
};

// Static fade-out
2 fadeSound 0;
playSound "Spawn";

("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
waitUntil {!isNull (uiNamespace getVariable ["RscStatic_display", displayNull])};
waitUntil {isNull (uiNamespace getVariable ["RscStatic_display", displayNull])};

// Stop all sounds
{if (!(isNil _x)) then {deleteVehicle (missionNamespace getVariable _x)}} forEach ["BIS_rules_logic1", "BIS_rules_logic2", "BIS_rules_logic3"];
if (!(isNil "BIS_rules_logicGroup")) then {deleteGroup BIS_rules_logicGroup};

// Remove all HUD
optionsMenuOpened = nil;
optionsMenuClosed = nil;

{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];

// Fade screen
("BIS_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK FADED", 10e10];

sleep 1;

// Remove instructions and rules
{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerInstructions", "BIS_layerRules"];

// Register that the shot stopped
BIS_rules_playing = false;

// Destroy camera
_camera cameraEffect ["TERMINATE", "BACK"];
camDestroy _camera;

// Clear post process effects
ppEffectDestroy _ppColor;
ppEffectDestroy _ppGrain;

// Fade camera in
("BIS_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK IN", 1];
1 fadeSound 1;