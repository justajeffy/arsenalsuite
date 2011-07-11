
%MappedType MappedJobService
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobservicelist.h"
#include "jobservicetable.h"
#define MappedJobService JobService
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobService(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobServiceSchema::instance() );
%End
};

class JobService : Record
{
%TypeHeaderCode
#include <jobservice.h>
#include "job.h"
#include "service.h"

%End
public:
	JobService();

	JobService( uint key );

	JobService( const JobService & other );

	JobService( const Record & r );

	JobService( RecordImp * imp, bool checkType = true );
	
	MappedJobService copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJob job() const;
	MappedJobService & setJob( const Job & );
	MappedService service() const;
	MappedJobService & setService( const Service & );


	static MappedJobServiceList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobService reload( bool lockForUpdate = false );

	static MappedJobServiceList recordsByJob( const Job &fkeyJob );
	static MappedJobServiceList recordsByService( const Service &fkeyService );






	static Table * table();
	//static JobServiceSchema * schema();
};


