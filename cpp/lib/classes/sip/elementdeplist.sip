


%MappedType MappedElementDepList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementdeplist.h"
#include "elementdeptable.h"
#define MappedElementDepList ElementDepList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ElementDepSchema::instance() );
%End
};

class ElementDepList : RecordList
{
%TypeHeaderCode
#include <elementdeplist.h>
#include "element.h"
#include "element.h"

%End
public:
	ElementDepList();
	ElementDepList( const RecordList &, Table * t = 0 );
	ElementDepList( const ElementDepList & );
	ElementDepList( const Record &, Table * t = 0 );
	
	~ElementDepList();

//	void insert( ElementDepIter, const ElementDep & );

//	ElementDepIter at( uint );

//	ElementDepIter find( const Record & );

//	ElementDepIter remove( const ElementDepIter & );

	int remove( const Record & );
	
	int remove();
	
	//ElementDepIter begin();

	//ElementDepIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedElementDepList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedElementDepList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedElementDepList sorted( const QString & c, bool a = true ) const;

	MappedElementDepList unique() const;
	MappedElementDepList reversed() const;
	MappedElementDepList reloaded() const;

	MappedElementList elements() const;
	MappedElementDepList & setElements( const Element & );
	MappedElementList elementDeps() const;
	MappedElementDepList & setElementDeps( const Element & );


};


