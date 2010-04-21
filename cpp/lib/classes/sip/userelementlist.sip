


%MappedType MappedUserElementList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userelementlist.h"
#include "userelementtable.h"
#define MappedUserElementList UserElementList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, UserElementSchema::instance() );
%End
};

class UserElementList : RecordList
{
%TypeHeaderCode
#include <userelementlist.h>
#include "user.h"
#include "element.h"

%End
public:
	UserElementList();
	UserElementList( const RecordList &, Table * t = 0 );
	UserElementList( const UserElementList & );
	UserElementList( const Record &, Table * t = 0 );
	
	~UserElementList();

//	void insert( UserElementIter, const UserElement & );

//	UserElementIter at( uint );

//	UserElementIter find( const Record & );

//	UserElementIter remove( const UserElementIter & );

	int remove( const Record & );
	
	int remove();
	
	//UserElementIter begin();

	//UserElementIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedUserElementList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedUserElementList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedUserElementList sorted( const QString & c, bool a = true ) const;

	MappedUserElementList unique() const;
	MappedUserElementList reversed() const;
	MappedUserElementList reloaded() const;

	MappedUserList users() const;
	MappedUserElementList & setUsers( const User & );
	MappedElementList elements() const;
	MappedUserElementList & setElements( const Element & );


};


