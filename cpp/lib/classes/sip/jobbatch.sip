
%MappedType MappedJobBatch
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobbatchlist.h"
#include "jobbatchtable.h"
#define MappedJobBatch JobBatch
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobBatch(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobBatchSchema::instance() );
%End
};

class JobBatch : Job
{
%TypeHeaderCode
#include <jobbatch.h>

%End
public:
	JobBatch();

	JobBatch( uint key );

	JobBatch( const JobBatch & other );

	JobBatch( const Record & r );

	JobBatch( RecordImp * imp, bool checkType = true );
	
	MappedJobBatch copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString cmd() const;
	MappedJobBatch & setCmd( const QString & );
	bool restartAfterShutdown() const;
	MappedJobBatch & setRestartAfterShutdown( const bool & );
	bool passSlaveFramesAsParam() const;
	MappedJobBatch & setPassSlaveFramesAsParam( const bool & );
	bool disableWow64FsRedirect() const;
	MappedJobBatch & setDisableWow64FsRedirect( const bool & );


	static MappedJobBatchList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobBatch reload( bool lockForUpdate = false );







	static Table * table();
	//static JobBatchSchema * schema();
};


