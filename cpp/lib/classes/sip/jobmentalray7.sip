
%MappedType MappedJobMentalRay7
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray7list.h"
#include "jobmentalray7table.h"
#define MappedJobMentalRay7 JobMentalRay7
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMentalRay7(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMentalRay7Schema::instance() );
%End
};

class JobMentalRay7 : JobMaya
{
%TypeHeaderCode
#include <jobmentalray7.h>

%End
public:
	JobMentalRay7();

	JobMentalRay7( uint key );

	JobMentalRay7( const JobMentalRay7 & other );

	JobMentalRay7( const Record & r );

	JobMentalRay7( RecordImp * imp, bool checkType = true );
	
	MappedJobMentalRay7 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMentalRay7List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMentalRay7 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMentalRay7Schema * schema();
};


