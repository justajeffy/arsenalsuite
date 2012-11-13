


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
	HostHistoryList() /HoldGIL/;
	HostHistoryList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	HostHistoryList( const HostHistoryList & ) /HoldGIL/;
	HostHistoryList( const Record &, Table * t = 0 ) /HoldGIL/;
	HostHistoryList( SIP_PYLIST );
%MethodCode
	sipCpp = new HostHistoryList( recordListFromPyList(a0), HostHistory::table() );
%End

	~HostHistoryList() /HoldGIL/;

//	void insert( HostHistoryIter, const HostHistory & );

//	HostHistoryIter at( uint );

//	HostHistoryIter find( const Record & );

//	HostHistoryIter remove( const HostHistoryIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//HostHistoryIter begin();

	//HostHistoryIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedHostHistoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedHostHistoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedHostHistoryList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedHostHistoryList unique() const;
	MappedHostHistoryList reversed() const;
	MappedHostHistoryList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, HostHistory::schema() );
%End

	MappedHostList hosts(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setHosts( const Host & );
	MappedJobList jobs(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobs( const Job & );
	MappedJobStatList jobstats(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobstats( const JobStat & );
	QStringList statuses() const /HoldGIL/;
	MappedHostHistoryList & setStatuses( const QString & );
	QStringList laststatuses() const /HoldGIL/;
	MappedHostHistoryList & setLaststatuses( const QString & );
	QList<QDateTime> dateTimes() const /HoldGIL/;
	MappedHostHistoryList & setDateTimes( const QDateTime & );
	MappedJobTaskList jobTasks(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobTasks( const JobTask & );
	QStringList change_from_ips() const /HoldGIL/;
	MappedHostHistoryList & setChange_from_ips( const QString & );
	QStringList nextStatuses() const /HoldGIL/;
	MappedHostHistoryList & setNextStatuses( const QString & );
	MappedJobTypeList jobTypes(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobTypes( const JobType & );
	MappedJobCommandHistoryList jobCommandHistories(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobCommandHistories( const JobCommandHistory & );
	MappedJobErrorList jobErrors(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistoryList & setJobErrors( const JobError & );
	QList<bool> successes() const /HoldGIL/;
	MappedHostHistoryList & setSuccesses( const bool & );
	QList<Interval> durations() const /HoldGIL/;
	MappedHostHistoryList & setDurations( const Interval & );


};


