


%MappedType MappedElementStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementstatuslist.h"
#include "elementstatustable.h"
#define MappedElementStatusList ElementStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ElementStatusSchema::instance() );
%End
};

class ElementStatusList : RecordList
{
%TypeHeaderCode
#include <elementstatuslist.h>
#include "statusset.h"

%End
public:
	ElementStatusList();
	ElementStatusList( const RecordList &, Table * t = 0 );
	ElementStatusList( const ElementStatusList & );
	ElementStatusList( const Record &, Table * t = 0 );
	
	~ElementStatusList();

//	void insert( ElementStatusIter, const ElementStatus & );

//	ElementStatusIter at( uint );

//	ElementStatusIter find( const Record & );

//	ElementStatusIter remove( const ElementStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//ElementStatusIter begin();

	//ElementStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedElementStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedElementStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedElementStatusList sorted( const QString & c, bool a = true ) const;

	MappedElementStatusList unique() const;
	MappedElementStatusList reversed() const;
	MappedElementStatusList reloaded() const;

	QStringList names() const;
	MappedElementStatusList & setNames( const QString & );
	QStringList colors() const;
	MappedElementStatusList & setColors( const QString & );
	MappedStatusSetList statusSets() const;
	MappedElementStatusList & setStatusSets( const StatusSet & );
	QList<int> orders() const;
	MappedElementStatusList & setOrders( const int & );


};


