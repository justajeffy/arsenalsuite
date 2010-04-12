
%MappedType MappedJobMaya8
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya8list.h"
#include "jobmaya8table.h"
#define MappedJobMaya8 JobMaya8
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya8(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaya8Schema::instance() );
%End
};

class JobMaya8 : JobMaya
{
%TypeHeaderCode
#include <jobmaya8.h>

%End
public:
	JobMaya8();

	JobMaya8( uint key );

	JobMaya8( const JobMaya8 & other );

	JobMaya8( const Record & r );

	JobMaya8( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya8 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMaya8List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya8 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaya8Schema * schema();
};


