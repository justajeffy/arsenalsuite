


%MappedType Mappedt__List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "tl__list.h"
#include "tl__table.h"
#define Mappedt__List t__List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, t__Schema::instance() );
%End
};

class t__List : b__List
{
%TypeHeaderCode
#include <tl__list.h>
<%CLASSHEADERS%>
%End
public:
	t__List();
	t__List( const RecordList &, Table * t = 0 );
	t__List( const t__List & );
	t__List( const Record &, Table * t = 0 );
	
	~t__List();

//	void insert( t__Iter, const t__ & );

//	t__Iter at( uint );

//	t__Iter find( const Record & );

//	t__Iter remove( const t__Iter & );

	int remove( const Record & );
	
	int remove();
	
	//t__Iter begin();

	//t__Iter end();

	Table * table() const;
	TableSchema * schema() const;

	Mappedt__List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	Mappedt__List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	Mappedt__List sorted( const QString & c, bool a = true ) const;

	Mappedt__List unique() const;
	Mappedt__List reversed() const;
	Mappedt__List reloaded() const;

<%LISTDEFS%>

};


