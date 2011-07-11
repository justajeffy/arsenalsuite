
%MappedType MappedJobHoudiniSim10
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhoudinisim10list.h"
#include "jobhoudinisim10table.h"
#define MappedJobHoudiniSim10 JobHoudiniSim10
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobHoudiniSim10(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobHoudiniSim10Schema::instance() );
%End
};

class JobHoudiniSim10 : Job
{
%TypeHeaderCode
#include <jobhoudinisim10.h>

%End
public:
	JobHoudiniSim10();

	JobHoudiniSim10( uint key );

	JobHoudiniSim10( const JobHoudiniSim10 & other );

	JobHoudiniSim10( const Record & r );

	JobHoudiniSim10( RecordImp * imp, bool checkType = true );
	
	MappedJobHoudiniSim10 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint slices() const;
	MappedJobHoudiniSim10 & setSlices( const uint & );
	QString tracker() const;
	MappedJobHoudiniSim10 & setTracker( const QString & );
	uint frameStart() const;
	MappedJobHoudiniSim10 & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobHoudiniSim10 & setFrameEnd( const uint & );
	QString nodeName() const;
	MappedJobHoudiniSim10 & setNodeName( const QString & );


	static MappedJobHoudiniSim10List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobHoudiniSim10 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobHoudiniSim10Schema * schema();
};


