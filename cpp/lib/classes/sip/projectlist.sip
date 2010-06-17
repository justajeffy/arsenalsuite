


%MappedType MappedProjectList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectlist.h"
#include "projecttable.h"
#define MappedProjectList ProjectList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ProjectSchema::instance() );
%End
};

class ProjectList : ElementList
{
%TypeHeaderCode
#include <projectlist.h>
#include "client.h"
#include "projectstatus.h"
#include "projectstorage.h"

%End
public:
	ProjectList();
	ProjectList( const RecordList &, Table * t = 0 );
	ProjectList( const ProjectList & );
	ProjectList( const Record &, Table * t = 0 );
	
	~ProjectList();

//	void insert( ProjectIter, const Project & );

//	ProjectIter at( uint );

//	ProjectIter find( const Record & );

//	ProjectIter remove( const ProjectIter & );

	int remove( const Record & );
	
	int remove();
	
	//ProjectIter begin();

	//ProjectIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedProjectList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedProjectList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedProjectList sorted( const QString & c, bool a = true ) const;

	MappedProjectList unique() const;
	MappedProjectList reversed() const;
	MappedProjectList reloaded() const;

	QStringList compOutputDrives() const;
	MappedProjectList & setCompOutputDrives( const QString & );
	QList<QDate> dueDates() const;
	MappedProjectList & setDueDates( const QDate & );
	QStringList filetypes() const;
	MappedProjectList & setFiletypes( const QString & );
	MappedClientList clients() const;
	MappedProjectList & setClients( const Client & );
	QStringList noteses() const;
	MappedProjectList & setNoteses( const QString & );
	QStringList renderOutputDrives() const;
	MappedProjectList & setRenderOutputDrives( const QString & );
	QStringList scripts() const;
	MappedProjectList & setScripts( const QString & );
	QStringList shortNames() const;
	MappedProjectList & setShortNames( const QString & );
	QStringList wipDrives() const;
	MappedProjectList & setWipDrives( const QString & );
	QList<uint> projectNumbers() const;
	MappedProjectList & setProjectNumbers( const uint & );
	QList<uint> frameses() const;
	MappedProjectList & setFrameses( const uint & );
	QList<uint> ndas() const;
	MappedProjectList & setNdas( const uint & );
	QList<float> dayRates() const;
	MappedProjectList & setDayRates( const float & );
	QList<uint> useFileCreations() const;
	MappedProjectList & setUseFileCreations( const uint & );
	QStringList dailyDrives() const;
	MappedProjectList & setDailyDrives( const QString & );
	QList<QDateTime> lastScanned() const;
	MappedProjectList & setLastScanned( const QDateTime & );
	MappedProjectStatusList projectStatuses() const;
	MappedProjectList & setProjectStatuses( const ProjectStatus & );
	QList<float> assburnerWeights() const;
	MappedProjectList & setAssburnerWeights( const float & );
	MappedProjectStorageList projectStorages();


};


