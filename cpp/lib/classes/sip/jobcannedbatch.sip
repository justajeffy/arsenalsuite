
%MappedType MappedJobCannedBatch
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcannedbatchlist.h"
#include "jobcannedbatchtable.h"
#define MappedJobCannedBatch JobCannedBatch
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobCannedBatch(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobCannedBatchSchema::instance() );
%End
};

class JobCannedBatch : Record
{
%TypeHeaderCode
#include <jobcannedbatch.h>

%End
public:
	JobCannedBatch();

	JobCannedBatch( uint key );

	JobCannedBatch( const JobCannedBatch & other );

	JobCannedBatch( const Record & r );

	JobCannedBatch( RecordImp * imp, bool checkType = true );
	
	MappedJobCannedBatch copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedJobCannedBatch & setName( const QString & );
	QString group() const;
	MappedJobCannedBatch & setGroup( const QString & );
	QString cmd() const;
	MappedJobCannedBatch & setCmd( const QString & );
	bool disableWow64FsRedirect() const;
	MappedJobCannedBatch & setDisableWow64FsRedirect( const bool & );


	static MappedJobCannedBatchList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobCannedBatch reload( bool lockForUpdate = false );

	static MappedJobCannedBatch recordByGroupAndName( const QString &group, const QString &name );






	static Table * table();
	//static JobCannedBatchSchema * schema();
};


