
%MappedType MappedJobMax7
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax7list.h"
#include "jobmax7table.h"
#define MappedJobMax7 JobMax7
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax7(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax7Schema::instance() );
%End
};

class JobMax7 : JobMax
{
%TypeHeaderCode
#include <jobmax7.h>

%End
public:
	JobMax7();

	JobMax7( uint key );

	JobMax7( const JobMax7 & other );

	JobMax7( const Record & r );

	JobMax7( RecordImp * imp, bool checkType = true );
	
	MappedJobMax7 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMax7List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax7 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax7Schema * schema();
};


