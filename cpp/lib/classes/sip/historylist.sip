


%MappedType MappedHistoryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "historylist.h"
#include "historytable.h"
#define MappedHistoryList HistoryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HistorySchema::instance() );
%End
};

class HistoryList : RecordList
{
%TypeHeaderCode
#include <historylist.h>
#include "element.h"
#include "user.h"

%End
public:
	HistoryList();
	HistoryList( const RecordList &, Table * t = 0 );
	HistoryList( const HistoryList & );
	HistoryList( const Record &, Table * t = 0 );
	
	~HistoryList();

//	void insert( HistoryIter, const History & );

//	HistoryIter at( uint );

//	HistoryIter find( const Record & );

//	HistoryIter remove( const HistoryIter & );

	int remove( const Record & );
	
	int remove();
	
	//HistoryIter begin();

	//HistoryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHistoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHistoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHistoryList sorted( const QString & c, bool a = true ) const;

	MappedHistoryList unique() const;
	MappedHistoryList reversed() const;
	MappedHistoryList reloaded() const;

	QList<QDateTime> dates() const;
	MappedHistoryList & setDates( const QDateTime & );
	MappedElementList elements() const;
	MappedHistoryList & setElements( const Element & );
	MappedUserList users() const;
	MappedHistoryList & setUsers( const User & );
	QStringList texts() const;
	MappedHistoryList & setTexts( const QString & );


};


