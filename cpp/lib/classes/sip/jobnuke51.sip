
%MappedType MappedJobNuke51
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobnuke51list.h"
#include "jobnuke51table.h"
#define MappedJobNuke51 JobNuke51
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobNuke51(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobNuke51Schema::instance() );
%End
};

class JobNuke51 : Job
{
%TypeHeaderCode
#include <jobnuke51.h>

%End
public:
	JobNuke51();

	JobNuke51( uint key );

	JobNuke51( const JobNuke51 & other );

	JobNuke51( const Record & r );

	JobNuke51( RecordImp * imp, bool checkType = true );
	
	MappedJobNuke51 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobNuke51 & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobNuke51 & setFrameEnd( const uint & );
	uint outputCount() const;
	MappedJobNuke51 & setOutputCount( const uint & );


	static MappedJobNuke51List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobNuke51 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobNuke51Schema * schema();
};


