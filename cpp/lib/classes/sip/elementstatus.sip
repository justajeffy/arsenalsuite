
%MappedType MappedElementStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementstatuslist.h"
#include "elementstatustable.h"
#define MappedElementStatus ElementStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ElementStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ElementStatusSchema::instance() );
%End
};

class ElementStatus : Record
{
%TypeHeaderCode
#include <elementstatus.h>
#include "statusset.h"

%End
public:
	ElementStatus();

	ElementStatus( uint key );

	ElementStatus( const ElementStatus & other );

	ElementStatus( const Record & r );

	ElementStatus( RecordImp * imp, bool checkType = true );
	
	MappedElementStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedElementStatus & setName( const QString & );
	QString color() const;
	MappedElementStatus & setColor( const QString & );
	MappedStatusSet statusSet() const;
	MappedElementStatus & setStatusSet( const StatusSet & );
	int order() const;
	MappedElementStatus & setOrder( const int & );


	static MappedElementStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedElementStatus reload( bool lockForUpdate = false );

	static MappedElementStatusList recordsByStatusSet( const StatusSet &fkeyStatusSet );
	static MappedElementStatus recordByName( const QString &name );






	static Table * table();
	//static ElementStatusSchema * schema();
};


