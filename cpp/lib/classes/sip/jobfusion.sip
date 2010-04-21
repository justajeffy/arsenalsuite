
%MappedType MappedJobFusion
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionlist.h"
#include "jobfusiontable.h"
#define MappedJobFusion JobFusion
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobFusion(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobFusionSchema::instance() );
%End
};

class JobFusion : Job
{
%TypeHeaderCode
#include <jobfusion.h>

%End
public:
	JobFusion();

	JobFusion( uint key );

	JobFusion( const JobFusion & other );

	JobFusion( const Record & r );

	JobFusion( RecordImp * imp, bool checkType = true );
	
	MappedJobFusion copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString frameList() const;
	MappedJobFusion & setFrameList( const QString & );
	bool allFramesAsSingleTask() const;
	MappedJobFusion & setAllFramesAsSingleTask( const bool & );
	uint outputCount() const;
	MappedJobFusion & setOutputCount( const uint & );


	static MappedJobFusionList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobFusion reload( bool lockForUpdate = false );







	static Table * table();
	//static JobFusionSchema * schema();
};


