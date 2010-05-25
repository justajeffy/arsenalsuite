
#include "database.h"
#include "connection.h"
#include "classes.h"
#include "abdownloadstattable.h"
#include "annotationtable.h"
#include "assettable.h"
#include "assetgrouptable.h"
#include "assetpropertytable.h"
#include "assettemplatetable.h"
#include "calendartable.h"
#include "calendarcategorytable.h"
#include "checklistitemtable.h"
#include "checkliststatustable.h"
#include "clienttable.h"
#include "configtable.h"
#include "deliverytable.h"
#include "deliveryelementtable.h"
#include "diskimagetable.h"
#include "dynamichostgrouptable.h"
#include "elementtable.h"
#include "elementdeptable.h"
#include "elementstatustable.h"
#include "threadtable.h"
#include "elementtypetable.h"
#include "elementusertable.h"
#include "employeetable.h"
#include "filetrackertable.h"
#include "filetrackerdeptable.h"
#include "graphtable.h"
#include "graphdstable.h"
#include "graphpagetable.h"
#include "graphrelationshiptable.h"
#include "gridtemplatetable.h"
#include "gridtemplateitemtable.h"
#include "groupmappingtable.h"
#include "grouptable.h"
#include "gruntscripttable.h"
#include "historytable.h"
#include "hosttable.h"
#include "hostgrouptable.h"
#include "hostgroupitemtable.h"
#include "hosthistorytable.h"
#include "hostinterfacetable.h"
#include "hostinterfacetypetable.h"
#include "hostloadtable.h"
#include "hostmappingtable.h"
#include "hostservicetable.h"
#include "hostsoftwaretable.h"
#include "hoststatustable.h"
#include "jobtable.h"
#include "job3delighttable.h"
#include "jobaftereffectstable.h"
#include "jobaftereffects7table.h"
#include "jobaftereffects8table.h"
#include "jobassignmenttable.h"
#include "jobassignmentstatustable.h"
#include "jobautodeskburntable.h"
#include "jobbatchtable.h"
#include "jobcannedbatchtable.h"
#include "jobcinema4dtable.h"
#include "jobcommandhistorytable.h"
#include "jobdeptable.h"
#include "joberrortable.h"
#include "joberrorhandlertable.h"
#include "joberrorhandlerscripttable.h"
#include "jobfusiontable.h"
#include "jobfusionvideomakertable.h"
#include "jobhistorytable.h"
#include "jobhistorytypetable.h"
#include "jobhoudinisim10table.h"
#include "jobmantra100table.h"
#include "jobmaxtable.h"
#include "jobmax10table.h"
#include "jobmax2009table.h"
#include "jobmax5table.h"
#include "jobmax6table.h"
#include "jobmax7table.h"
#include "jobmax8table.h"
#include "jobmax9table.h"
#include "jobmaxscripttable.h"
#include "jobmayatable.h"
#include "jobmaya2008table.h"
#include "jobmaya2009table.h"
#include "jobmaya2011table.h"
#include "jobmaya7table.h"
#include "jobmaya8table.h"
#include "jobmaya85table.h"
#include "jobmentalray2009table.h"
#include "jobmentalray2011table.h"
#include "jobmentalray7table.h"
#include "jobmentalray8table.h"
#include "jobmentalray85table.h"
#include "jobnuke51table.h"
#include "jobnuke52table.h"
#include "joboutputtable.h"
#include "jobrealflowtable.h"
#include "jobrendermantable.h"
#include "jobribgentable.h"
#include "jobservicetable.h"
#include "jobshaketable.h"
#include "jobstattable.h"
#include "jobstatustable.h"
#include "jobsynctable.h"
#include "jobtasktable.h"
#include "jobtaskassignmenttable.h"
#include "jobtypetable.h"
#include "jobtypemappingtable.h"
#include "jobxsitable.h"
#include "jobxsiscripttable.h"
#include "licensetable.h"
#include "locationtable.h"
#include "mappingtable.h"
#include "mappingtypetable.h"
#include "notificationtable.h"
#include "notificationdestinationtable.h"
#include "notificationmethodtable.h"
#include "notificationroutetable.h"
#include "pathsynctargettable.h"
#include "pathtemplatetable.h"
#include "pathtrackertable.h"
#include "permissiontable.h"
#include "projecttable.h"
#include "resolutiontable.h"
#include "projectstatustable.h"
#include "projectstoragetable.h"
#include "rangefiletrackertable.h"
#include "scheduletable.h"
#include "serverfileactiontable.h"
#include "serverfileactionstatustable.h"
#include "serverfileactiontypetable.h"
#include "servicetable.h"
#include "shottable.h"
#include "shotgrouptable.h"
#include "softwaretable.h"
#include "statussettable.h"
#include "syslogtable.h"
#include "syslogrealmtable.h"
#include "syslogseveritytable.h"
#include "tasktable.h"
#include "threadnotifytable.h"
#include "thumbnailtable.h"
#include "timesheettable.h"
#include "assettypetable.h"
#include "userelementtable.h"
#include "usermappingtable.h"
#include "userroletable.h"
#include "usertable.h"
#include "usergrouptable.h"
#include "versionfiletrackertable.h"


