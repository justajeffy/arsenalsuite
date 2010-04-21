
%MappedType MappedJobCommandHistory
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcommandhistorylist.h"
#include "jobcommandhistorytable.h"
#define MappedJobCommandHistory JobCommandHistory
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobCommandHistory(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobCommandHistorySchema::instance() );
%End
};

class JobCommandHistory : Record
{
%TypeHeaderCode
#include <jobcommandhistory.h>
#include "job.h"
#include "host.h"
#include "hosthistory.h"

%End
public:
	JobCommandHistory();

	JobCommandHistory( uint key );

	JobCommandHistory( const JobCommandHistory & other );

	JobCommandHistory( const Record & r );

	JobCommandHistory( RecordImp * imp, bool checkType = true );
	
	MappedJobCommandHistory copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString stdErr() const;
	MappedJobCommandHistory & setStdErr( const QString & );
	QString stdOut() const;
	MappedJobCommandHistory & setStdOut( const QString & );
	QString command() const;
	MappedJobCommandHistory & setCommand( const QString & );
	uint memory() const;
	MappedJobCommandHistory & setMemory( const uint & );
	MappedJob job() const;
	MappedJobCommandHistory & setJob( const Job & );
	MappedHost host() const;
	MappedJobCommandHistory & setHost( const Host & );
	MappedHostHistory hostHistory() const;
	MappedJobCommandHistory & setHostHistory( const HostHistory & );
	float realtime() const;
	MappedJobCommandHistory & setRealtime( const float & );
	float usertime() const;
	MappedJobCommandHistory & setUsertime( const float & );
	float systime() const;
	MappedJobCommandHistory & setSystime( const float & );
	uint iowait() const;
	MappedJobCommandHistory & setIowait( const uint & );


	static MappedJobCommandHistoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobCommandHistory reload( bool lockForUpdate = false );

	static MappedJobCommandHistoryList recordsByJob( const Job &fkeyJob );






	static Table * table();
	//static JobCommandHistorySchema * schema();
};


