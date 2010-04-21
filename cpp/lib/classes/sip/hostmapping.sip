
%MappedType MappedHostMapping
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostmappinglist.h"
#include "hostmappingtable.h"
#define MappedHostMapping HostMapping
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostMapping(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostMappingSchema::instance() );
%End
};

class HostMapping : Record
{
%TypeHeaderCode
#include <hostmapping.h>
#include "host.h"
#include "mapping.h"

%End
public:
	HostMapping();

	HostMapping( uint key );

	HostMapping( const HostMapping & other );

	HostMapping( const Record & r );

	HostMapping( RecordImp * imp, bool checkType = true );
	
	MappedHostMapping copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostMapping & setHost( const Host & );
	MappedMapping mapping() const;
	MappedHostMapping & setMapping( const Mapping & );


	static MappedHostMappingList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostMapping reload( bool lockForUpdate = false );

	static MappedHostMappingList recordsByMapping( const Mapping &fkeyMapping );






	static Table * table();
	//static HostMappingSchema * schema();
};


