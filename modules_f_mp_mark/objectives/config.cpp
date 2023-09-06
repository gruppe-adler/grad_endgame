class CfgPatches
{
	class A3_Modules_F_MP_Mark_Objectives
	{
		addonRootClass="A3_Modules_F_MP_Mark";
		requiredAddons[]=
		{
			"A3_Modules_F_MP_Mark"
		};
		requiredVersion=0.1;
		units[]={};
		weapons[]={};
	};
};
class CfgSounds
{
	class Beep_Target
	{
		name="$STR_A3_CfgSounds_Beep_Target0";
		sound[]=
		{
			"\a3\sounds_f\sfx\beep_target.wss",
			0.34999999,
			1
		};
		titles[]={};
	};
	class ZoomIn
	{
		name="$STR_A3_CfgSounds_ZoomIn0";
		sound[]=
		{
			"\a3\sounds_f\sfx\zoomin.wss",
			0.25,
			1
		};
		titles[]={};
	};
	class ZoomOut
	{
		name="$STR_A3_CfgSounds_ZoomOut0";
		sound[]=
		{
			"\a3\sounds_f\sfx\zoomout.wss",
			0.25,
			1
		};
		titles[]={};
	};
};
class CfgHvtObjectives
{
	class Simple
	{
		isIndependent=0;
		kind="Simple";
		fsmPath="a3\Modules_F_MP_Mark\Objectives\tasks\MiddleGame.fsm";
	};
	class StartGame: Simple
	{
		isIndependent=1;
		kind="StartGame";
		fsmPath="a3\Modules_F_MP_Mark\Objectives\tasks\StartGame.fsm";
	};
	class EndGame: Simple
	{
		isIndependent=1;
		kind="EndGame";
		fsmPath="a3\Modules_F_MP_Mark\Objectives\tasks\EndGame.fsm";
	};
};
class CfgDebriefing
{
	class PRE_WINNER
	{
		title="$STR_A3_EndGame_Debriefing_Victory";
		description="$STR_A3_EndGame_Debriefing_EnemiesDead";
	};
	class PRE_LOOSER
	{
		title="$STR_A3_EndGame_Debriefing_Defeat";
		description="$STR_A3_EndGame_Debriefing_PlayersDead";
	};
	class AMAZING_WINNER
	{
		title="$STR_A3_EndGame_Debriefing_Victory";
		description="$STR_A3_EndGame_Debriefing_EnemyDecimated";
	};
	class AMAZING_LOOSER
	{
		title="$STR_A3_EndGame_Debriefing_Defeat";
		description="$STR_A3_EndGame_Debriefing_PlayersDecimated";
	};
	class CARRIER_WINNER
	{
		title="$STR_A3_EndGame_Debriefing_Victory";
		description="$STR_A3_EndGame_Debriefing_CarrierWinner";
	};
	class CARRIER_LOOSER
	{
		title="$STR_A3_EndGame_Debriefing_Defeat";
		description="$STR_A3_EndGame_Debriefing_CarrierLooser";
	};
	class SCHEMATICS_WINNER
	{
		title="$STR_A3_EndGame_Debriefing_Victory";
		description="$STR_A3_endgame_debriefing_schematicsDestroyed";
	};
	class SCHEMATICS_LOOSER
	{
		title="$STR_A3_EndGame_Debriefing_Defeat";
		description="$STR_A3_endgame_debriefing_selfDestroyedSchematics";
	};
	class WINNER
	{
		title="$STR_A3_EndGame_Debriefing_Victory";
		description="$STR_A3_EndGame_Debriefing_TeamWon";
	};
	class LOOSER
	{
		title="$STR_A3_EndGame_Debriefing_Defeat";
		description="$STR_A3_EndGame_Debriefing_TeamLost";
	};
	class DRAW
	{
		title="$STR_A3_EndGame_Debriefing_Draw";
		description="$STR_A3_EndGame_Debriefing_TeamDraw";
	};
	class SPECTATOR_DRAW
	{
		title="$STR_A3_endgame_debriefing_spectator";
		subtitle="$STR_A3_Subtitle_Draw";
		description="$STR_A3_Debriefing_Draw";
	};
	class SPECTATOR_WEST
	{
		title="$STR_A3_endgame_debriefing_spectator";
		subtitle="$STR_A3_Subtitle_Blufor";
		description="$STR_A3_Debriefing_Blufor";
	};
	class SPECTATOR_EAST
	{
		title="$STR_A3_endgame_debriefing_spectator";
		subtitle="$STR_A3_Subtitle_Opfor";
		description="$STR_A3_Debriefing_Opfor";
	};
};
