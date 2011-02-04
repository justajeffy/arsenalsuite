


%MappedType MappedLocationList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "locationlist.h"
#include "locationtable.h"
#define MappedLocationList LocationList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, LocationSchema::instance() );
%End
};

class LocationList : RecordList
{
%TypeHeaderCode
#include <locationlist.h>

%End
public:
	LocationList();
	LocationList( const RecordList &, Table * t = 0 );
	LocationList( const LocationList & );
	LocationList( const Record &, Table * t = 0 );
	
	~LocationList();

//	void insert( LocationIter, const Location & );

//	LocationIter at( uint );

//	LocationIter find( const Record & );

//	LocationIter remove( const LocationIter & );

	int remove( const Record & );
	
	int remove();
	
	//LocationIter begin();

	//LocationIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedLocationList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedLocationList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedLocationList sorted( const QString & c, bool a = true ) const;

	MappedLocationList unique() const;
	MappedLocationList reversed() const;
	MappedLocationList reloaded() const;

	QStringList names() const;
	MappedLocationList & setNames( const QString & );


};


