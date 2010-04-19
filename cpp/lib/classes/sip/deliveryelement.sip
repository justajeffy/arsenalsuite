
%MappedType MappedDeliveryElement
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "deliveryelementlist.h"
#include "deliveryelementtable.h"
#define MappedDeliveryElement DeliveryElement
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new DeliveryElement(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, DeliveryElementSchema::instance() );
%End
};

class DeliveryElement : Record
{
%TypeHeaderCode
#include <deliveryelement.h>
#include "delivery.h"
#include "element.h"

%End
public:
	DeliveryElement();

	DeliveryElement( uint key );

	DeliveryElement( const DeliveryElement & other );

	DeliveryElement( const Record & r );

	DeliveryElement( RecordImp * imp, bool checkType = true );
	
	MappedDeliveryElement copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedDelivery delivery() const;
	MappedDeliveryElement & setDelivery( const Delivery & );
	MappedElement element() const;
	MappedDeliveryElement & setElement( const Element & );
	uint frameStart() const;
	MappedDeliveryElement & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedDeliveryElement & setFrameEnd( const uint & );


	static MappedDeliveryElementList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedDeliveryElement reload( bool lockForUpdate = false );

	static MappedDeliveryElementList recordsByElement( const Element &fkeyElement );






	static Table * table();
	//static DeliveryElementSchema * schema();
};


