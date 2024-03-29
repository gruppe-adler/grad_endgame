#include "\z\ace\addons\main\script_macros.hpp"

#define KPATCH(PVAR) DOUBLES(PREFIX,PVAR)
#define QKPATCH(PVAR) QUOTE(KPATCH(PVAR))
#define MAINPATCH KPATCH(main)
#define QMAINPATCH QUOTE(MAINPATCH)
#define QCOMPONENT QUOTE(COMPONENT)
#define QADDON QUOTE(ADDON)
#define AUTHOR Gruppe Adler
#define QAUTHOR QUOTE(AUTHOR)

// Endgame macros
#define SELF 							EFUNC(initialize,moduleHvtObjectivesInstance)
#define OBJECTIVE 						EFUNC(initialize,moduleHvtObjective)
#define VAR_INITIALIZED 				QGVAR(initialized)
#define VAR_LOGIC						QGVAR(logic)
#define VAR_SIDES_WITH_FOB				QGVAR(sidesWithFob)
#define VAR_ENDGAME_OBJECTIVE			QGVAR(endGameObjective)
#define VAR_ENDGAME_THRESHOLD			QGVAR(endGameThreshold)
#define VAR_RANDOMISERS					QGVAR(randomisers)
#define VAR_OBJECTIVES					QGVAR(objectives)
#define VAR_OBJECTIVES_ORDERED			QGVAR(objectivesOrdered)
#define VAR_COMPLETED_OBJECTIVES		QGVAR(completedObjectives)
#define VAR_SIDES						QGVAR(sides)
#define VAR_BASES						QGVAR(bases)
#define VAR_BASE_SIDE					QGVAR(baseSide)
#define VAR_MISSION_FLOW_FSM			QGVAR(fsm)
#define CLASS_OBJECTIVE_RANDOMISER		QEGVAR(initialize,ModuleHvtObjectiveRandomiser)
#define CLASS_SIMPLE_OBJECTIVE			QEGVAR(initialize,ModuleHvtSimpleObjective)
#define CLASS_STARTGAME_OBJECTIVE		QEGVAR(initialize,ModuleHvtStartGameObjective)
#define CLASS_ENDGAME_OBJECTIVE			QEGVAR(initialize,ModuleHvtEndGameObjective)

// Objective variables
#define VAR_DOWNLOAD_OBJECT	            "DownloadObject"
#define VAR_DOWNLOAD_RADIUS	            "DownloadRadius"
#define VAR_UPLOAD_RADIUS	            "UploadRadius"
#define VAR_TASK_DESCRIPTION	        "TaskDescription"
#define VAR_SUCCEED_RADIUS	            "SucceedRadius"
#define VAR_TIME_LIMIT		            "TimeLimit"
#define VAR_PICKUP_OBJECTS	            "PickupObjects"
#define VAR_UPLOAD_OBJECTS	            "UploadObjects"
#define VAR_IMEDIATE_DOWNLOAD	        "ImmediateDownload"