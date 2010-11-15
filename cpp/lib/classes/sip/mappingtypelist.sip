


%MappedType MappedMappingTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "mappingtypelist.h"
#include "mappingtypetable.h"
#define MappedMappingTypeList MappingTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, MappingTypeSchema::instance() );
%End
};

class MappingTypeList : RecordList
{
%TypeHeaderCode
#include <mappingtypelist.h>

%End
public:
	MappingTypeList();
	MappingTypeList( const RecordList &, Table * t = 0 );
	MappingTypeList( const MappingTypeList & );
	MappingTypeList( const Record &, Table * t = 0 );
	
	~MappingTypeList();

//	void insert( MappingTypeIter, const MappingType & );

//	MappingTypeIter at( uint );

//	MappingTypeIter find( const Record & );

//	MappingTypeIter remove( const MappingTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//MappingTypeIter begin();

	//MappingTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedMappingTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedMappingTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedMappingTypeList sorted( const QString & c, bool a = true ) const;

	MappedMappingTypeList unique() const;
	MappedMappingTypeList reversed() const;
	MappedMappingTypeList reloaded() const;

	QStringList names() const;
	MappedMappingTypeList & setNames( const QString & );


};


