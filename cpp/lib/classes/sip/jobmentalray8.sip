
%MappedType MappedJobMentalRay8
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray8list.h"
#include "jobmentalray8table.h"
#define MappedJobMentalRay8 JobMentalRay8
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMentalRay8(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMentalRay8Schema::instance() );
%End
};

class JobMentalRay8 : JobMaya
{
%TypeHeaderCode
#include <jobmentalray8.h>

%End
public:
	JobMentalRay8();

	JobMentalRay8( uint key );

	JobMentalRay8( const JobMentalRay8 & other );

	JobMentalRay8( const Record & r );

	JobMentalRay8( RecordImp * imp, bool checkType = true );
	
	MappedJobMentalRay8 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobMentalRay8List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMentalRay8 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMentalRay8Schema * schema();
};


