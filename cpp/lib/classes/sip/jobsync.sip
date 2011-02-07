
%MappedType MappedJobSync
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobsynclist.h"
#include "jobsynctable.h"
#define MappedJobSync JobSync
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobSync(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobSyncSchema::instance() );
%End
};

class JobSync : Job
{
%TypeHeaderCode
#include <jobsync.h>

%End
public:
	JobSync();

	JobSync( uint key );

	JobSync( const JobSync & other );

	JobSync( const Record & r );

	JobSync( RecordImp * imp, bool checkType = true );
	
	MappedJobSync copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString direction() const;
	MappedJobSync & setDirection( const QString & );
	QString filesFrom() const;
	MappedJobSync & setFilesFrom( const QString & );
	QString append() const;
	MappedJobSync & setAppend( const QString & );


	static MappedJobSyncList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobSync reload( bool lockForUpdate = false );







	static Table * table();
	//static JobSyncSchema * schema();
};


