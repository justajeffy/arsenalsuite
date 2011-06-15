
%MappedType MappedHostGroupItem
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostgroupitemlist.h"
#include "hostgroupitemtable.h"
#define MappedHostGroupItem HostGroupItem
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostGroupItem(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostGroupItemSchema::instance() );
%End
};

class HostGroupItem : Record
{
%TypeHeaderCode
#include <hostgroupitem.h>
#include "hostgroup.h"
#include "host.h"

%End
public:
	HostGroupItem();

	HostGroupItem( uint key );

	HostGroupItem( const HostGroupItem & other );

	HostGroupItem( const Record & r );

	HostGroupItem( RecordImp * imp, bool checkType = true );
	
	MappedHostGroupItem copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHostGroup hostGroup() const;
	MappedHostGroupItem & setHostGroup( const HostGroup & );
	MappedHost host() const;
	MappedHostGroupItem & setHost( const Host & );


	static MappedHostGroupItemList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostGroupItem reload( bool lockForUpdate = false );

	static MappedHostGroupItemList recordsByHostGroup( const HostGroup &fkeyHostGroup );
	static MappedHostGroupItemList recordsByHost( const Host &fkeyHost );






	static Table * table();
	//static HostGroupItemSchema * schema();
};


