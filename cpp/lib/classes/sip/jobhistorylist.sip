


%MappedType MappedJobHistoryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhistorylist.h"
#include "jobhistorytable.h"
#define MappedJobHistoryList JobHistoryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobHistorySchema::instance() );
%End
};

class JobHistoryList : RecordList
{
%TypeHeaderCode
#include <jobhistorylist.h>
#include "jobhistorytype.h"
#include "job.h"
#include "host.h"
#include "user.h"

%End
public:
	JobHistoryList();
	JobHistoryList( const RecordList &, Table * t = 0 );
	JobHistoryList( const JobHistoryList & );
	JobHistoryList( const Record &, Table * t = 0 );
	
	~JobHistoryList();

//	void insert( JobHistoryIter, const JobHistory & );

//	JobHistoryIter at( uint );

//	JobHistoryIter find( const Record & );

//	JobHistoryIter remove( const JobHistoryIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobHistoryIter begin();

	//JobHistoryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobHistoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobHistoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobHistoryList sorted( const QString & c, bool a = true ) const;

	MappedJobHistoryList unique() const;
	MappedJobHistoryList reversed() const;
	MappedJobHistoryList reloaded() const;

	MappedJobHistoryTypeList types() const;
	MappedJobHistoryList & setTypes( const JobHistoryType & );
	MappedJobList jobs() const;
	MappedJobHistoryList & setJobs( const Job & );
	MappedHostList hosts() const;
	MappedJobHistoryList & setHosts( const Host & );
	MappedUserList users() const;
	MappedJobHistoryList & setUsers( const User & );
	QStringList messages() const;
	MappedJobHistoryList & setMessages( const QString & );
	QList<QDateTime> created() const;
	MappedJobHistoryList & setCreated( const QDateTime & );


};


