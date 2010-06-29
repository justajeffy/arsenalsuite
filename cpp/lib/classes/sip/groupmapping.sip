
%MappedType MappedGroupMapping
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "groupmappinglist.h"
#include "groupmappingtable.h"
#define MappedGroupMapping GroupMapping
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GroupMapping(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GroupMappingSchema::instance() );
%End
};

class GroupMapping : Record
{
%TypeHeaderCode
#include <groupmapping.h>
#include "group.h"
#include "mapping.h"

%End
public:
	GroupMapping();

	GroupMapping( uint key );

	GroupMapping( const GroupMapping & other );

	GroupMapping( const Record & r );

	GroupMapping( RecordImp * imp, bool checkType = true );
	
	MappedGroupMapping copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedGroup group() const;
	MappedGroupMapping & setGroup( const Group & );
	MappedMapping mapping() const;
	MappedGroupMapping & setMapping( const Mapping & );


	static MappedGroupMappingList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGroupMapping reload( bool lockForUpdate = false );

	static MappedGroupMappingList recordsBygroup( const Group &fkeyGrp );






	static Table * table();
	//static GroupMappingSchema * schema();
};


