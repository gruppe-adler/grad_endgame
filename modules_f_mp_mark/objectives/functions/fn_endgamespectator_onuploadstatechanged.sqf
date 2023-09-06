#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

// Function that handles carrier pickup info changes
private _side = _this param [0, sideUnknown, [sideUnknown]];

switch (_side) do
{
	// West uploading
	case WEST:
	{
		["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Uploading"]] call DISPLAY;
		["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Defending"]] call DISPLAY;
	};

	// East uploading
	case EAST:
	{
		["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Uploading"]] call DISPLAY;
		["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Defending"]] call DISPLAY;
	};

	// Upload ended / aborted
	default
	{
		["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Retrieve"]] call DISPLAY;
		["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Retrieve"]] call DISPLAY;
	};
};
