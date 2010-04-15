
%MappedType MappedJobAssignment
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobassignmentlist.h"
#include "jobassignmenttable.h"
#define MappedJobAssignment JobAssignment
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAssignment(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAssignmentSchema::instance() );
%End
};

class JobAssignment : Record
{
%TypeHeaderCode
#include <jobassignment.h>
#include "job.h"
#include "jobassignmentstatus.h"
#include "host.h"
#include "joberror.h"
#include "jobtaskassignment.h"

%End
public:
	JobAssignment();

	JobAssignment( uint key );

	JobAssignment( const JobAssignment & other );

	JobAssignment( const Record & r );

	JobAssignment( RecordImp * imp, bool checkType = true );
	
	MappedJobAssignment copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJob job() const;
	MappedJobAssignment & setJob( const Job & );
	MappedJobAssignmentStatus jobAssignmentStatus() const;
	MappedJobAssignment & setJobAssignmentStatus( const JobAssignmentStatus & );
	MappedHost host() const;
	MappedJobAssignment & setHost( const Host & );
	QString stdOut() const;
	MappedJobAssignment & setStdOut( const QString & );
	QString stdErr() const;
	MappedJobAssignment & setStdErr( const QString & );
	QString command() const;
	MappedJobAssignment & setCommand( const QString & );
	uint maxMemory() const;
	MappedJobAssignment & setMaxMemory( const uint & );
	QDateTime started() const;
	MappedJobAssignment & setStarted( const QDateTime & );
	QDateTime ended() const;
	MappedJobAssignment & setEnded( const QDateTime & );
	MappedJobError jobError() const;
	MappedJobAssignment & setJobError( const JobError & );
	float realtime() const;
	MappedJobAssignment & setRealtime( const float & );
	float usertime() const;
	MappedJobAssignment & setUsertime( const float & );
	float systime() const;
	MappedJobAssignment & setSystime( const float & );
	uint iowait() const;
	MappedJobAssignment & setIowait( const uint & );
	uint bytesRead() const;
	MappedJobAssignment & setBytesRead( const uint & );
	uint bytesWrite() const;
	MappedJobAssignment & setBytesWrite( const uint & );
	float efficiency() const;
	MappedJobAssignment & setEfficiency( const float & );
	uint opsRead() const;
	MappedJobAssignment & setOpsRead( const uint & );
	uint opsWrite() const;
	MappedJobAssignment & setOpsWrite( const uint & );
	MappedJobTaskAssignmentList jobTaskAssignments() const;


	static MappedJobAssignmentList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAssignment reload( bool lockForUpdate = false );

	static MappedJobAssignmentList recordsByJobAssignmentStatus( const JobAssignmentStatus &fkeyJobAssignmentStatus );
	static MappedJobAssignmentList recordsByhost( const Host &fkeyhost );
	static MappedJobAssignment recordByJobError( const JobError &fkeyJobError );






	static Table * table();
	//static JobAssignmentSchema * schema();
};


