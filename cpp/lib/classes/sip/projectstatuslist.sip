


%MappedType MappedProjectStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectstatuslist.h"
#include "projectstatustable.h"
#define MappedProjectStatusList ProjectStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ProjectStatusSchema::instance() );
%End
};

class ProjectStatusList : RecordList
{
%TypeHeaderCode
#include <projectstatuslist.h>

%End
public:
	ProjectStatusList();
	ProjectStatusList( const RecordList &, Table * t = 0 );
	ProjectStatusList( const ProjectStatusList & );
	ProjectStatusList( const Record &, Table * t = 0 );
	
	~ProjectStatusList();

//	void insert( ProjectStatusIter, const ProjectStatus & );

//	ProjectStatusIter at( uint );

//	ProjectStatusIter find( const Record & );

//	ProjectStatusIter remove( const ProjectStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//ProjectStatusIter begin();

	//ProjectStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedProjectStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedProjectStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedProjectStatusList sorted( const QString & c, bool a = true ) const;

	MappedProjectStatusList unique() const;
	MappedProjectStatusList reversed() const;
	MappedProjectStatusList reloaded() const;

	QStringList projectStatuses() const;
	MappedProjectStatusList & setProjectStatuses( const QString & );
	QList<uint> chronologies() const;
	MappedProjectStatusList & setChronologies( const uint & );


};


