


%MappedType MappedHostHistoryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hosthistorylist.h"
#include "hosthistorytable.h"
#define MappedHostHistoryList HostHistoryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostHistorySchema::instance() );
%End
};

class HostHistoryList : RecordList
{
%TypeHeaderCode
#include <hosthistorylist.h>
#include "host.h"
#include "job.h"
#include "jobstat.h"
#include "jobtask.h"
#include "jobtype.h"
#include "jobcommandhistory.h"
#include "joberror.h"

%End
public:
	HostHistoryList();
	HostHistoryList( const RecordList &, Table * t = 0 );
	HostHistoryList( const HostHistoryList & );
	HostHistoryList( const Record &, Table * t = 0 );
	
	~HostHistoryList();

//	void insert( HostHistoryIter, const HostHistory & );

//	HostHistoryIter at( uint );

//	HostHistoryIter find( const Record & );

//	HostHistoryIter remove( const HostHistoryIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostHistoryIter begin();

	//HostHistoryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostHistoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostHistoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostHistoryList sorted( const QString & c, bool a = true ) const;

	MappedHostHistoryList unique() const;
	MappedHostHistoryList reversed() const;
	MappedHostHistoryList reloaded() const;

	MappedHostList hosts() const;
	MappedHostHistoryList & setHosts( const Host & );
	MappedJobList jobs() const;
	MappedHostHistoryList & setJobs( const Job & );
	MappedJobStatList jobstats() const;
	MappedHostHistoryList & setJobstats( const JobStat & );
	QStringList statuses() const;
	MappedHostHistoryList & setStatuses( const QString & );
	QStringList laststatuses() const;
	MappedHostHistoryList & setLaststatuses( const QString & );
	QList<QDateTime> dateTimes() const;
	MappedHostHistoryList & setDateTimes( const QDateTime & );
	MappedJobTaskList jobTasks() const;
	MappedHostHistoryList & setJobTasks( const JobTask & );
	QStringList change_from_ips() const;
	MappedHostHistoryList & setChange_from_ips( const QString & );
	QStringList nextStatuses() const;
	MappedHostHistoryList & setNextStatuses( const QString & );
	MappedJobTypeList jobTypes() const;
	MappedHostHistoryList & setJobTypes( const JobType & );
	MappedJobCommandHistoryList jobCommandHistories() const;
	MappedHostHistoryList & setJobCommandHistories( const JobCommandHistory & );
	MappedJobErrorList jobErrors() const;
	MappedHostHistoryList & setJobErrors( const JobError & );
	QList<bool> successes() const;
	MappedHostHistoryList & setSuccesses( const bool & );
	QList<Interval> durations() const;
	MappedHostHistoryList & setDurations( const Interval & );


};


