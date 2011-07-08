
%MappedType MappedJobMax9
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax9list.h"
#include "jobmax9table.h"
#define MappedJobMax9 JobMax9
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax9(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax9Schema::instance() );
%End
};

class JobMax9 : JobMax
{
%TypeHeaderCode
#include <jobmax9.h>

%End
public:
	JobMax9();

	JobMax9( uint key );

	JobMax9( const JobMax9 & other );

	JobMax9( const Record & r );

	JobMax9( RecordImp * imp, bool checkType = true );
	
	MappedJobMax9 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMax9List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax9 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax9Schema * schema();
};


