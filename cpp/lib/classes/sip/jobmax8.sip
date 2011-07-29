
%MappedType MappedJobMax8
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax8list.h"
#include "jobmax8table.h"
#define MappedJobMax8 JobMax8
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax8(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax8Schema::instance() );
%End
};

class JobMax8 : JobMax
{
%TypeHeaderCode
#include <jobmax8.h>

%End
public:
	JobMax8();

	JobMax8( uint key );

	JobMax8( const JobMax8 & other );

	JobMax8( const Record & r );

	JobMax8( RecordImp * imp, bool checkType = true );
	
	MappedJobMax8 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMax8List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax8 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax8Schema * schema();
};


