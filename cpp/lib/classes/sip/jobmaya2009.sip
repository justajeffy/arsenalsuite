
%MappedType MappedJobMaya2009
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya2009list.h"
#include "jobmaya2009table.h"
#define MappedJobMaya2009 JobMaya2009
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya2009(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaya2009Schema::instance() );
%End
};

class JobMaya2009 : JobMaya
{
%TypeHeaderCode
#include <jobmaya2009.h>

%End
public:
	JobMaya2009();

	JobMaya2009( uint key );

	JobMaya2009( const JobMaya2009 & other );

	JobMaya2009( const Record & r );

	JobMaya2009( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya2009 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMaya2009List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya2009 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaya2009Schema * schema();
};


