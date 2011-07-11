


%MappedType MappedDeliveryElementList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "deliveryelementlist.h"
#include "deliveryelementtable.h"
#define MappedDeliveryElementList DeliveryElementList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, DeliveryElementSchema::instance() );
%End
};

class DeliveryElementList : RecordList
{
%TypeHeaderCode
#include <deliveryelementlist.h>
#include "delivery.h"
#include "element.h"

%End
public:
	DeliveryElementList();
	DeliveryElementList( const RecordList &, Table * t = 0 );
	DeliveryElementList( const DeliveryElementList & );
	DeliveryElementList( const Record &, Table * t = 0 );
	
	~DeliveryElementList();

//	void insert( DeliveryElementIter, const DeliveryElement & );

//	DeliveryElementIter at( uint );

//	DeliveryElementIter find( const Record & );

//	DeliveryElementIter remove( const DeliveryElementIter & );

	int remove( const Record & );
	
	int remove();
	
	//DeliveryElementIter begin();

	//DeliveryElementIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedDeliveryElementList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedDeliveryElementList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedDeliveryElementList sorted( const QString & c, bool a = true ) const;

	MappedDeliveryElementList unique() const;
	MappedDeliveryElementList reversed() const;
	MappedDeliveryElementList reloaded() const;

	MappedDeliveryList deliveries() const;
	MappedDeliveryElementList & setDeliveries( const Delivery & );
	MappedElementList elements() const;
	MappedDeliveryElementList & setElements( const Element & );
	QList<uint> frameStarts() const;
	MappedDeliveryElementList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedDeliveryElementList & setFrameEnds( const uint & );


};


