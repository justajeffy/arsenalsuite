
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
	HostHistory() /HoldGIL/;

	HostHistory( uint key ) throw(SqlException,LostConnectionException,PythonException);

	HostHistory( const HostHistory & other ) /HoldGIL/;

	HostHistory( const Record & r ) /HoldGIL/;

	HostHistory( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedHostHistory copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setHost( const Host & );
	MappedJob job(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJob( const Job & );
	MappedJobStat jobstat(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJobstat( const JobStat & );
	QString status() const /HoldGIL/;
	MappedHostHistory & setStatus( const QString & );
	QString laststatus() const /HoldGIL/;
	MappedHostHistory & setLaststatus( const QString & );
	QDateTime dateTime() const /HoldGIL/;
	MappedHostHistory & setDateTime( const QDateTime & );
	MappedJobTask jobTask(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJobTask( const JobTask & );
	QString change_from_ip() const /HoldGIL/;
	MappedHostHistory & setChange_from_ip( const QString & );
	QString nextStatus() const /HoldGIL/;
	MappedHostHistory & setNextStatus( const QString & );
	MappedJobType jobType(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJobType( const JobType & );
	MappedJobCommandHistory jobCommandHistory(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJobCommandHistory( const JobCommandHistory & );
	MappedJobError jobError(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedHostHistory & setJobError( const JobError & );
	bool success() const /HoldGIL/;
	MappedHostHistory & setSuccess( const bool & );
	Interval duration() const /HoldGIL/;
	MappedHostHistory & setDuration( const Interval & );


	static MappedHostHistoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedHostHistoryList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

	static JoinedSelect join( SIP_PYOBJECT cls, QString condition = QString(), JoinType joinType = InnerJoin, bool ignoreResults = false, const QString & alias = QString() );
%MethodCode
		// Convert to python
		Table * inst = 0;

		if( !sipCanConvertToType(a0,sipType_Table,SIP_NOT_NONE) ) {
			// Attempt to get the table * by calling the static method table()
			if( !sipIsErr && !inst ) {
				PyObject * pyTableMethod = PyObject_GetAttrString( a0, "table" );
				if( pyTableMethod ) {
					PyObject * pyTable = PyObject_CallObject( pyTableMethod, 0 );
					if( pyTable && sipCanConvertToType(pyTable,sipType_Table,SIP_NOT_NONE) )
						inst = (Table*)sipConvertToType(pyTable,sipType_Table,0,SIP_NOT_NONE,0,&sipIsErr);
					Py_XDECREF(pyTable);
					Py_XDECREF(pyTableMethod);
				} else
					sipIsErr = 1;
			}
		}
		
		if( !inst && !sipIsErr && a0 && sipCanConvertToType(a0,sipType_Table,SIP_NOT_NONE) ) {
			inst = (Table*)sipConvertToType(a0,sipType_Table,0,SIP_NOT_NONE,0,&sipIsErr);
		}

		if( !sipIsErr ) {
			sipRes = new JoinedSelect(HostHistory::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedHostHistory reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);







	struct _c {
		StaticFieldExpression Key;
		StaticFieldExpression Host;
		StaticFieldExpression Job;
		StaticFieldExpression Jobstat;
		StaticFieldExpression Status;
		StaticFieldExpression Laststatus;
		StaticFieldExpression DateTime;
		StaticFieldExpression JobTask;
		StaticFieldExpression Change_from_ip;
		StaticFieldExpression NextStatus;
		StaticFieldExpression JobType;
		StaticFieldExpression JobCommandHistory;
		StaticFieldExpression JobError;
		StaticFieldExpression Success;
		StaticFieldExpression Duration;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static HostHistorySchema * schema();
};


