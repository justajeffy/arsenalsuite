
%MappedType MappedJobStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobstatuslist.h"
#include "jobstatustable.h"
#define MappedJobStatus JobStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobStatusSchema::instance() );
%End
};

class JobStatus : Record
{
%TypeHeaderCode
#include <jobstatus.h>
#include "job.h"

%End
public:
	JobStatus();

	JobStatus( uint key );

	JobStatus( const JobStatus & other );

	JobStatus( const Record & r );

	JobStatus( RecordImp * imp, bool checkType = true );
	
	MappedJobStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint hostsOnJob() const;
	MappedJobStatus & setHostsOnJob( const uint & );
	MappedJob job() const;
	MappedJobStatus & setJob( const Job & );
	uint tasksUnassigned() const;
	MappedJobStatus & setTasksUnassigned( const uint & );
	uint tasksCount() const;
	MappedJobStatus & setTasksCount( const uint & );
	uint tasksDone() const;
	MappedJobStatus & setTasksDone( const uint & );
	uint tasksCancelled() const;
	MappedJobStatus & setTasksCancelled( const uint & );
	uint tasksSuspended() const;
	MappedJobStatus & setTasksSuspended( const uint & );
	uint tasksAssigned() const;
	MappedJobStatus & setTasksAssigned( const uint & );
	uint tasksBusy() const;
	MappedJobStatus & setTasksBusy( const uint & );
	uint tasksAverageTime() const;
	MappedJobStatus & setTasksAverageTime( const uint & );
	float health() const;
	MappedJobStatus & setHealth( const float & );
	QDateTime jobLastUpdated() const;
	MappedJobStatus & setJobLastUpdated( const QDateTime & );
	uint errorCount() const;
	MappedJobStatus & setErrorCount( const uint & );
	uint lastNotifiedErrorCount() const;
	MappedJobStatus & setLastNotifiedErrorCount( const uint & );
	/**
	  * Average memory used per task in kilobytes.
	  **/
	uint averageMemory() const;
	MappedJobStatus & setAverageMemory( const uint & );


	static MappedJobStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobStatus reload( bool lockForUpdate = false );

	static MappedJobStatus recordByJob( const Job &fkeyJob );






	static Table * table();
	//static JobStatusSchema * schema();
};


