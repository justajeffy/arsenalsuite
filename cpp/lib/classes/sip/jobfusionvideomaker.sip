
%MappedType MappedJobFusionVideoMaker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionvideomakerlist.h"
#include "jobfusionvideomakertable.h"
#define MappedJobFusionVideoMaker JobFusionVideoMaker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobFusionVideoMaker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobFusionVideoMakerSchema::instance() );
%End
};

class JobFusionVideoMaker : JobFusion
{
%TypeHeaderCode
#include <jobfusionvideomaker.h>

%End
public:
	JobFusionVideoMaker() /HoldGIL/;

	JobFusionVideoMaker( uint key ) throw(SqlException,LostConnectionException,PythonException);

	JobFusionVideoMaker( const JobFusionVideoMaker & other ) /HoldGIL/;

	JobFusionVideoMaker( const Record & r ) /HoldGIL/;

	JobFusionVideoMaker( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedJobFusionVideoMaker copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString codec() const /HoldGIL/;
	MappedJobFusionVideoMaker & setCodec( const QString & );
	QString inputFramePath() const /HoldGIL/;
	MappedJobFusionVideoMaker & setInputFramePath( const QString & );
	uint sequenceFrameStart() const /HoldGIL/;
	MappedJobFusionVideoMaker & setSequenceFrameStart( const uint & );
	uint sequenceFrameEnd() const /HoldGIL/;
	MappedJobFusionVideoMaker & setSequenceFrameEnd( const uint & );


	static MappedJobFusionVideoMakerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedJobFusionVideoMakerList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

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
			sipRes = new JoinedSelect(JobFusionVideoMaker::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedJobFusionVideoMaker reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);






static QStringList outputFormats();
static QStringList outputCodecs(const QString & format);
static QString formatFromExtension(const QString & ext);
static QString formatToExtension(const QString & format);
static QString updatePathToFormat(const QString & path, const QString & format);

QString format();


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
		StaticFieldExpression FrameList;
		StaticFieldExpression AllFramesAsSingleTask;
		StaticFieldExpression OutputCount;
		StaticFieldExpression ReportedSaverError;
		StaticFieldExpression Codec;
		StaticFieldExpression InputFramePath;
		StaticFieldExpression SequenceFrameStart;
		StaticFieldExpression SequenceFrameEnd;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static JobFusionVideoMakerSchema * schema();
};


