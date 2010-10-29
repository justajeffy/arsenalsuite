
%MappedType MappedJobTaskAssignment
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtaskassignmentlist.h"
#include "jobtaskassignmenttable.h"
#define MappedJobTaskAssignment JobTaskAssignment
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobTaskAssignment(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobTaskAssignmentSchema::instance() );
%End
};

class JobTaskAssignment : Record
{
%TypeHeaderCode
#include <jobtaskassignment.h>
#include "jobassignment.h"
#include "jobassignmentstatus.h"
#include "jobtask.h"
#include "joberror.h"

%End
public:
	JobTaskAssignment();

	JobTaskAssignment( uint key );

	JobTaskAssignment( const JobTaskAssignment & other );

	JobTaskAssignment( const Record & r );

	JobTaskAssignment( RecordImp * imp, bool checkType = true );
	
	MappedJobTaskAssignment copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJobAssignment jobAssignment() const;
	MappedJobTaskAssignment & setJobAssignment( const JobAssignment & );
	uint memory() const;
	MappedJobTaskAssignment & setMemory( const uint & );
	QDateTime started() const;
	MappedJobTaskAssignment & setStarted( const QDateTime & );
	QDateTime ended() const;
	MappedJobTaskAssignment & setEnded( const QDateTime & );
	MappedJobAssignmentStatus jobAssignmentStatus() const;
	MappedJobTaskAssignment & setJobAssignmentStatus( const JobAssignmentStatus & );
	MappedJobTask jobTask() const;
	MappedJobTaskAssignment & setJobTask( const JobTask & );
	MappedJobError jobError() const;
	MappedJobTaskAssignment & setJobError( const JobError & );


	static MappedJobTaskAssignmentList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobTaskAssignment reload( bool lockForUpdate = false );

	static MappedJobTaskAssignmentList recordsByJobAssignment( const JobAssignment &fkeyJobAssignment );






	static Table * table();
	//static JobTaskAssignmentSchema * schema();
};


