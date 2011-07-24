
%MappedType MappedMapping
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "mappinglist.h"
#include "mappingtable.h"
#define MappedMapping Mapping
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Mapping(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, MappingSchema::instance() );
%End
};

class Mapping : Record
{
%TypeHeaderCode
#include <mapping.h>
#include "host.h"
#include "mappingtype.h"
#include "hostmapping.h"

%End
public:
	Mapping();

	Mapping( uint key );

	Mapping( const Mapping & other );

	Mapping( const Record & r );

	Mapping( RecordImp * imp, bool checkType = true );
	
	MappedMapping copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedMapping & setHost( const Host & );
	QString share() const;
	MappedMapping & setShare( const QString & );
	MappedMappingType mappingType() const;
	MappedMapping & setMappingType( const MappingType & );
	QString mount() const;
	MappedMapping & setMount( const QString & );
	MappedHostMappingList hostMappings() const;


	static MappedMappingList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedMapping reload( bool lockForUpdate = false );






bool map( bool, QString * errorMsg );



	static Table * table();
	//static MappingSchema * schema();
};


