private ["_objective", "_side"];
_objective 	= _this param [0, objNull, [objNull]];
_side		= _this param [1, sideUnknown, [sideUnknown]];

if (!isNull _objective && _side != sideUnknown) then
{
	private ["_text", "_type", "_color"];
	_text 	= toUpper (localize "STR_A3_EndGame_Tasks_Waypoint_Fob");
	_type	= "b_unknown";
	_color 	= switch (_side) do
	{
		case WEST : 		{ "ColorWEST" };
		case EAST : 		{ "ColorEAST" };
		case RESISTANCE : 	{ "ColorGUER" };
		case DEFAULT 		{ "ColorCIV" };
	};

	private "_marker";
	_marker = createMarkerLocal [format["BIS_fobMarker_%1", _side], position _objective];

	_marker setMarkerTextLocal _text;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerColorLocal _color;
	_marker setMarkerAlphaLocal 0.6;
	_marker setMarkerSizeLocal [1.5, 1.5];
};