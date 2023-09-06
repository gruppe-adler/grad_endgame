#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"
#include "\a3\modules_f_mp_mark\objectives\defines.inc"

// Function that handles carrier pickup info changes
private ["_pickupObject", "_pickupPlayer", "_pickupState", "_pickupLockedTo", "_uploadObjects"];
_pickupObject 	= _this param [0, objNull, [objNull]];
_pickupPlayer 	= _this param [1, [objNull, "", sideUnknown], [[]]];
_pickupState 	= _this param [2, "NeedsPickup", [""]];
_pickupLockedTo = _this param [3, sideUnknown, [sideUnknown]];
_uploadObjects	= _this param [4, [], [[]]];

switch (_pickupPlayer select 2) do
{
	// West has the schematics
	case WEST:
	{
		["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Upload"]] call DISPLAY;
		["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Defend"]] call DISPLAY;
	};

	// East has the schematics
	case EAST:
	{
		["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Upload"]] call DISPLAY;
		["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Defend"]] call DISPLAY;
	};

	// No one has the schematics
	// Schematics may be locked to a side
	default
	{
		if (isNil { missionNamespace getVariable "BIS_upload_side" }) then
		{
			if (_pickupLockedTo == EAST) then
			{
				["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Defend"]] call DISPLAY;
			}
			else
			{
				["SetSideTask", [0, localize "STR_A3_Sectator_HeadToHead_Retrieve"]] call DISPLAY;
			};

			if (_pickupLockedTo == WEST) then
			{
				["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Defend"]] call DISPLAY;
			}
			else
			{
				["SetSideTask", [1, localize "STR_A3_Sectator_HeadToHead_Retrieve"]] call DISPLAY;
			};
		};
	};
};
