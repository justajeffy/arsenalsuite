
%MappedType MappedJobDep
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobdeplist.h"
#include "jobdeptable.h"
#define MappedJobDep JobDep
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobDep(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobDepSchema::instance() );
%End
};

class JobDep : Record
{
%TypeHeaderCode
#include <jobdep.h>
#include "job.h"
#include "job.h"

%End
public:
	JobDep();

	JobDep( uint key );

	JobDep( const JobDep & other );

	JobDep( const Record & r );

	JobDep( RecordImp * imp, bool checkType = true );
	
	MappedJobDep copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJob job() const;
	MappedJobDep & setJob( const Job & );
	MappedJob dep() const;
	MappedJobDep & setDep( const Job & );
	uint depType() const;
	MappedJobDep & setDepType( const uint & );


	static MappedJobDepList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobDep reload( bool lockForUpdate = false );

	static MappedJobDepList recordsByJob( const Job &fkeyJob );
	static MappedJobDepList recordsByDep( const Job &fkeyDep );
	static MappedJobDep recordByJobAndDep( const Job &fkeyJob, const Job &fkeyDep );






	static Table * table();
	//static JobDepSchema * schema();
};


