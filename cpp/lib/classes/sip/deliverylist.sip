


%MappedType MappedDeliveryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "deliverylist.h"
#include "deliverytable.h"
#define MappedDeliveryList DeliveryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, DeliverySchema::instance() );
%End
};

class DeliveryList : ElementList
{
%TypeHeaderCode
#include <deliverylist.h>

%End
public:
	DeliveryList();
	DeliveryList( const RecordList &, Table * t = 0 );
	DeliveryList( const DeliveryList & );
	DeliveryList( const Record &, Table * t = 0 );
	
	~DeliveryList();

//	void insert( DeliveryIter, const Delivery & );

//	DeliveryIter at( uint );

//	DeliveryIter find( const Record & );

//	DeliveryIter remove( const DeliveryIter & );

	int remove( const Record & );
	
	int remove();
	
	//DeliveryIter begin();

	//DeliveryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedDeliveryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedDeliveryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedDeliveryList sorted( const QString & c, bool a = true ) const;

	MappedDeliveryList unique() const;
	MappedDeliveryList reversed() const;
	MappedDeliveryList reloaded() const;



};


