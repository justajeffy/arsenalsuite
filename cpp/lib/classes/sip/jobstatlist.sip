


%MappedType MappedJobStatList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobstatlist.h"
#include "jobstattable.h"
#define MappedJobStatList JobStatList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobStatSchema::instance() );
%End
};

class JobStatList : RecordList
{
%TypeHeaderCode
#include <jobstatlist.h>
#include "element.h"
#include "user.h"
#include "project.h"

%End
public:
	JobStatList();
	JobStatList( const RecordList &, Table * t = 0 );
	JobStatList( const JobStatList & );
	JobStatList( const Record &, Table * t = 0 );
	
	~JobStatList();

//	void insert( JobStatIter, const JobStat & );

//	JobStatIter at( uint );

//	JobStatIter find( const Record & );

//	JobStatIter remove( const JobStatIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobStatIter begin();

	//JobStatIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobStatList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobStatList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobStatList sorted( const QString & c, bool a = true ) const;

	MappedJobStatList unique() const;
	MappedJobStatList reversed() const;
	MappedJobStatList reloaded() const;

	QStringList passes() const;
	MappedJobStatList & setPasses( const QString & );
	MappedElementList elements() const;
	MappedJobStatList & setElements( const Element & );
	QList<int> taskCounts() const;
	MappedJobStatList & setTaskCounts( const int & );
	QList<int> tasksCompleted() const;
	MappedJobStatList & setTasksCompleted( const int & );
	QList<int> taskTimes() const;
	MappedJobStatList & setTaskTimes( const int & );
	QList<QDateTime> started() const;
	MappedJobStatList & setStarted( const QDateTime & );
	QList<QDateTime> ended() const;
	MappedJobStatList & setEnded( const QDateTime & );
	MappedUserList users() const;
	MappedJobStatList & setUsers( const User & );
	MappedProjectList projects() const;
	MappedJobStatList & setProjects( const Project & );
	QStringList names() const;
	MappedJobStatList & setNames( const QString & );
	QList<int> errorCounts() const;
	MappedJobStatList & setErrorCounts( const int & );
	QList<Interval> totalTaskTimes() const;
	MappedJobStatList & setTotalTaskTimes( const Interval & );
	QList<Interval> minTaskTimes() const;
	MappedJobStatList & setMinTaskTimes( const Interval & );
	QList<Interval> maxTaskTimes() const;
	MappedJobStatList & setMaxTaskTimes( const Interval & );
	QList<Interval> avgTaskTimes() const;
	MappedJobStatList & setAvgTaskTimes( const Interval & );
	QList<Interval> totalErrorTimes() const;
	MappedJobStatList & setTotalErrorTimes( const Interval & );
	QList<Interval> minErrorTimes() const;
	MappedJobStatList & setMinErrorTimes( const Interval & );
	QList<Interval> maxErrorTimes() const;
	MappedJobStatList & setMaxErrorTimes( const Interval & );
	QList<Interval> avgErrorTimes() const;
	MappedJobStatList & setAvgErrorTimes( const Interval & );
	QList<Interval> totalLoadTimes() const;
	MappedJobStatList & setTotalLoadTimes( const Interval & );
	QList<Interval> minLoadTimes() const;
	MappedJobStatList & setMinLoadTimes( const Interval & );
	QList<Interval> maxLoadTimes() const;
	MappedJobStatList & setMaxLoadTimes( const Interval & );
	QList<Interval> avgLoadTimes() const;
	MappedJobStatList & setAvgLoadTimes( const Interval & );
	QList<Interval> totalCopyTimes() const;
	MappedJobStatList & setTotalCopyTimes( const Interval & );
	QList<Interval> minCopyTimes() const;
	MappedJobStatList & setMinCopyTimes( const Interval & );
	QList<Interval> maxCopyTimes() const;
	MappedJobStatList & setMaxCopyTimes( const Interval & );
	QList<Interval> avgCopyTimes() const;
	MappedJobStatList & setAvgCopyTimes( const Interval & );
	QList<uint> totalCpuTimes() const;
	MappedJobStatList & setTotalCpuTimes( const uint & );
	QList<uint> minCpuTimes() const;
	MappedJobStatList & setMinCpuTimes( const uint & );
	QList<uint> maxCpuTimes() const;
	MappedJobStatList & setMaxCpuTimes( const uint & );
	QList<uint> avgCpuTimes() const;
	MappedJobStatList & setAvgCpuTimes( const uint & );
	QList<uint> minMemories() const;
	MappedJobStatList & setMinMemories( const uint & );
	QList<uint> maxMemories() const;
	MappedJobStatList & setMaxMemories( const uint & );
	QList<uint> avgMemories() const;
	MappedJobStatList & setAvgMemories( const uint & );
	QList<float> minEfficiencies() const;
	MappedJobStatList & setMinEfficiencies( const float & );
	QList<float> maxEfficiencies() const;
	MappedJobStatList & setMaxEfficiencies( const float & );
	QList<float> avgEfficiencies() const;
	MappedJobStatList & setAvgEfficiencies( const float & );
	QList<uint> totalBytesReads() const;
	MappedJobStatList & setTotalBytesReads( const uint & );
	QList<uint> minBytesReads() const;
	MappedJobStatList & setMinBytesReads( const uint & );
	QList<uint> maxBytesReads() const;
	MappedJobStatList & setMaxBytesReads( const uint & );
	QList<uint> avgBytesReads() const;
	MappedJobStatList & setAvgBytesReads( const uint & );
	QList<uint> totalOpsReads() const;
	MappedJobStatList & setTotalOpsReads( const uint & );
	QList<uint> minOpsReads() const;
	MappedJobStatList & setMinOpsReads( const uint & );
	QList<uint> maxOpsReads() const;
	MappedJobStatList & setMaxOpsReads( const uint & );
	QList<uint> avgOpsReads() const;
	MappedJobStatList & setAvgOpsReads( const uint & );
	QList<uint> totalBytesWrites() const;
	MappedJobStatList & setTotalBytesWrites( const uint & );
	QList<uint> minBytesWrites() const;
	MappedJobStatList & setMinBytesWrites( const uint & );
	QList<uint> maxBytesWrites() const;
	MappedJobStatList & setMaxBytesWrites( const uint & );
	QList<uint> avgBytesWrites() const;
	MappedJobStatList & setAvgBytesWrites( const uint & );
	QList<uint> totalOpsWrites() const;
	MappedJobStatList & setTotalOpsWrites( const uint & );
	QList<uint> minOpsWrites() const;
	MappedJobStatList & setMinOpsWrites( const uint & );
	QList<uint> maxOpsWrites() const;
	MappedJobStatList & setMaxOpsWrites( const uint & );
	QList<uint> avgOpsWrites() const;
	MappedJobStatList & setAvgOpsWrites( const uint & );
	QList<uint> totalIoWaits() const;
	MappedJobStatList & setTotalIoWaits( const uint & );
	QList<uint> minIoWaits() const;
	MappedJobStatList & setMinIoWaits( const uint & );
	QList<uint> maxIoWaits() const;
	MappedJobStatList & setMaxIoWaits( const uint & );
	QList<uint> avgIoWaits() const;
	MappedJobStatList & setAvgIoWaits( const uint & );


};


