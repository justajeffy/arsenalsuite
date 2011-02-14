
%MappedType MappedJobMax10
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax10list.h"
#include "jobmax10table.h"
#define MappedJobMax10 JobMax10
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax10(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax10Schema::instance() );
%End
};

class JobMax10 : JobMax
{
%TypeHeaderCode
#include <jobmax10.h>

%End
public:
	JobMax10();

	JobMax10( uint key );

	JobMax10( const JobMax10 & other );

	JobMax10( const Record & r );

	JobMax10( RecordImp * imp, bool checkType = true );
	
	MappedJobMax10 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMax10List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax10 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax10Schema * schema();
};


