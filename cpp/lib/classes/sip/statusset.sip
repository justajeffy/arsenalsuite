
%MappedType MappedStatusSet
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "statussetlist.h"
#include "statussettable.h"
#define MappedStatusSet StatusSet
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new StatusSet(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, StatusSetSchema::instance() );
%End
};

class StatusSet : Record
{
%TypeHeaderCode
#include <statusset.h>
#include "elementstatus.h"

%End
public:
	StatusSet();

	StatusSet( uint key );

	StatusSet( const StatusSet & other );

	StatusSet( const Record & r );

	StatusSet( RecordImp * imp, bool checkType = true );
	
	MappedStatusSet copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedStatusSet & setName( const QString & );
	MappedElementStatusList elementStatuses() const;


	static MappedStatusSetList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedStatusSet reload( bool lockForUpdate = false );







	static Table * table();
	//static StatusSetSchema * schema();
};


