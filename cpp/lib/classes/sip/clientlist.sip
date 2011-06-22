


%MappedType MappedClientList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "clientlist.h"
#include "clienttable.h"
#define MappedClientList ClientList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ClientSchema::instance() );
%End
};

class ClientList : RecordList
{
%TypeHeaderCode
#include <clientlist.h>

%End
public:
	ClientList();
	ClientList( const RecordList &, Table * t = 0 );
	ClientList( const ClientList & );
	ClientList( const Record &, Table * t = 0 );
	
	~ClientList();

//	void insert( ClientIter, const Client & );

//	ClientIter at( uint );

//	ClientIter find( const Record & );

//	ClientIter remove( const ClientIter & );

	int remove( const Record & );
	
	int remove();
	
	//ClientIter begin();

	//ClientIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedClientList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedClientList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedClientList sorted( const QString & c, bool a = true ) const;

	MappedClientList unique() const;
	MappedClientList reversed() const;
	MappedClientList reloaded() const;

	QStringList names() const;
	MappedClientList & setNames( const QString & );
	QStringList textcards() const;
	MappedClientList & setTextcards( const QString & );


};


