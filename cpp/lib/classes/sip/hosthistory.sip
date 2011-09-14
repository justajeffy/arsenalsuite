
%MappedType MappedHostHistory
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hosthistorylist.h"
#include "hosthistorytable.h"
#define MappedHostHistory HostHistory
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostHistory(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostHistorySchema::instance() );
%End
};

class HostHistory : Record
{
%TypeHeaderCode
#include <hosthistory.h>
#include "host.h"
#include "job.h"
#include "jobstat.h"
#include "jobtask.h"
#include "jobtype.h"
#include "jobcommandhistory.h"
#include "joberror.h"

%End
public:
	HostHistory();

	HostHistory( uint key );

	HostHistory( const HostHistory & other );

	HostHistory( const Record & r );

	HostHistory( RecordImp * imp, bool checkType = true );
	
	MappedHostHistory copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostHistory & setHost( const Host & );
	MappedJob job() const;
	MappedHostHistory & setJob( const Job & );
	MappedJobStat jobstat() const;
	MappedHostHistory & setJobstat( const JobStat & );
	QString status() const;
	MappedHostHistory & setStatus( const QString & );
	QString laststatus() const;
	MappedHostHistory & setLaststatus( const QString & );
	QDateTime dateTime() const;
	MappedHostHistory & setDateTime( const QDateTime & );
	MappedJobTask jobTask() const;
	MappedHostHistory & setJobTask( const JobTask & );
	QString change_from_ip() const;
	MappedHostHistory & setChange_from_ip( const QString & );
	QString nextStatus() const;
	MappedHostHistory & setNextStatus( const QString & );
	MappedJobType jobType() const;
	MappedHostHistory & setJobType( const JobType & );
	MappedJobCommandHistory jobCommandHistory() const;
	MappedHostHistory & setJobCommandHistory( const JobCommandHistory & );
	MappedJobError jobError() const;
	MappedHostHistory & setJobError( const JobError & );
	bool success() const;
	MappedHostHistory & setSuccess( const bool & );
	Interval duration() const;
	MappedHostHistory & setDuration( const Interval & );


	static MappedHostHistoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostHistory reload( bool lockForUpdate = false );







	static Table * table();
	//static HostHistorySchema * schema();
};


