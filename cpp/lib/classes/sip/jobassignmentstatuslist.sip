


%MappedType MappedJobAssignmentStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobassignmentstatuslist.h"
#include "jobassignmentstatustable.h"
#define MappedJobAssignmentStatusList JobAssignmentStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAssignmentStatusSchema::instance() );
%End
};

class JobAssignmentStatusList : RecordList
{
%TypeHeaderCode
#include <jobassignmentstatuslist.h>

%End
public:
	JobAssignmentStatusList();
	JobAssignmentStatusList( const RecordList &, Table * t = 0 );
	JobAssignmentStatusList( const JobAssignmentStatusList & );
	JobAssignmentStatusList( const Record &, Table * t = 0 );
	
	~JobAssignmentStatusList();

//	void insert( JobAssignmentStatusIter, const JobAssignmentStatus & );

//	JobAssignmentStatusIter at( uint );

//	JobAssignmentStatusIter find( const Record & );

//	JobAssignmentStatusIter remove( const JobAssignmentStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAssignmentStatusIter begin();

	//JobAssignmentStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAssignmentStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAssignmentStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAssignmentStatusList sorted( const QString & c, bool a = true ) const;

	MappedJobAssignmentStatusList unique() const;
	MappedJobAssignmentStatusList reversed() const;
	MappedJobAssignmentStatusList reloaded() const;

	QStringList statuses() const;
	MappedJobAssignmentStatusList & setStatuses( const QString & );


};


