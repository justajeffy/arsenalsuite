
%MappedType MappedJobMentalRay85
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray85list.h"
#include "jobmentalray85table.h"
#define MappedJobMentalRay85 JobMentalRay85
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMentalRay85(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMentalRay85Schema::instance() );
%End
};

class JobMentalRay85 : JobMaya
{
%TypeHeaderCode
#include <jobmentalray85.h>

%End
public:
	JobMentalRay85();

	JobMentalRay85( uint key );

	JobMentalRay85( const JobMentalRay85 & other );

	JobMentalRay85( const Record & r );

	JobMentalRay85( RecordImp * imp, bool checkType = true );
	
	MappedJobMentalRay85 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMentalRay85List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMentalRay85 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMentalRay85Schema * schema();
};


