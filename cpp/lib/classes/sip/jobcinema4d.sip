
%MappedType MappedJobCinema4D
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcinema4dlist.h"
#include "jobcinema4dtable.h"
#define MappedJobCinema4D JobCinema4D
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobCinema4D(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobCinema4DSchema::instance() );
%End
};

class JobCinema4D : Job
{
%TypeHeaderCode
#include <jobcinema4d.h>

%End
public:
	JobCinema4D() /HoldGIL/;

	JobCinema4D( uint key ) throw(SqlException,LostConnectionException,PythonException);

	JobCinema4D( const JobCinema4D & other ) /HoldGIL/;

	JobCinema4D( const Record & r ) /HoldGIL/;

	JobCinema4D( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedJobCinema4D copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	bool videoMode() const /HoldGIL/;
	MappedJobCinema4D & setVideoMode( const bool & );
	int videoStartFrame() const /HoldGIL/;
	MappedJobCinema4D & setVideoStartFrame( const int & );
	int videoEndFrame() const /HoldGIL/;
	MappedJobCinema4D & setVideoEndFrame( const int & );


	static MappedJobCinema4DList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedJobCinema4DList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

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
			sipRes = new JoinedSelect(JobCinema4D::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedJobCinema4D reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);







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
		StaticFieldExpression VideoMode;
		StaticFieldExpression VideoStartFrame;
		StaticFieldExpression VideoEndFrame;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static JobCinema4DSchema * schema();
};


