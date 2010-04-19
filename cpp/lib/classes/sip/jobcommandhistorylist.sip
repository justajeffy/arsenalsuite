


%MappedType MappedJobCommandHistoryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcommandhistorylist.h"
#include "jobcommandhistorytable.h"
#define MappedJobCommandHistoryList JobCommandHistoryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobCommandHistorySchema::instance() );
%End
};

class JobCommandHistoryList : RecordList
{
%TypeHeaderCode
#include <jobcommandhistorylist.h>
#include "job.h"
#include "host.h"
#include "hosthistory.h"

%End
public:
	JobCommandHistoryList();
	JobCommandHistoryList( const RecordList &, Table * t = 0 );
	JobCommandHistoryList( const JobCommandHistoryList & );
	JobCommandHistoryList( const Record &, Table * t = 0 );
	
	~JobCommandHistoryList();

//	void insert( JobCommandHistoryIter, const JobCommandHistory & );

//	JobCommandHistoryIter at( uint );

//	JobCommandHistoryIter find( const Record & );

//	JobCommandHistoryIter remove( const JobCommandHistoryIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobCommandHistoryIter begin();

	//JobCommandHistoryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobCommandHistoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobCommandHistoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobCommandHistoryList sorted( const QString & c, bool a = true ) const;

	MappedJobCommandHistoryList unique() const;
	MappedJobCommandHistoryList reversed() const;
	MappedJobCommandHistoryList reloaded() const;

	QStringList stdErrs() const;
	MappedJobCommandHistoryList & setStdErrs( const QString & );
	QStringList stdOuts() const;
	MappedJobCommandHistoryList & setStdOuts( const QString & );
	QStringList commands() const;
	MappedJobCommandHistoryList & setCommands( const QString & );
	QList<uint> memories() const;
	MappedJobCommandHistoryList & setMemories( const uint & );
	MappedJobList jobs() const;
	MappedJobCommandHistoryList & setJobs( const Job & );
	MappedHostList hosts() const;
	MappedJobCommandHistoryList & setHosts( const Host & );
	MappedHostHistoryList hostHistories() const;
	MappedJobCommandHistoryList & setHostHistories( const HostHistory & );
	QList<float> realtimes() const;
	MappedJobCommandHistoryList & setRealtimes( const float & );
	QList<float> usertimes() const;
	MappedJobCommandHistoryList & setUsertimes( const float & );
	QList<float> systimes() const;
	MappedJobCommandHistoryList & setSystimes( const float & );
	QList<uint> iowaits() const;
	MappedJobCommandHistoryList & setIowaits( const uint & );


};


