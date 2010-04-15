
%MappedType MappedJobStat
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobstatlist.h"
#include "jobstattable.h"
#define MappedJobStat JobStat
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobStat(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobStatSchema::instance() );
%End
};

class JobStat : Record
{
%TypeHeaderCode
#include <jobstat.h>
#include "element.h"
#include "user.h"
#include "project.h"

%End
public:
	JobStat();

	JobStat( uint key );

	JobStat( const JobStat & other );

	JobStat( const Record & r );

	JobStat( RecordImp * imp, bool checkType = true );
	
	MappedJobStat copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString pass() const;
	MappedJobStat & setPass( const QString & );
	MappedElement element() const;
	MappedJobStat & setElement( const Element & );
	int taskCount() const;
	MappedJobStat & setTaskCount( const int & );
	int tasksCompleted() const;
	MappedJobStat & setTasksCompleted( const int & );
	int taskTime() const;
	MappedJobStat & setTaskTime( const int & );
	QDateTime started() const;
	MappedJobStat & setStarted( const QDateTime & );
	QDateTime ended() const;
	MappedJobStat & setEnded( const QDateTime & );
	MappedUser user() const;
	MappedJobStat & setUser( const User & );
	MappedProject project() const;
	MappedJobStat & setProject( const Project & );
	QString name() const;
	MappedJobStat & setName( const QString & );
	int errorCount() const;
	MappedJobStat & setErrorCount( const int & );
	Interval totalTaskTime() const;
	MappedJobStat & setTotalTaskTime( const Interval & );
	Interval minTaskTime() const;
	MappedJobStat & setMinTaskTime( const Interval & );
	Interval maxTaskTime() const;
	MappedJobStat & setMaxTaskTime( const Interval & );
	Interval avgTaskTime() const;
	MappedJobStat & setAvgTaskTime( const Interval & );
	Interval totalErrorTime() const;
	MappedJobStat & setTotalErrorTime( const Interval & );
	Interval minErrorTime() const;
	MappedJobStat & setMinErrorTime( const Interval & );
	Interval maxErrorTime() const;
	MappedJobStat & setMaxErrorTime( const Interval & );
	Interval avgErrorTime() const;
	MappedJobStat & setAvgErrorTime( const Interval & );
	Interval totalLoadTime() const;
	MappedJobStat & setTotalLoadTime( const Interval & );
	Interval minLoadTime() const;
	MappedJobStat & setMinLoadTime( const Interval & );
	Interval maxLoadTime() const;
	MappedJobStat & setMaxLoadTime( const Interval & );
	Interval avgLoadTime() const;
	MappedJobStat & setAvgLoadTime( const Interval & );
	Interval totalCopyTime() const;
	MappedJobStat & setTotalCopyTime( const Interval & );
	Interval minCopyTime() const;
	MappedJobStat & setMinCopyTime( const Interval & );
	Interval maxCopyTime() const;
	MappedJobStat & setMaxCopyTime( const Interval & );
	Interval avgCopyTime() const;
	MappedJobStat & setAvgCopyTime( const Interval & );
	uint totalCpuTime() const;
	MappedJobStat & setTotalCpuTime( const uint & );
	uint minCpuTime() const;
	MappedJobStat & setMinCpuTime( const uint & );
	uint maxCpuTime() const;
	MappedJobStat & setMaxCpuTime( const uint & );
	uint avgCpuTime() const;
	MappedJobStat & setAvgCpuTime( const uint & );
	uint minMemory() const;
	MappedJobStat & setMinMemory( const uint & );
	uint maxMemory() const;
	MappedJobStat & setMaxMemory( const uint & );
	uint avgMemory() const;
	MappedJobStat & setAvgMemory( const uint & );
	float minEfficiency() const;
	MappedJobStat & setMinEfficiency( const float & );
	float maxEfficiency() const;
	MappedJobStat & setMaxEfficiency( const float & );
	float avgEfficiency() const;
	MappedJobStat & setAvgEfficiency( const float & );
	uint totalBytesRead() const;
	MappedJobStat & setTotalBytesRead( const uint & );
	uint minBytesRead() const;
	MappedJobStat & setMinBytesRead( const uint & );
	uint maxBytesRead() const;
	MappedJobStat & setMaxBytesRead( const uint & );
	uint avgBytesRead() const;
	MappedJobStat & setAvgBytesRead( const uint & );
	uint totalOpsRead() const;
	MappedJobStat & setTotalOpsRead( const uint & );
	uint minOpsRead() const;
	MappedJobStat & setMinOpsRead( const uint & );
	uint maxOpsRead() const;
	MappedJobStat & setMaxOpsRead( const uint & );
	uint avgOpsRead() const;
	MappedJobStat & setAvgOpsRead( const uint & );
	uint totalBytesWrite() const;
	MappedJobStat & setTotalBytesWrite( const uint & );
	uint minBytesWrite() const;
	MappedJobStat & setMinBytesWrite( const uint & );
	uint maxBytesWrite() const;
	MappedJobStat & setMaxBytesWrite( const uint & );
	uint avgBytesWrite() const;
	MappedJobStat & setAvgBytesWrite( const uint & );
	uint totalOpsWrite() const;
	MappedJobStat & setTotalOpsWrite( const uint & );
	uint minOpsWrite() const;
	MappedJobStat & setMinOpsWrite( const uint & );
	uint maxOpsWrite() const;
	MappedJobStat & setMaxOpsWrite( const uint & );
	uint avgOpsWrite() const;
	MappedJobStat & setAvgOpsWrite( const uint & );
	uint totalIoWait() const;
	MappedJobStat & setTotalIoWait( const uint & );
	uint minIoWait() const;
	MappedJobStat & setMinIoWait( const uint & );
	uint maxIoWait() const;
	MappedJobStat & setMaxIoWait( const uint & );
	uint avgIoWait() const;
	MappedJobStat & setAvgIoWait( const uint & );


	static MappedJobStatList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobStat reload( bool lockForUpdate = false );







	static Table * table();
	//static JobStatSchema * schema();
};


