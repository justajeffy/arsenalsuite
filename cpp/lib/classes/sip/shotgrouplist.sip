


%MappedType MappedShotGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "shotgrouplist.h"
#include "shotgrouptable.h"
#define MappedShotGroupList ShotGroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ShotGroupSchema::instance() );
%End
};

class ShotGroupList : ElementList
{
%TypeHeaderCode
#include <shotgrouplist.h>

%End
public:
	ShotGroupList();
	ShotGroupList( const RecordList &, Table * t = 0 );
	ShotGroupList( const ShotGroupList & );
	ShotGroupList( const Record &, Table * t = 0 );
	
	~ShotGroupList();

//	void insert( ShotGroupIter, const ShotGroup & );

//	ShotGroupIter at( uint );

//	ShotGroupIter find( const Record & );

//	ShotGroupIter remove( const ShotGroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//ShotGroupIter begin();

	//ShotGroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedShotGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedShotGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedShotGroupList sorted( const QString & c, bool a = true ) const;

	MappedShotGroupList unique() const;
	MappedShotGroupList reversed() const;
	MappedShotGroupList reloaded() const;



};


