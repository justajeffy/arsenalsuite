


%MappedType MappedJobRealFlowList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobrealflowlist.h"
#include "jobrealflowtable.h"
#define MappedJobRealFlowList JobRealFlowList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobRealFlowSchema::instance() );
%End
};

class JobRealFlowList : JobList
{
%TypeHeaderCode
#include <jobrealflowlist.h>

%End
public:
	JobRealFlowList();
	JobRealFlowList( const RecordList &, Table * t = 0 );
	JobRealFlowList( const JobRealFlowList & );
	JobRealFlowList( const Record &, Table * t = 0 );
	
	~JobRealFlowList();

//	void insert( JobRealFlowIter, const JobRealFlow & );

//	JobRealFlowIter at( uint );

//	JobRealFlowIter find( const Record & );

//	JobRealFlowIter remove( const JobRealFlowIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobRealFlowIter begin();

	//JobRealFlowIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobRealFlowList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobRealFlowList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobRealFlowList sorted( const QString & c, bool a = true ) const;

	MappedJobRealFlowList unique() const;
	MappedJobRealFlowList reversed() const;
	MappedJobRealFlowList reloaded() const;

	QList<int> frameStarts() const;
	MappedJobRealFlowList & setFrameStarts( const int & );
	QList<int> frameEnds() const;
	MappedJobRealFlowList & setFrameEnds( const int & );
	QStringList simTypes() const;
	MappedJobRealFlowList & setSimTypes( const QString & );
	QList<uint> threadses() const;
	MappedJobRealFlowList & setThreadses( const uint & );


};