CLASSES_EXPORT void classes_loader() {
	static bool classesLoaded = false;
	if( classesLoaded )
		return;
	classesLoaded = true;
	AbDownloadStatSchema::instance();
	AnnotationSchema::instance();
	AssetSchema::instance();
	AssetGroupSchema::instance();
	AssetPropertySchema::instance();
	AssetTemplateSchema::instance();
	CalendarSchema::instance();
	CalendarCategorySchema::instance();
	CheckListItemSchema::instance();
	CheckListStatusSchema::instance();
	ClientSchema::instance();
	ConfigSchema::instance();
	DeliverySchema::instance();
	DeliveryElementSchema::instance();
	DiskImageSchema::instance();
	DynamicHostGroupSchema::instance();
	ElementSchema::instance();
	ElementDepSchema::instance();
	ElementStatusSchema::instance();
	ThreadSchema::instance();
	ElementTypeSchema::instance();
	ElementUserSchema::instance();
	EmployeeSchema::instance();
	FileTrackerSchema::instance();
	FileTrackerDepSchema::instance();
	GraphSchema::instance();
	GraphDsSchema::instance();
	GraphPageSchema::instance();
	GraphRelationshipSchema::instance();
	GridTemplateSchema::instance();
	GridTemplateItemSchema::instance();
	GroupMappingSchema::instance();
	GroupSchema::instance();
	GruntScriptSchema::instance();
	HistorySchema::instance();
	HostSchema::instance();
	HostGroupSchema::instance();
	HostGroupItemSchema::instance();
	HostHistorySchema::instance();
	HostInterfaceSchema::instance();
	HostInterfaceTypeSchema::instance();
	HostLoadSchema::instance();
	HostMappingSchema::instance();
	HostServiceSchema::instance();
	HostSoftwareSchema::instance();
	HostStatusSchema::instance();
	JobSchema::instance();
	Job3DelightSchema::instance();
	JobAfterEffectsSchema::instance();
	JobAfterEffects7Schema::instance();
	JobAfterEffects8Schema::instance();
	JobAssignmentSchema::instance();
	JobAssignmentStatusSchema::instance();
	JobAutodeskBurnSchema::instance();
	JobBatchSchema::instance();
	JobCannedBatchSchema::instance();
	JobCinema4DSchema::instance();
	JobCommandHistorySchema::instance();
	JobDepSchema::instance();
	JobErrorSchema::instance();
	JobErrorHandlerSchema::instance();
	JobErrorHandlerScriptSchema::instance();
	JobFusionSchema::instance();
	JobFusionVideoMakerSchema::instance();
	JobHistorySchema::instance();
	JobHistoryTypeSchema::instance();
	JobHoudiniSim10Schema::instance();
	JobMantra100Schema::instance();
	JobMaxSchema::instance();
	JobMax10Schema::instance();
	JobMax2009Schema::instance();
	JobMax5Schema::instance();
	JobMax6Schema::instance();
	JobMax7Schema::instance();
	JobMax8Schema::instance();
	JobMax9Schema::instance();
	JobMaxScriptSchema::instance();
	JobMayaSchema::instance();
	JobMaya2008Schema::instance();
	JobMaya2009Schema::instance();
	JobMaya2011Schema::instance();
	JobMaya7Schema::instance();
	JobMaya8Schema::instance();
	JobMaya85Schema::instance();
	JobMentalRay2009Schema::instance();
	JobMentalRay2011Schema::instance();
	JobMentalRay7Schema::instance();
	JobMentalRay8Schema::instance();
	JobMentalRay85Schema::instance();
	JobNuke51Schema::instance();
	JobNuke52Schema::instance();
	JobOutputSchema::instance();
	JobRealFlowSchema::instance();
	JobRenderManSchema::instance();
	JobRibGenSchema::instance();
	JobServiceSchema::instance();
	JobShakeSchema::instance();
	JobStatSchema::instance();
	JobStatusSchema::instance();
	JobSyncSchema::instance();
	JobTaskSchema::instance();
	JobTaskAssignmentSchema::instance();
	JobTypeSchema::instance();
	JobTypeMappingSchema::instance();
	JobXSISchema::instance();
	JobXSIScriptSchema::instance();
	LicenseSchema::instance();
	LocationSchema::instance();
	MappingSchema::instance();
	MappingTypeSchema::instance();
	NotificationSchema::instance();
	NotificationDestinationSchema::instance();
	NotificationMethodSchema::instance();
	NotificationRouteSchema::instance();
	PathSyncTargetSchema::instance();
	PathTemplateSchema::instance();
	PathTrackerSchema::instance();
	PermissionSchema::instance();
	ProjectSchema::instance();
	ResolutionSchema::instance();
	ProjectStatusSchema::instance();
	ProjectStorageSchema::instance();
	RangeFileTrackerSchema::instance();
	ScheduleSchema::instance();
	ServerFileActionSchema::instance();
	ServerFileActionStatusSchema::instance();
	ServerFileActionTypeSchema::instance();
	ServiceSchema::instance();
	ShotSchema::instance();
	ShotGroupSchema::instance();
	SoftwareSchema::instance();
	StatusSetSchema::instance();
	SysLogSchema::instance();
	SysLogRealmSchema::instance();
	SysLogSeveritySchema::instance();
	TaskSchema::instance();
	ThreadNotifySchema::instance();
	ThumbnailSchema::instance();
	TimeSheetSchema::instance();
	AssetTypeSchema::instance();
	UserElementSchema::instance();
	UserMappingSchema::instance();
	UserRoleSchema::instance();
	UserSchema::instance();
	UserGroupSchema::instance();
	VersionFileTrackerSchema::instance();
	Database::setCurrent( new Database( classesSchema(), Connection::createFromIni( config(), "Database" ) ) );
}
