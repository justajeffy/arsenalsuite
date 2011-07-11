
%MappedType MappedJobAssignmentStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobassignmentstatuslist.h"
#include "jobassignmentstatustable.h"
#define MappedJobAssignmentStatus JobAssignmentStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAssignmentStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAssignmentStatusSchema::instance() );
%End
};

class JobAssignmentStatus : Record
{
%TypeHeaderCode
#include <jobassignmentstatus.h>

%End
public:
	JobAssignmentStatus();

	JobAssignmentStatus( uint key );

	JobAssignmentStatus( const JobAssignmentStatus & other );

	JobAssignmentStatus( const Record & r );

	JobAssignmentStatus( RecordImp * imp, bool checkType = true );
	
	MappedJobAssignmentStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString status() const;
	MappedJobAssignmentStatus & setStatus( const QString & );


	static MappedJobAssignmentStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAssignmentStatus reload( bool lockForUpdate = false );

	static MappedJobAssignmentStatus recordBystatus( const QString &status );
	static MappedJobAssignmentStatus recordByName( const QString &status );






	static Table * table();
	//static JobAssignmentStatusSchema * schema();
};


