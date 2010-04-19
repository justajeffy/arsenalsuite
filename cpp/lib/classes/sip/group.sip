
%MappedType MappedGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "grouplist.h"
#include "grouptable.h"
#define MappedGroup Group
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Group(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GroupSchema::instance() );
%End
};

class Group : Record
{
%TypeHeaderCode
#include <group.h>
#include "groupmapping.h"

%End
public:
	Group();

	Group( uint key );

	Group( const Group & other );

	Group( const Record & r );

	Group( RecordImp * imp, bool checkType = true );
	
	MappedGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedGroup & setName( const QString & );
	MappedGroupMappingList groupMappings() const;


	static MappedGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGroup reload( bool lockForUpdate = false );

	static MappedGroup recordByName( const QString &grp );






	static Table * table();
	//static GroupSchema * schema();
};


