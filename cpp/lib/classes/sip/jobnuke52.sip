
%MappedType MappedJobNuke52
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobnuke52list.h"
#include "jobnuke52table.h"
#define MappedJobNuke52 JobNuke52
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobNuke52(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobNuke52Schema::instance() );
%End
};

class JobNuke52 : Job
{
%TypeHeaderCode
#include <jobnuke52.h>

%End
public:
	JobNuke52();

	JobNuke52( uint key );

	JobNuke52( const JobNuke52 & other );

	JobNuke52( const Record & r );

	JobNuke52( RecordImp * imp, bool checkType = true );
	
	MappedJobNuke52 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobNuke52 & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobNuke52 & setFrameEnd( const uint & );
	uint outputCount() const;
	MappedJobNuke52 & setOutputCount( const uint & );


	static MappedJobNuke52List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobNuke52 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobNuke52Schema * schema();
};


