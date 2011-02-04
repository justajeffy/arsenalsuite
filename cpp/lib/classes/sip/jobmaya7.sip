
%MappedType MappedJobMaya7
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya7list.h"
#include "jobmaya7table.h"
#define MappedJobMaya7 JobMaya7
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya7(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaya7Schema::instance() );
%End
};

class JobMaya7 : JobMaya
{
%TypeHeaderCode
#include <jobmaya7.h>

%End
public:
	JobMaya7();

	JobMaya7( uint key );

	JobMaya7( const JobMaya7 & other );

	JobMaya7( const Record & r );

	JobMaya7( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya7 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMaya7List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya7 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaya7Schema * schema();
};


