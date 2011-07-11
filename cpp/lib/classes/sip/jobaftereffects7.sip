
%MappedType MappedJobAfterEffects7
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffects7list.h"
#include "jobaftereffects7table.h"
#define MappedJobAfterEffects7 JobAfterEffects7
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAfterEffects7(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAfterEffects7Schema::instance() );
%End
};

class JobAfterEffects7 : JobAfterEffects
{
%TypeHeaderCode
#include <jobaftereffects7.h>

%End
public:
	JobAfterEffects7();

	JobAfterEffects7( uint key );

	JobAfterEffects7( const JobAfterEffects7 & other );

	JobAfterEffects7( const Record & r );

	JobAfterEffects7( RecordImp * imp, bool checkType = true );
	
	MappedJobAfterEffects7 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobAfterEffects7List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAfterEffects7 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobAfterEffects7Schema * schema();
};


