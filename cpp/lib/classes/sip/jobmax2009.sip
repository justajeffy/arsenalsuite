
%MappedType MappedJobMax2009
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax2009list.h"
#include "jobmax2009table.h"
#define MappedJobMax2009 JobMax2009
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax2009(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax2009Schema::instance() );
%End
};

class JobMax2009 : JobMax
{
%TypeHeaderCode
#include <jobmax2009.h>

%End
public:
	JobMax2009();

	JobMax2009( uint key );

	JobMax2009( const JobMax2009 & other );

	JobMax2009( const Record & r );

	JobMax2009( RecordImp * imp, bool checkType = true );
	
	MappedJobMax2009 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMax2009List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax2009 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax2009Schema * schema();
};


