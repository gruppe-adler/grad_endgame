#include "script_component.hpp"

[QGVAR(OnStageChanged), {
	disableSerialization;
	["SetStage", _this] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
}] call CBA_fnc_addEventHandler;