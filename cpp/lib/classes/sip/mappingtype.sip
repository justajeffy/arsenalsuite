
%MappedType MappedMappingType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "mappingtypelist.h"
#include "mappingtypetable.h"
#define MappedMappingType MappingType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new MappingType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, MappingTypeSchema::instance() );
%End
};

class MappingType : Record
{
%TypeHeaderCode
#include <mappingtype.h>

%End
public:
	MappingType();

	MappingType( uint key );

	MappingType( const MappingType & other );

	MappingType( const Record & r );

	MappingType( RecordImp * imp, bool checkType = true );
	
	MappedMappingType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedMappingType & setName( const QString & );


	static MappedMappingTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedMappingType reload( bool lockForUpdate = false );







	static Table * table();
	//static MappingTypeSchema * schema();
};


