


%MappedType MappedDynamicHostGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "dynamichostgrouplist.h"
#include "dynamichostgrouptable.h"
#define MappedDynamicHostGroupList DynamicHostGroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, DynamicHostGroupSchema::instance() );
%End
};

class DynamicHostGroupList : HostGroupList
{
%TypeHeaderCode
#include <dynamichostgrouplist.h>

%End
public:
	DynamicHostGroupList();
	DynamicHostGroupList( const RecordList &, Table * t = 0 );
	DynamicHostGroupList( const DynamicHostGroupList & );
	DynamicHostGroupList( const Record &, Table * t = 0 );
	
	~DynamicHostGroupList();

//	void insert( DynamicHostGroupIter, const DynamicHostGroup & );

//	DynamicHostGroupIter at( uint );

//	DynamicHostGroupIter find( const Record & );

//	DynamicHostGroupIter remove( const DynamicHostGroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//DynamicHostGroupIter begin();

	//DynamicHostGroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedDynamicHostGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedDynamicHostGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedDynamicHostGroupList sorted( const QString & c, bool a = true ) const;

	MappedDynamicHostGroupList unique() const;
	MappedDynamicHostGroupList reversed() const;
	MappedDynamicHostGroupList reloaded() const;

	QStringList hostWhereClauses() const;
	MappedDynamicHostGroupList & setHostWhereClauses( const QString & );


};


