
%MappedType MappedJobTask
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtasklist.h"
#include "jobtasktable.h"
#define MappedJobTask JobTask
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobTask(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobTaskSchema::instance() );
%End
};

class JobTask : Record
{
%TypeHeaderCode
#include <jobtask.h>
#include "host.h"
#include "job.h"
#include "joboutput.h"
#include "jobtaskassignment.h"

%End
public:
	JobTask();

	JobTask( uint key );

	JobTask( const JobTask & other );

	JobTask( const Record & r );

	JobTask( RecordImp * imp, bool checkType = true );
	
	MappedJobTask copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedJobTask & setHost( const Host & );
	MappedJob job() const;
	MappedJobTask & setJob( const Job & );
	QString status() const;
	MappedJobTask & setStatus( const QString & );
	int frameNumber() const;
	MappedJobTask & setFrameNumber( const int & );
	/**
	  * This holds the name of the task to be displayed to the user.  If label is null, the task is considered to represent a frame and the number stored in the jobtask(frameNumber) field is displayed.
	  **/
	QString label() const;
	MappedJobTask & setLabel( const QString & );
	MappedJobOutput jobOutput() const;
	MappedJobTask & setJobOutput( const JobOutput & );
	MappedJobTaskAssignment jobTaskAssignment() const;
	MappedJobTask & setJobTaskAssignment( const JobTaskAssignment & );
	uint progress() const;
	MappedJobTask & setProgress( const uint & );


	static MappedJobTaskList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobTask reload( bool lockForUpdate = false );

	static MappedJobTaskList recordsByJob( const Job &fkeyJob );
	static MappedJobTaskList recordsByJobAndHost( const Job &fkeyJob, const Host &fkeyHost );






	static Table * table();
	//static JobTaskSchema * schema();
};


