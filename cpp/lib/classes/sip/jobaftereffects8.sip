
%MappedType MappedJobAfterEffects8
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffects8list.h"
#include "jobaftereffects8table.h"
#define MappedJobAfterEffects8 JobAfterEffects8
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAfterEffects8(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAfterEffects8Schema::instance() );
%End
};

class JobAfterEffects8 : JobAfterEffects
{
%TypeHeaderCode
#include <jobaftereffects8.h>

%End
public:
	JobAfterEffects8();

	JobAfterEffects8( uint key );

	JobAfterEffects8( const JobAfterEffects8 & other );

	JobAfterEffects8( const Record & r );

	JobAfterEffects8( RecordImp * imp, bool checkType = true );
	
	MappedJobAfterEffects8 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobAfterEffects8List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAfterEffects8 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobAfterEffects8Schema * schema();
};


