private "_isSpectator";
_isSpectator = player isKindOf "VirtualSpectator_F";

if (!_isSpectator) then
{
	private ["_icon", "_rules", "_tips", "_enemy", "_aaf", "_enemyFaction"];
	_icon		= gettext (configfile >> "cfgmpgametypes" >> "zsc" >> "icon");
	_rules 		= format[localize "STR_A3_EndGame_Rules", _icon];
	_tips 		= format [localize "STR_A3_EndGame_Tips", _icon];
	_enemy		= localize "STR_A3_MP_Marksmen_01_Situation";
	_aaf		= localize "STR_A3_cfgfactionclasses_ind_f0";
	_enemyFaction 	= "";

	_enemyFaction = if (side group player == WEST) then
	{
		localize "STR_A3_cfgfactionclasses_opf_f0";
	}
	else
	{
		localize "STR_A3_cfgfactionclasses_blu_f0";
	};

	player createDiaryRecord ["Diary", [localize "STR_A3_Diary_Situation_title", format [_enemy, _enemyFaction, _aaf]]];
	player creatediarysubject ["BIS_EndGame", localize "STR_A3_EndGame_RulesTips"];
	player creatediaryrecord ["BIS_EndGame",[localize "str_a3_firingdrills_tips0", _tips]];
	player creatediaryrecord ["BIS_EndGame",[localize "str_a3_firing_drills_diary_rec2_title", _rules]];
}
else
{
	private ["_o", "_text"];
	_o 	= "<br /><br /><img image='\a3\Ui_f\data\IGUI\RscIngameUI\RscHint\indent_gr.paa' width='16' /> ";
	_text 	= format ["<img image='%2' height='32' /><font size='32' face='PuristaLight'> %1</font>", localize "STR_A3_Spectator_DisplayName", "\a3\UI_F_Exp_A\Data\Displays\RscDisplayEGSpectator\Follow.paa"];

	_text = _text + _o + localize "STR_A3_Spectator_Briefing_VirtualSpectator";
	_text = _text + _o + localize "STR_A3_Spectator_Briefing_FreeCamera";
	_text = _text + _o + localize "STR_A3_Spectator_Briefing_3ppCamera";
	_text = _text + _o + localize "STR_A3_Spectator_Briefing_1ppCamera";
	_text = _text + _o + localize "STR_A3_Spectator_Briefing_Map";

	player creatediarysubject [localize "STR_A3_Spectator_DisplayName", localize "STR_A3_rscdisplaywelcome_expa_parb_list3_title"];
	player creatediaryrecord [localize "STR_A3_Spectator_DisplayName",[localize "STR_A3_Spectator_DisplayName", _text]];
};