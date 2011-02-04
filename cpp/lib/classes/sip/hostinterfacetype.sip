
%MappedType MappedHostInterfaceType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostinterfacetypelist.h"
#include "hostinterfacetypetable.h"
#define MappedHostInterfaceType HostInterfaceType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostInterfaceType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostInterfaceTypeSchema::instance() );
%End
};

class HostInterfaceType : Record
{
%TypeHeaderCode
#include <hostinterfacetype.h>

%End
public:
	HostInterfaceType();

	HostInterfaceType( uint key );

	HostInterfaceType( const HostInterfaceType & other );

	HostInterfaceType( const Record & r );

	HostInterfaceType( RecordImp * imp, bool checkType = true );
	
	MappedHostInterfaceType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedHostInterfaceType & setName( const QString & );


	static MappedHostInterfaceTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostInterfaceType reload( bool lockForUpdate = false );

	static MappedHostInterfaceType recordByName( const QString &hostinterfacetype );






	static Table * table();
	//static HostInterfaceTypeSchema * schema();
};


