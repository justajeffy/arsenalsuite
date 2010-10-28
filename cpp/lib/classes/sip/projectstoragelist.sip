


%MappedType MappedProjectStorageList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectstoragelist.h"
#include "projectstoragetable.h"
#define MappedProjectStorageList ProjectStorageList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ProjectStorageSchema::instance() );
%End
};

class ProjectStorageList : RecordList
{
%TypeHeaderCode
#include <projectstoragelist.h>
#include "project.h"
#include "host.h"
#include "pathsynctarget.h"

%End
public:
	ProjectStorageList();
	ProjectStorageList( const RecordList &, Table * t = 0 );
	ProjectStorageList( const ProjectStorageList & );
	ProjectStorageList( const Record &, Table * t = 0 );
	
	~ProjectStorageList();

//	void insert( ProjectStorageIter, const ProjectStorage & );

//	ProjectStorageIter at( uint );

//	ProjectStorageIter find( const Record & );

//	ProjectStorageIter remove( const ProjectStorageIter & );

	int remove( const Record & );
	
	int remove();
	
	//ProjectStorageIter begin();

	//ProjectStorageIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedProjectStorageList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedProjectStorageList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedProjectStorageList sorted( const QString & c, bool a = true ) const;

	MappedProjectStorageList unique() const;
	MappedProjectStorageList reversed() const;
	MappedProjectStorageList reloaded() const;

	QStringList names() const;
	MappedProjectStorageList & setNames( const QString & );
	MappedProjectList projects() const;
	MappedProjectStorageList & setProjects( const Project & );
	MappedHostList hosts() const;
	MappedProjectStorageList & setHosts( const Host & );
	QStringList locations() const;
	MappedProjectStorageList & setLocations( const QString & );
	QList<bool> defaultStorages() const;
	MappedProjectStorageList & setDefaultStorages( const bool & );
	MappedPathSyncTargetList pathSyncTargets();


};


