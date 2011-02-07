


%MappedType MappedElementUserList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementuserlist.h"
#include "elementusertable.h"
#define MappedElementUserList ElementUserList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ElementUserSchema::instance() );
%End
};

class ElementUserList : RecordList
{
%TypeHeaderCode
#include <elementuserlist.h>
#include "element.h"
#include "user.h"
#include "assettype.h"

%End
public:
	ElementUserList();
	ElementUserList( const RecordList &, Table * t = 0 );
	ElementUserList( const ElementUserList & );
	ElementUserList( const Record &, Table * t = 0 );
	
	~ElementUserList();

//	void insert( ElementUserIter, const ElementUser & );

//	ElementUserIter at( uint );

//	ElementUserIter find( const Record & );

//	ElementUserIter remove( const ElementUserIter & );

	int remove( const Record & );
	
	int remove();
	
	//ElementUserIter begin();

	//ElementUserIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedElementUserList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedElementUserList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedElementUserList sorted( const QString & c, bool a = true ) const;

	MappedElementUserList unique() const;
	MappedElementUserList reversed() const;
	MappedElementUserList reloaded() const;

	MappedElementList elements() const;
	MappedElementUserList & setElements( const Element & );
	MappedUserList users() const;
	MappedElementUserList & setUsers( const User & );
	QList<bool> actives() const;
	MappedElementUserList & setActives( const bool & );
	MappedAssetTypeList assetTypes() const;
	MappedElementUserList & setAssetTypes( const AssetType & );


};


