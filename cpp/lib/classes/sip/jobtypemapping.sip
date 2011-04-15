
%MappedType MappedJobTypeMapping
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtypemappinglist.h"
#include "jobtypemappingtable.h"
#define MappedJobTypeMapping JobTypeMapping
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobTypeMapping(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobTypeMappingSchema::instance() );
%End
};

class JobTypeMapping : Record
{
%TypeHeaderCode
#include <jobtypemapping.h>
#include "jobtype.h"
#include "mapping.h"

%End
public:
	JobTypeMapping();

	JobTypeMapping( uint key );

	JobTypeMapping( const JobTypeMapping & other );

	JobTypeMapping( const Record & r );

	JobTypeMapping( RecordImp * imp, bool checkType = true );
	
	MappedJobTypeMapping copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJobType jobType() const;
	MappedJobTypeMapping & setJobType( const JobType & );
	MappedMapping mapping() const;
	MappedJobTypeMapping & setMapping( const Mapping & );


	static MappedJobTypeMappingList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobTypeMapping reload( bool lockForUpdate = false );

	static MappedJobTypeMappingList recordsByJobType( const JobType &fkeyJobType );






	static Table * table();
	//static JobTypeMappingSchema * schema();
};


