
%MappedType MappedHostGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostgrouplist.h"
#include "hostgrouptable.h"
#define MappedHostGroup HostGroup
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostGroup(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostGroupSchema::instance() );
%End
};

class HostGroup : Record
{
%TypeHeaderCode
#include <hostgroup.h>
#include "user.h"
#include "hostgroupitem.h"

%End
public:
	HostGroup();

	HostGroup( uint key );

	HostGroup( const HostGroup & other );

	HostGroup( const Record & r );

	HostGroup( RecordImp * imp, bool checkType = true );
	
	MappedHostGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedHostGroup & setName( const QString & );
	MappedUser user() const;
	MappedHostGroup & setUser( const User & );
	bool private_() const;
	MappedHostGroup & setPrivate_( const bool & );
	MappedHostGroupItemList hostGroupItems() const;


	static MappedHostGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostGroup reload( bool lockForUpdate = false );

	static MappedHostGroupList recordsByUser( const User &fkeyUsr );
	static MappedHostGroup recordByNameAndUser( const QString &HostGroup, const User &fkeyUsr );
	static MappedHostGroup recordByName( const QString &HostGroup );





MappedRecordList hosts();
void addHost( const Host & );
void removeHost( const Host & );
int status();


	static Table * table();
	//static HostGroupSchema * schema();
};


