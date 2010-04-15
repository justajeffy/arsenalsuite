
%MappedType MappedJobMaya85
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya85list.h"
#include "jobmaya85table.h"
#define MappedJobMaya85 JobMaya85
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya85(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaya85Schema::instance() );
%End
};

class JobMaya85 : JobMaya
{
%TypeHeaderCode
#include <jobmaya85.h>

%End
public:
	JobMaya85();

	JobMaya85( uint key );

	JobMaya85( const JobMaya85 & other );

	JobMaya85( const Record & r );

	JobMaya85( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya85 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMaya85List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya85 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaya85Schema * schema();
};


