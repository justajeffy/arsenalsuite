
%MappedType MappedJobOutput
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joboutputlist.h"
#include "joboutputtable.h"
#define MappedJobOutput JobOutput
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobOutput(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobOutputSchema::instance() );
%End
};

class JobOutput : Record
{
%TypeHeaderCode
#include <joboutput.h>
#include "job.h"
#include "filetracker.h"

%End
public:
	JobOutput();

	JobOutput( uint key );

	JobOutput( const JobOutput & other );

	JobOutput( const Record & r );

	JobOutput( RecordImp * imp, bool checkType = true );
	
	MappedJobOutput copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJob job() const;
	MappedJobOutput & setJob( const Job & );
	QString name() const;
	MappedJobOutput & setName( const QString & );
	MappedFileTracker fileTracker() const;
	MappedJobOutput & setFileTracker( const FileTracker & );


	static MappedJobOutputList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobOutput reload( bool lockForUpdate = false );

	static MappedJobOutputList recordsByJob( const Job &fkeyJob );
	static MappedJobOutput recordByJobAndName( const Job &fkeyJob, const QString &name );






	static Table * table();
	//static JobOutputSchema * schema();
};


