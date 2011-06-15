
%MappedType MappedJobMantra100
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmantra100list.h"
#include "jobmantra100table.h"
#define MappedJobMantra100 JobMantra100
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMantra100(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMantra100Schema::instance() );
%End
};

class JobMantra100 : Job
{
%TypeHeaderCode
#include <jobmantra100.h>

%End
public:
	JobMantra100();

	JobMantra100( uint key );

	JobMantra100( const JobMantra100 & other );

	JobMantra100( const Record & r );

	JobMantra100( RecordImp * imp, bool checkType = true );
	
	MappedJobMantra100 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	bool forceRayTrace() const;
	MappedJobMantra100 & setForceRayTrace( const bool & );
	uint geoCacheSize() const;
	MappedJobMantra100 & setGeoCacheSize( const uint & );
	uint height() const;
	MappedJobMantra100 & setHeight( const uint & );
	uint width() const;
	MappedJobMantra100 & setWidth( const uint & );
	QString qualityFlag() const;
	MappedJobMantra100 & setQualityFlag( const QString & );
	uint threads() const;
	MappedJobMantra100 & setThreads( const uint & );
	uint renderQuality() const;
	MappedJobMantra100 & setRenderQuality( const uint & );


	static MappedJobMantra100List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMantra100 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMantra100Schema * schema();
};


