
%MappedType MappedDelivery
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "deliverylist.h"
#include "deliverytable.h"
#define MappedDelivery Delivery
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Delivery(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, DeliverySchema::instance() );
%End
};

class Delivery : Element
{
%TypeHeaderCode
#include <delivery.h>

%End
public:
	Delivery();

	Delivery( uint key );

	Delivery( const Delivery & other );

	Delivery( const Record & r );

	Delivery( RecordImp * imp, bool checkType = true );
	
	MappedDelivery copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedDeliveryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedDelivery reload( bool lockForUpdate = false );



	static ElementType type();




	static Table * table();
	//static DeliverySchema * schema();
};


