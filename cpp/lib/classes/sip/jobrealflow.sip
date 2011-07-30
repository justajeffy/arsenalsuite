
%MappedType MappedJobRealFlow
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobrealflowlist.h"
#include "jobrealflowtable.h"
#define MappedJobRealFlow JobRealFlow
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobRealFlow(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobRealFlowSchema::instance() );
%End
};

class JobRealFlow : Job
{
%TypeHeaderCode
#include <jobrealflow.h>

%End
public:
	JobRealFlow();

	JobRealFlow( uint key );

	JobRealFlow( const JobRealFlow & other );

	JobRealFlow( const Record & r );

	JobRealFlow( RecordImp * imp, bool checkType = true );
	
	MappedJobRealFlow copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	int frameStart() const;
	MappedJobRealFlow & setFrameStart( const int & );
	int frameEnd() const;
	MappedJobRealFlow & setFrameEnd( const int & );
	QString simType() const;
	MappedJobRealFlow & setSimType( const QString & );
	uint threads() const;
	MappedJobRealFlow & setThreads( const uint & );


	static MappedJobRealFlowList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobRealFlow reload( bool lockForUpdate = false );







	static Table * table();
	//static JobRealFlowSchema * schema();
};


