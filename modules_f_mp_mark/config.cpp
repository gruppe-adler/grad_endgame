class CfgPatches
{
	class A3_Modules_F_MP_Mark
	{
		author="$STR_A3_Bohemia_Interactive";
		name="Arma 3 Marksmen (Multiplayer) - Scripted Modules";
		url="https://www.arma3.com";
		requiredAddons[]=
		{
			"A3_Data_F_Mark"
		};
		requiredVersion=0.1;
		units[]=
		{
			"ModuleHvtEndGameObjective_F",
			"ModuleHvtObjectiveRandomiser_F",
			"ModuleHvtObjectivesInstance_F",
			"ModuleHvtSimpleObjective_F",
			"ModuleHvtStartGameObjective_F"
		};
		weapons[]={};
	};
};
class CfgFunctions
{
	class A3_Modules_F_Mark
	{
		tag="bis";
		class Objectives
		{
			file="a3\modules_f_mp_mark\objectives\functions";
			class moduleHvtObjectives
			{
			};
			class moduleHvtObjectivesInstance
			{
			};
			class moduleHvtObjective
			{
			};
			class moduleHvtInit
			{
				file="a3\modules_f_mp_mark\objectives\scripts\init.sqf";
			};
			class downloadObject_canSee_module
			{
			};
			class downloadObject_canUse_module
			{
			};
			class downloadObject_nearObject_module
			{
			};
			class downloadObject_onSucceeded_module
			{
			};
			class endGameSpectator_onCarrierPickupInfoChanged
			{
			};
			class endGameSpectator_onSideStageChanged
			{
			};
			class endGameSpectator_onStageChanged
			{
			};
			class endGameSpectator_onUploadStateChanged
			{
			};
			class endGameSpectator_updateSideIntelTask
			{
			};
		};
	};
};
class CfgAddons
{
	class PreloadAddons
	{
		class A3_MP_Mark
		{
			list[]=
			{
				"A3_Dubbing_F_MP_Mark",
				"A3_Functions_F_MP_Mark",
				"A3_LanguageMissions_F_MP_Mark",
				"A3_Language_F_MP_Mark",
				"A3_Missions_F_MP_Mark",
				"A3_Missions_F_MP_Mark_Data",
				"A3_Modules_F_MP_Mark",
				"A3_Modules_F_MP_Mark_Objectives",
				"A3_Ui_F_MP_Mark"
			};
		};
	};
};
class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class ModuleDescription
		{
			class AnyBrain;
			class AnyAI;
			class Anything;
		};
	};
	class ModuleHvtObjectivesInstance_F: Module_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleHvtObjectivesInstance_F";
		scope=2;
		isGlobal=0;
		isTriggerActivated=0;
		displayName="$STR_A3_EndGame_ModuleHvtObjectivesInstance_Title";
		function="bis_fnc_moduleHvtObjectives";
		functionPriority=12;
		icon="\a3\Modules_F\Data\iconStrategicMapImage_ca.paa";
		isDisposable=0;
		category="Objectives";
		class Arguments
		{
			class EndGameThreshold
			{
				displayName="$STR_A3_EndGame_ModuleHvtObjectivesInstance_Title_Threshold";
				description="$STR_A3_EndGame_ModuleHvtObjectivesInstance_Description_Threshold";
				typeName="NUMBER";
				defaultValue=3;
			};
			class WarmupDelay
			{
				displayName="$STR_A3_EndGame_ModuleHvtObjectivesInstance_Title_WarmupDelay";
				description="$STR_A3_EndGame_ModuleHvtObjectivesInstance_Description_WarmupDelay";
				typeName="NUMBER";
				defaultValue=45;
			};
			class EndWhenSideHasNoFob
			{
				displayName="$STR_A3_endgame_modulehvtobjectivesinstance_title_endWhenSideHasNoFob";
				description="$STR_A3_endgame_modulehvtobjectivesinstance_description_endWhenSideHasNoFob";
				typeName="BOOL";
				defaultValue=1;
			};
			class PhaseOneMusic
			{
				displayName="$STR_A3_endgame_modulehvtobjectivesinstance_title_music1";
				description="$STR_A3_endgame_modulehvtobjectivesinstance_description_music1";
				typeName="STRING";
				defaultValue="";
			};
			class PhaseTwoMusic
			{
				displayName="$STR_A3_endgame_modulehvtobjectivesinstance_title_music2";
				description="$STR_A3_endgame_modulehvtobjectivesinstance_description_music2";
				typeName="STRING";
				defaultValue="";
			};
			class PhaseThreeMusic
			{
				displayName="$STR_A3_endgame_modulehvtobjectivesinstance_title_music3";
				description="$STR_A3_endgame_modulehvtobjectivesinstance_description_music3";
				typeName="STRING";
				defaultValue="";
			};
		};
	};
	class ModuleHvtSimpleObjective_F: Module_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleHvtSimpleObjective_F";
		scope=2;
		isGlobal=0;
		isTriggerActivated=0;
		displayName="$STR_A3_EndGame_ModuleHvtSimpleObjective_Title";
		function="bis_fnc_moduleHvtObjectives";
		functionPriority=12;
		icon="\a3\Modules_F\Data\iconSector_ca.paa";
		isDisposable=0;
		category="Objectives";
		class Arguments
		{
			class DownloadObject
			{
				displayName="$STR_A3_EndGame_Simple_Title_DownloadObject";
				description="$STR_A3_EndGame_Simple_Description_DownloadObject";
				typeName="STRING";
				defaultValue="objNull";
			};
			class DownloadRadius
			{
				displayName="$STR_A3_EndGame_Simple_Title_DownloadRadius";
				description="$STR_A3_EndGame_Simple_Description_DownloadRadius";
				typeName="NUMBER";
				defaultValue="10";
			};
			class TaskDescription
			{
				displayName="$STR_A3_EndGame_Simple_Title_TaskDescription";
				description="$STR_A3_EndGame_Simple_Description_TaskDescription";
				typeName="STRING";
				defaultValue="";
			};
			class ImmediateDownload
			{
				displayName="$STR_A3_EndGame_Simple_Title_InstantDownload";
				description="$STR_A3_EndGame_Simple_Description_InstantDownload";
				typeName="BOOL";
				defaultValue=0;
			};
			class LinkedLayers
			{
				displayName="Linked Layers";
				description="Put here 3DEN layer names which are part of this objective, objects within these layers will be deleted in case layer is discarded because of randomization. Uses ARRAY format: [_layer1, _layer2].";
				typeName="STRING";
				defaultValue="[]";
			};
		};
	};
	class ModuleHvtStartGameObjective_F: Module_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleHvtStartGameObjective_F";
		scope=2;
		isGlobal=0;
		isTriggerActivated=0;
		displayName="$STR_A3_EndGame_ModuleHvtStartGameObjective_Title";
		function="bis_fnc_moduleHvtObjectives";
		functionPriority=12;
		icon="\a3\Modules_F\Data\iconSector_ca.paa";
		isDisposable=0;
		category="Objectives";
		class Arguments
		{
			class AttackingSide
			{
				displayName="$STR_A3_EndGame_Start_Title_AttackingSide";
				description="$STR_A3_EndGame_Start_Description_AttackingSide";
				typeName="STRING";
				class values
				{
					class WEST
					{
						name="$STR_WEST";
						value="WEST";
						default=1;
					};
					class EAST
					{
						name="$STR_EAST";
						value="EAST";
					};
				};
			};
			class SucceedRadius
			{
				displayName="$STR_A3_EndGame_Start_Title_SucceedRadius";
				description="$STR_A3_EndGame_Start_Description_SucceedRadius";
				typeName="NUMBER";
				defaultValue="150";
			};
			class RestrictionRadius
			{
				displayName="$STR_A3_EndGame_Start_Title_RestrictionRadius";
				description="$STR_A3_EndGame_Start_Description_RestrictionRadius";
				typeName="NUMBER";
				defaultValue="500";
			};
			class Speaker
			{
				displayName="$STR_A3_EndGame_Start_Title_Speaker";
				description="$STR_A3_EndGame_Start_Description_Speaker";
				typeName="STRING";
				defaultValue="objNull";
			};
			class LinkedLayers
			{
				displayName="Linked Layers";
				description="Put here 3DEN layer names which are part of this objective, objects within these layers will be deleted in case layer is discarded because of randomization. Uses ARRAY format: [_layer1, _layer2].";
				typeName="STRING";
				defaultValue="[]";
			};
		};
	};
	class ModuleHvtEndGameObjective_F: Module_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleHvtEndGameObjective_F";
		scope=2;
		isGlobal=0;
		isTriggerActivated=0;
		displayName="$STR_A3_EndGame_ModuleHvtEndGameObjective_Title";
		function="bis_fnc_moduleHvtObjectives";
		functionPriority=12;
		icon="\a3\Modules_F\Data\iconSector_ca.paa";
		isDisposable=0;
		category="Objectives";
		class Arguments
		{
			class TimeLimit
			{
				displayName="$STR_A3_EndGame_End_Title_TimeLimit";
				description="$STR_A3_EndGame_End_Description_TimeLimit";
				typeName="NUMBER";
				defaultValue="1200";
			};
			class PickupObjects
			{
				displayName="$STR_A3_EndGame_End_Title_PickupObjects";
				description="$STR_A3_EndGame_End_Description_PickupObjects";
				typeName="STRING";
				defaultValue="[]";
			};
			class UploadObjects
			{
				displayName="$STR_A3_EndGame_End_Title_UploadObjects";
				description="$STR_A3_EndGame_End_Description_UploadObjects";
				typeName="STRING";
				defaultValue="[]";
			};
			class UploadRadius
			{
				displayName="$STR_A3_EndGame_Simple_Title_UploadRadius";
				description="$STR_A3_EndGame_Simple_Description_UploadRadius";
				typeName="NUMBER";
				defaultValue="10";
			};
			class LinkedLayers
			{
				displayName="$STR_A3_EndGame_Simple_Description_Layer0";
				description="$STR_A3_EndGame_Simple_Description_Layer1";
				typeName="STRING";
				defaultValue="[]";
			};
		};
	};
	class ModuleHvtObjectiveRandomiser_F: Logic
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleHvtObjectiveRandomiser_F";
		displayName="$STR_A3_EndGame_ModuleHvtObjectiveRandomiser_Title";
		scope=2;
		vehicleClass="SystemMisc";
	};
};
class CfgNotifications
{
	class HVT_OnPickup
	{
		iconPicture="\a3\Ui_f\data\GUI\Cfg\Hints\Incapacitated_ca.paa";
		priority=100;
		duration=4;
		sound="defaultNotification";
		soundClose="defaultNotificationClose";
		title="$STR_A3_EndGame_Notifications_Title_Pickup";
		description="$STR_A3_EndGame_Notifications_Description_Pickup";
	};
	class HVT_OnDrop
	{
		iconPicture="\a3\Ui_f\data\GUI\Cfg\Hints\ActionMenu_ca.paa";
		priority=100;
		duration=4;
		sound="defaultNotification";
		soundClose="defaultNotificationClose";
		title="$STR_A3_EndGame_Notifications_Title_Drop";
		description="$STR_A3_EndGame_Notifications_Description_Drop";
	};
	class HVT_FobEstablished
	{
		iconPicture="A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\Attack_ca.paa";
		priority=100;
		duration=4;
		sound="defaultNotification";
		soundClose="defaultNotificationClose";
		title="$STR_A3_EndGame_Notifications_Title_Fob";
		description="$STR_A3_EndGame_Notifications_Description_Fob";
	};
};
