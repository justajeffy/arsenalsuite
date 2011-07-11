


%MappedType MappedGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "grouplist.h"
#include "grouptable.h"
#define MappedGroupList GroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GroupSchema::instance() );
%End
};

class GroupList : RecordList
{
%TypeHeaderCode
#include <grouplist.h>
#include "groupmapping.h"

%End
public:
	GroupList();
	GroupList( const RecordList &, Table * t = 0 );
	GroupList( const GroupList & );
	GroupList( const Record &, Table * t = 0 );
	
	~GroupList();

//	void insert( GroupIter, const Group & );

//	GroupIter at( uint );

//	GroupIter find( const Record & );

//	GroupIter remove( const GroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//GroupIter begin();

	//GroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGroupList sorted( const QString & c, bool a = true ) const;

	MappedGroupList unique() const;
	MappedGroupList reversed() const;
	MappedGroupList reloaded() const;

	QStringList names() const;
	MappedGroupList & setNames( const QString & );
	MappedGroupMappingList groupMappings();


};


