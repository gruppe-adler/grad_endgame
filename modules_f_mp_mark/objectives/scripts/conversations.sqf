private ["_type", "_side"];
_type 	= _this param [0, "", [""]];
_side	= _this param [1, SIDEUNKNOWN, [SIDEUNKNOWN]];

private ["_speaker", "_code"];
_speaker = switch (_side) do
{
	case WEST : 	{ [BIS_west_speaker, BIS_west_speaker, BIS_west_speaker] };
	case default 	{ [BIS_east_speaker, BIS_east_speaker, BIS_east_speaker] };
};
_code = switch (_side) do
{
	case WEST : 	{ "BHQ" };
	case default 	{ missionNamespace getVariable ["BIS_hvt_hqSpeaker", "OHQ"] };
};
switch (_type) do
{
	case "Wait" :
	{
		["01_Wait", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_01_Wait_%1_0", _code], format ["MP_End_Game_Systems_01_Wait_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "Start" :
	{
		["03_Start", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_03_Start_%1_0", _code], format ["MP_End_Game_Systems_03_Start_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "EndGood" :
	{
		["05_EndGood", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_05_EndGood_%1_0", _code], format ["MP_End_Game_Systems_05_EndGood_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "EndBad" :
	{
		["07_EndBad", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_07_EndBad_%1_0", _code], format ["MP_End_Game_Systems_07_EndBad_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "FobControl" :
	{
		["10_FobControl", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_10_FobControl_%1_0", _code], format ["MP_End_Game_Systems_10_FobControl_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "IntelRetrieved" :
	{
		["15_IntelRetrieved", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_15_IntelRetrieved_%1_0", _code], format ["MP_End_Game_Systems_15_IntelRetrieved_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "IntelWanted" :
	{
		["17_IntelWanted", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_17_IntelWanted_%1_0", _code], format ["MP_End_Game_Systems_17_IntelWanted_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "IntelRevealed" :
	{
		["18_IntelRevealed", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_18_IntelRevealed_%1_0", _code], format ["MP_End_Game_Systems_18_IntelRevealed_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "IntelShouldDestroy" :
	{
		["20_IntelShouldDestroy", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_20_IntelShouldDestroy_%1_0", _code], format ["MP_End_Game_Systems_20_IntelShouldDestroy_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "EndGameStart" :
	{
		["25_EndGameStart", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_25_EndGameStart_%1_0", _code], format ["MP_End_Game_Systems_25_EndGameStart_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "PickupSchematicsFirst" :
	{
		["30_PickupSchematicsFirst", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_30_PickupSchematicsFirst_%1_0", _code], format ["MP_End_Game_Systems_30_PickupSchematicsFirst_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "PreventUploadFirst" :
	{
		["35_PreventUpload", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_35_PreventUpload_%1_0", _code], format ["MP_End_Game_Systems_35_PreventUpload_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "PickupSchematics" :
	{
		["40_PickupSchematics", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_40_PickupSchematics_%1_0", _code], format ["MP_End_Game_Systems_40_PickupSchematics_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "PreventUpload" :
	{
		["45_PreventUpload", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_45_PreventUpload_%1_0", _code], format ["MP_End_Game_Systems_45_PreventUpload_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "Upload" :
	{
		["50_Upload", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_50_Upload_%1_0", _code], format ["MP_End_Game_Systems_50_Upload_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "EnemyHasSchematics" :
	{
		["55_EnemyHasSchematics", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_55_EnemyHasSchematics_%1_0", _code], format ["MP_End_Game_Systems_55_EnemyHasSchematics_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "SchematicsFound" :
	{
		["60_SchematicsFound", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_60_SchematicsFound_%1_0", _code], format ["MP_End_Game_Systems_60_SchematicsFound_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "NoRespawn" :
	{
		["65_NoRespawn", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_65_NoRespawn_%1_0", _code], format ["MP_End_Game_Systems_65_NoRespawn_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "AquireIntel" :
	{
		["70_AquireIntel", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_70_AquireIntel_%1_0", _code], format ["MP_End_Game_Systems_70_AquireIntel_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "IntelAquired" :
	{
		["75_IntelAquired", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_75_IntelAquired_%1_0", _code], format ["MP_End_Game_Systems_75_IntelAquired_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "SchematicsDropped" :
	{
		["80_SchematicsDropped", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_80_SchematicsDropped_%1_0", _code], format ["MP_End_Game_Systems_80_SchematicsDropped_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};

	case "SchematicsSecured" :
	{
		["85_SchematicsSecured", "MP_End_Game_Systems", [format ["MP_End_Game_Systems_85_SchematicsSecured_%1_0", _code], format ["MP_End_Game_Systems_85_SchematicsSecured_%1_0", _code]], "SIDE", nil, _speaker, nil, false] spawn bis_fnc_kbTell;
	};
};