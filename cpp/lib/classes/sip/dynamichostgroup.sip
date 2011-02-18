
%MappedType MappedDynamicHostGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "dynamichostgrouplist.h"
#include "dynamichostgrouptable.h"
#define MappedDynamicHostGroup DynamicHostGroup
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new DynamicHostGroup(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, DynamicHostGroupSchema::instance() );
%End
};

class DynamicHostGroup : HostGroup
{
%TypeHeaderCode
#include <dynamichostgroup.h>

%End
public:
	DynamicHostGroup();

	DynamicHostGroup( uint key );

	DynamicHostGroup( const DynamicHostGroup & other );

	DynamicHostGroup( const Record & r );

	DynamicHostGroup( RecordImp * imp, bool checkType = true );
	
	MappedDynamicHostGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString hostWhereClause() const;
	MappedDynamicHostGroup & setHostWhereClause( const QString & );


	static MappedDynamicHostGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedDynamicHostGroup reload( bool lockForUpdate = false );







	static Table * table();
	//static DynamicHostGroupSchema * schema();
};


