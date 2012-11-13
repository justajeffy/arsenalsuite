
%MappedType MappedJobAutodeskBurn
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobautodeskburnlist.h"
#include "jobautodeskburntable.h"
#define MappedJobAutodeskBurn JobAutodeskBurn
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAutodeskBurn(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAutodeskBurnSchema::instance() );
%End
};

class JobAutodeskBurn : Job
{
%TypeHeaderCode
#include <jobautodeskburn.h>

%End
public:
	JobAutodeskBurn() /HoldGIL/;

	JobAutodeskBurn( uint key ) throw(SqlException,LostConnectionException,PythonException);

	JobAutodeskBurn( const JobAutodeskBurn & other ) /HoldGIL/;

	JobAutodeskBurn( const Record & r ) /HoldGIL/;

	JobAutodeskBurn( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedJobAutodeskBurn copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const /HoldGIL/;
	MappedJobAutodeskBurn & setFrameStart( const uint & );
	uint frameEnd() const /HoldGIL/;
	MappedJobAutodeskBurn & setFrameEnd( const uint & );
	QString handle() const /HoldGIL/;
	MappedJobAutodeskBurn & setHandle( const QString & );


	static MappedJobAutodeskBurnList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedJobAutodeskBurnList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

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
			sipRes = new JoinedSelect(JobAutodeskBurn::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedJobAutodeskBurn reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);

	static MappedJobAutodeskBurn recordBynameAndHandle( const QString &job, const QString &handle, int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache );






	struct _c {
		StaticFieldExpression Element;
		StaticFieldExpression Host;
		StaticFieldExpression JobType;
		StaticFieldExpression Project;
		StaticFieldExpression User;
		StaticFieldExpression HostList;
		StaticFieldExpression Name;
		StaticFieldExpression OutputPath;
		StaticFieldExpression Status;
		StaticFieldExpression Key;
		StaticFieldExpression DeleteOnComplete;
		StaticFieldExpression Priority;
		StaticFieldExpression PacketType;
		StaticFieldExpression PacketSize;
		StaticFieldExpression NotifyOnError;
		StaticFieldExpression NotifyOnComplete;
		StaticFieldExpression MaxTaskTime;
		StaticFieldExpression Cleaned;
		StaticFieldExpression FileSize;
		StaticFieldExpression FileName;
		StaticFieldExpression FileMd5sum;
		StaticFieldExpression JobStat;
		StaticFieldExpression UserName;
		StaticFieldExpression Domain;
		StaticFieldExpression Password;
		StaticFieldExpression Stats;
		StaticFieldExpression CurrentMapServerWeight;
		StaticFieldExpression PrioritizeOuterTasks;
		StaticFieldExpression MaxLoadTime;
		StaticFieldExpression MaxMemory;
		StaticFieldExpression JobParent;
		StaticFieldExpression Submittedts;
		StaticFieldExpression Startedts;
		StaticFieldExpression Endedts;
		StaticFieldExpression MaxHosts;
		StaticFieldExpression PersonalPriority;
		StaticFieldExpression LoggingEnabled;
		StaticFieldExpression UploadedFile;
		StaticFieldExpression CheckFileMd5;
		StaticFieldExpression RunasSubmitter;
		StaticFieldExpression FrameNth;
		StaticFieldExpression FrameNthMode;
		StaticFieldExpression ExclusiveAssignment;
		StaticFieldExpression HasTaskProgress;
		StaticFieldExpression MinMemory;
		StaticFieldExpression ShotName;
		StaticFieldExpression SceneName;
		StaticFieldExpression AssignmentSlots;
		StaticFieldExpression FilterSet;
		StaticFieldExpression AllowPreemption;
		StaticFieldExpression MinTaskNumber;
		StaticFieldExpression MaxTaskNumber;
		StaticFieldExpression ApplyProjectWeight;
		StaticFieldExpression EstimatedMemory;
		StaticFieldExpression VerifyError;
		StaticFieldExpression MaxErrors;
		StaticFieldExpression NotifyErrorMessage;
		StaticFieldExpression NotifyCompleteMessage;
		StaticFieldExpression Wrangler;
		StaticFieldExpression MaxQuietTime;
		StaticFieldExpression AutoAdaptSlots;
		StaticFieldExpression Environment;
		StaticFieldExpression Suspendedts;
		StaticFieldExpression ToggleFlags;
		StaticFieldExpression MidTaskNumber;
		StaticFieldExpression AllowSmallerPackets;
		StaticFieldExpression FrameStart;
		StaticFieldExpression FrameEnd;
		StaticFieldExpression Handle;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static JobAutodeskBurnSchema * schema();
};


