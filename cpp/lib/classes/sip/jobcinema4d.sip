
%MappedType MappedJobCinema4D
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcinema4dlist.h"
#include "jobcinema4dtable.h"
#define MappedJobCinema4D JobCinema4D
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobCinema4D(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobCinema4DSchema::instance() );
%End
};

class JobCinema4D : Job
{
%TypeHeaderCode
#include <jobcinema4d.h>

%End
public:
	JobCinema4D();

	JobCinema4D( uint key );

	JobCinema4D( const JobCinema4D & other );

	JobCinema4D( const Record & r );

	JobCinema4D( RecordImp * imp, bool checkType = true );
	
	MappedJobCinema4D copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedJobCinema4DList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobCinema4D reload( bool lockForUpdate = false );







	static Table * table();
	//static JobCinema4DSchema * schema();
};


