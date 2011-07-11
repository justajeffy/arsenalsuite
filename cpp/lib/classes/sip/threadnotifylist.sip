


%MappedType MappedThreadNotifyList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "threadnotifylist.h"
#include "threadnotifytable.h"
#define MappedThreadNotifyList ThreadNotifyList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ThreadNotifySchema::instance() );
%End
};

class ThreadNotifyList : RecordList
{
%TypeHeaderCode
#include <threadnotifylist.h>
#include "thread.h"
#include "user.h"

%End
public:
	ThreadNotifyList();
	ThreadNotifyList( const RecordList &, Table * t = 0 );
	ThreadNotifyList( const ThreadNotifyList & );
	ThreadNotifyList( const Record &, Table * t = 0 );
	
	~ThreadNotifyList();

//	void insert( ThreadNotifyIter, const ThreadNotify & );

//	ThreadNotifyIter at( uint );

//	ThreadNotifyIter find( const Record & );

//	ThreadNotifyIter remove( const ThreadNotifyIter & );

	int remove( const Record & );
	
	int remove();
	
	//ThreadNotifyIter begin();

	//ThreadNotifyIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedThreadNotifyList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedThreadNotifyList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedThreadNotifyList sorted( const QString & c, bool a = true ) const;

	MappedThreadNotifyList unique() const;
	MappedThreadNotifyList reversed() const;
	MappedThreadNotifyList reloaded() const;

	MappedThreadList threads() const;
	MappedThreadNotifyList & setThreads( const Thread & );
	MappedUserList users() const;
	MappedThreadNotifyList & setUsers( const User & );
	QList<uint> optionses() const;
	MappedThreadNotifyList & setOptionses( const uint & );


};


