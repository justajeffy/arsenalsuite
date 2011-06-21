
%MappedType MappedJobError
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorlist.h"
#include "joberrortable.h"
#define MappedJobError JobError
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobError(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobErrorSchema::instance() );
%End
};

class JobError : Record
{
%TypeHeaderCode
#include <joberror.h>
#include "host.h"
#include "job.h"
#include "jobassignment.h"

%End
public:
	JobError();

	JobError( uint key );

	JobError( const JobError & other );

	JobError( const Record & r );

	JobError( RecordImp * imp, bool checkType = true );
	
	MappedJobError copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedJobError & setHost( const Host & );
	MappedJob job() const;
	MappedJobError & setJob( const Job & );
	QString frames() const;
	MappedJobError & setFrames( const QString & );
	QString message() const;
	MappedJobError & setMessage( const QString & );
	uint errorTime() const;
	MappedJobError & setErrorTime( const uint & );
	uint count() const;
	MappedJobError & setCount( const uint & );
	bool cleared() const;
	MappedJobError & setCleared( const bool & );
	QDateTime lastOccurrence() const;
	MappedJobError & setLastOccurrence( const QDateTime & );
	bool timeout() const;
	MappedJobError & setTimeout( const bool & );
	MappedJobAssignment jobAssignment() const;


	static MappedJobErrorList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobError reload( bool lockForUpdate = false );

	static MappedJobErrorList recordsByJob( const Job &fkeyJob );
	static MappedJobErrorList recordsByJobAndHost( const Job &fkeyJob, const Host &fkeyHost );






	static Table * table();
	//static JobErrorSchema * schema();
};


