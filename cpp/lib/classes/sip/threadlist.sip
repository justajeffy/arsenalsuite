


%MappedType MappedThreadList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "threadlist.h"
#include "threadtable.h"
#define MappedThreadList ThreadList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ThreadSchema::instance() );
%End
};

class ThreadList : RecordList
{
%TypeHeaderCode
#include <threadlist.h>
#include "element.h"
#include "job.h"
#include "user.h"
#include "thread.h"
#include "threadnotify.h"

%End
public:
	ThreadList();
	ThreadList( const RecordList &, Table * t = 0 );
	ThreadList( const ThreadList & );
	ThreadList( const Record &, Table * t = 0 );
	
	~ThreadList();

//	void insert( ThreadIter, const Thread & );

//	ThreadIter at( uint );

//	ThreadIter find( const Record & );

//	ThreadIter remove( const ThreadIter & );

	int remove( const Record & );
	
	int remove();
	
	//ThreadIter begin();

	//ThreadIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedThreadList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedThreadList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedThreadList sorted( const QString & c, bool a = true ) const;

	MappedThreadList unique() const;
	MappedThreadList reversed() const;
	MappedThreadList reloaded() const;

	QList<QDateTime> dateTimes() const;
	MappedThreadList & setDateTimes( const QDateTime & );
	QStringList bodies() const;
	MappedThreadList & setBodies( const QString & );
	MappedElementList elements() const;
	MappedThreadList & setElements( const Element & );
	MappedJobList jobs() const;
	MappedThreadList & setJobs( const Job & );
	MappedUserList users() const;
	MappedThreadList & setUsers( const User & );
	MappedThreadList replies() const;
	MappedThreadList & setReplies( const Thread & );
	QStringList topics() const;
	MappedThreadList & setTopics( const QString & );
	QList<uint> todoStatuses() const;
	MappedThreadList & setTodoStatuses( const uint & );
	QList<uint> hasAttachmentses() const;
	MappedThreadList & setHasAttachmentses( const uint & );
	MappedThreadNotifyList threadNotifies();


};


