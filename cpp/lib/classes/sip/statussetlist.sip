


%MappedType MappedStatusSetList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "statussetlist.h"
#include "statussettable.h"
#define MappedStatusSetList StatusSetList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, StatusSetSchema::instance() );
%End
};

class StatusSetList : RecordList
{
%TypeHeaderCode
#include <statussetlist.h>
#include "elementstatus.h"

%End
public:
	StatusSetList();
	StatusSetList( const RecordList &, Table * t = 0 );
	StatusSetList( const StatusSetList & );
	StatusSetList( const Record &, Table * t = 0 );
	
	~StatusSetList();

//	void insert( StatusSetIter, const StatusSet & );

//	StatusSetIter at( uint );

//	StatusSetIter find( const Record & );

//	StatusSetIter remove( const StatusSetIter & );

	int remove( const Record & );
	
	int remove();
	
	//StatusSetIter begin();

	//StatusSetIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedStatusSetList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedStatusSetList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedStatusSetList sorted( const QString & c, bool a = true ) const;

	MappedStatusSetList unique() const;
	MappedStatusSetList reversed() const;
	MappedStatusSetList reloaded() const;

	QStringList names() const;
	MappedStatusSetList & setNames( const QString & );
	MappedElementStatusList elementStatuses();


};


