


%MappedType MappedUserMappingList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "usermappinglist.h"
#include "usermappingtable.h"
#define MappedUserMappingList UserMappingList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, UserMappingSchema::instance() );
%End
};

class UserMappingList : RecordList
{
%TypeHeaderCode
#include <usermappinglist.h>
#include "user.h"
#include "mapping.h"

%End
public:
	UserMappingList();
	UserMappingList( const RecordList &, Table * t = 0 );
	UserMappingList( const UserMappingList & );
	UserMappingList( const Record &, Table * t = 0 );
	
	~UserMappingList();

//	void insert( UserMappingIter, const UserMapping & );

//	UserMappingIter at( uint );

//	UserMappingIter find( const Record & );

//	UserMappingIter remove( const UserMappingIter & );

	int remove( const Record & );
	
	int remove();
	
	//UserMappingIter begin();

	//UserMappingIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedUserMappingList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedUserMappingList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedUserMappingList sorted( const QString & c, bool a = true ) const;

	MappedUserMappingList unique() const;
	MappedUserMappingList reversed() const;
	MappedUserMappingList reloaded() const;

	MappedUserList users() const;
	MappedUserMappingList & setUsers( const User & );
	MappedMappingList mappings() const;
	MappedUserMappingList & setMappings( const Mapping & );


};


