


%MappedType MappedGroupMappingList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "groupmappinglist.h"
#include "groupmappingtable.h"
#define MappedGroupMappingList GroupMappingList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GroupMappingSchema::instance() );
%End
};

class GroupMappingList : RecordList
{
%TypeHeaderCode
#include <groupmappinglist.h>
#include "group.h"
#include "mapping.h"

%End
public:
	GroupMappingList();
	GroupMappingList( const RecordList &, Table * t = 0 );
	GroupMappingList( const GroupMappingList & );
	GroupMappingList( const Record &, Table * t = 0 );
	
	~GroupMappingList();

//	void insert( GroupMappingIter, const GroupMapping & );

//	GroupMappingIter at( uint );

//	GroupMappingIter find( const Record & );

//	GroupMappingIter remove( const GroupMappingIter & );

	int remove( const Record & );
	
	int remove();
	
	//GroupMappingIter begin();

	//GroupMappingIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGroupMappingList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGroupMappingList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGroupMappingList sorted( const QString & c, bool a = true ) const;

	MappedGroupMappingList unique() const;
	MappedGroupMappingList reversed() const;
	MappedGroupMappingList reloaded() const;

	MappedGroupList groups() const;
	MappedGroupMappingList & setGroups( const Group & );
	MappedMappingList mappings() const;
	MappedGroupMappingList & setMappings( const Mapping & );


};


