
%MappedType MappedJobMaya2008
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya2008list.h"
#include "jobmaya2008table.h"
#define MappedJobMaya2008 JobMaya2008
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya2008(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaya2008Schema::instance() );
%End
};

class JobMaya2008 : JobMaya
{
%TypeHeaderCode
#include <jobmaya2008.h>

%End
public:
	JobMaya2008();

	JobMaya2008( uint key );

	JobMaya2008( const JobMaya2008 & other );

	JobMaya2008( const Record & r );

	JobMaya2008( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya2008 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMaya2008List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya2008 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaya2008Schema * schema();
};


