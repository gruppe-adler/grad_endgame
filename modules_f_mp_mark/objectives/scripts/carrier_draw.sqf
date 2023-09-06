#define SELF 			{ _this call (missionNamespace getVariable ["bis_fnc_moduleMPTypeHvt_carrier", {}]) }
#define VAR_CARRIER_VISIBLE	"BIS_hvt_carrierVisible"
#define TEXT_CARRIER		localize "STR_A3_EndGame_Misc_Carrier"

params [["_map", controlNull, [controlNull]]];

private ["_pickupInfo", "_pickupObject", "_carrier"];
_pickupInfo 		= missionNamespace getVariable ["BIS_hvt_pickupInfo", [objNull, [objNull, "", sideUnknown], "NeedsPickup", sideUnknown, []]];
_pickupObject		= _pickupInfo select 0;
_carrier		= (_pickupInfo select 1) select 0;

if (!isNull _carrier && {["ShouldDrawCarrier", [_carrier]] call SELF}) then
{
	if (isNull _map) then
	{
		private ["_color", "_position", "_text"];
		_color		= switch (true) do
		{
			case (["IsInitialized"] call BIS_fnc_EGSpectator && {side group _carrier == WEST}) : 	{ [WEST] call BIS_fnc_sideColor; };
			case (["IsInitialized"] call BIS_fnc_EGSpectator) : 					{ [EAST] call BIS_fnc_sideColor; };
			case (side group player == side group _carrier) : 					{ [RESISTANCE] call BIS_fnc_sideColor; };
			default 										{ [0.8, 0.2, 0.0, 0.5] };
		};
		_position	= getPosATLVisual _carrier; _position set [2, (_position select 2) + 2];
		_text		= if (side group player == side group _carrier) then { ["GetLastCarrierName"] call SELF } else { TEXT_CARRIER };

		// Background
		drawIcon3D ["A3\Modules_F_MP_Mark\Objectives\images\CarrierBackground.paa", _color, _position, 2.0, 2.0, 0, "", 0];

		// Icon
		drawIcon3D ["A3\Modules_F_MP_Mark\Objectives\images\CarrierIcon.paa", [1,1,1,1], _position, 2.0, 2.0, 0, "", 0];

		// Text
		drawIcon3D ["", [1,1,1,1], _position, 2.0, -3.2, 0, _text, 2, 0.035, "PuristaLight", "center"];

		// Arrows
		drawIcon3D ["", _color, _position, 1.5, 1.5, 0, "", 2, 0.035, "PuristaLight", "center", true];
	}
	else
	{
		private ["_color", "_position", "_text"];
		_color		= switch (true) do
		{
			case (["IsInitialized"] call BIS_fnc_EGSpectator && {side group _carrier == WEST}) : 	{ [WEST] call BIS_fnc_sideColor; };
			case (["IsInitialized"] call BIS_fnc_EGSpectator) : 					{ [EAST] call BIS_fnc_sideColor; };
			case (side group player == side group _carrier) : 					{ [0.2, 0.8, 0.0, 0.5] };
			default 										{ [0.8, 0.2, 0.0, 0.5] };
		};
		_position	= getPosATLVisual _carrier;
		_text		= if (side group player == side group _carrier) then { ["GetLastCarrierName"] call SELF } else { TEXT_CARRIER };

		_map drawIcon ["A3\Modules_F_MP_Mark\Objectives\images\CarrierBackground.paa", _color, _position, 64, 64, 0, "", 0, 0.08, "PuristaLight", "center"];
		_map drawIcon ["A3\Modules_F_MP_Mark\Objectives\images\CarrierIcon.paa", [1,1,1,1], _position, 64, 64, 0, "", 0, 0.08, "PuristaLight", "center"];
	};
};