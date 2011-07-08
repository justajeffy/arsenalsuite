


%MappedType MappedElementTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementtypelist.h"
#include "elementtypetable.h"
#define MappedElementTypeList ElementTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ElementTypeSchema::instance() );
%End
};

class ElementTypeList : RecordList
{
%TypeHeaderCode
#include <elementtypelist.h>

%End
public:
	ElementTypeList();
	ElementTypeList( const RecordList &, Table * t = 0 );
	ElementTypeList( const ElementTypeList & );
	ElementTypeList( const Record &, Table * t = 0 );
	
	~ElementTypeList();

//	void insert( ElementTypeIter, const ElementType & );

//	ElementTypeIter at( uint );

//	ElementTypeIter find( const Record & );

//	ElementTypeIter remove( const ElementTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//ElementTypeIter begin();

	//ElementTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedElementTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedElementTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedElementTypeList sorted( const QString & c, bool a = true ) const;

	MappedElementTypeList unique() const;
	MappedElementTypeList reversed() const;
	MappedElementTypeList reloaded() const;

	QStringList names() const;
	MappedElementTypeList & setNames( const QString & );
	QStringList sortPrefixs() const;
	MappedElementTypeList & setSortPrefixs( const QString & );


};


