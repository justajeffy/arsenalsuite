
%MappedType MappedJobHistory
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhistorylist.h"
#include "jobhistorytable.h"
#define MappedJobHistory JobHistory
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobHistory(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobHistorySchema::instance() );
%End
};

class JobHistory : Record
{
%TypeHeaderCode
#include <jobhistory.h>
#include "jobhistorytype.h"
#include "job.h"
#include "host.h"
#include "user.h"

%End
public:
	JobHistory();

	JobHistory( uint key );

	JobHistory( const JobHistory & other );

	JobHistory( const Record & r );

	JobHistory( RecordImp * imp, bool checkType = true );
	
	MappedJobHistory copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJobHistoryType type() const;
	MappedJobHistory & setType( const JobHistoryType & );
	MappedJob job() const;
	MappedJobHistory & setJob( const Job & );
	MappedHost host() const;
	MappedJobHistory & setHost( const Host & );
	MappedUser user() const;
	MappedJobHistory & setUser( const User & );
	QString message() const;
	MappedJobHistory & setMessage( const QString & );
	QDateTime created() const;
	MappedJobHistory & setCreated( const QDateTime & );


	static MappedJobHistoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobHistory reload( bool lockForUpdate = false );

	static MappedJobHistoryList recordsByJob( const Job &fkeyJob );
	static MappedJobHistoryList recordsByHost( const Host &fkeyHost );
	static MappedJobHistoryList recordsByUser( const User &fkeyUser );






	static Table * table();
	//static JobHistorySchema * schema();
};


