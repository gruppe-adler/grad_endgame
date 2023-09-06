#define MAX_RATE		0.6
#define MAX_DISTANCE 		20.0
#define MAX_DISTANCE_HELPER	10.0
#define VAR_DOWNLOADABLE	"BIS_hvt_downloadableObject"
#define VAR_DOWNLOADED_BY	"BIS_hvt_intelDownloadedBy"
#define VAR_DOWNLOADING		"BIS_download_side"
#define VAR_KIND 		"BIS_moduleHvtObjective_kind"
#define VAR_IMEDIATE_DOWNLOAD	"ImmediateDownload"
#define VAR_DOWNLOAD_RADIUS	"DownloadRadius"
#define VAR_UPLOAD_RADIUS	"UploadRadius"

#define INSTANCE 				{ _this call (missionNamespace getVariable ["BIS_fnc_moduleHvtObjectivesInstance", {}]) }
#define OBJECTIVE				{ _this call (missionNamespace getVariable ["BIS_fnc_moduleHvtObjective", {}]) }
#define CARRIER					{ _this call (missionNamespace getVariable ["bis_fnc_moduleMPTypeHvt_carrier", {}]) }
#define ICON_BASE				"a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\Defend_ca.paa"
#define ICON_DOWNLOAD			"a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\Intel_ca.paa"
#define ICON_SCHEMATICS			"a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\Search_ca.paa"
#define ICON_UPLOAD				"a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\Attack_ca.paa"
#define FADE_BACKGROUND			0.5
#define FADE_ICON				0.5
#define VAR_DOWNLOADS			"initPlayerSpectator_downloads"
#define VAR_OBJECTIVE_OWNER		"BIS_moduleHvtObjective_objectiveOwner"
#define VAR_OBJECTIVE_LETTER	"BIS_moduleHvtObjective_objectiveLetter"