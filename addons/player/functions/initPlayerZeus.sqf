("RscHvtPhase" call BIS_fnc_rscLayer) cutRsc ["RscHvtPhase", "PLAIN"];

[] spawn
{
	scriptName "initPlayerLocal.sqf RscHvtPhase";
	disableSerialization;
	sleep 3;

	private ["_westStage", "_eastStage"];
	_westStage = ["GetStageSide", [WEST]] call BIS_fnc_moduleHvtObjectivesInstance;
	_eastStage = ["GetStageSide", [EAST]] call BIS_fnc_moduleHvtObjectivesInstance;

	private "_zeusStage";
	_zeusStage = _westStage max _eastStage;

	if (_zeusStage >= 0) then
	{
		["SetStage", [_zeusStage]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
	};
};