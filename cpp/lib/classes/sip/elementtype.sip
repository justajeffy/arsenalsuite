
%MappedType MappedElementType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementtypelist.h"
#include "elementtypetable.h"
#define MappedElementType ElementType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ElementType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ElementTypeSchema::instance() );
%End
};

class ElementType : Record
{
%TypeHeaderCode
#include <elementtype.h>

%End
public:
	ElementType();

	ElementType( uint key );

	ElementType( const ElementType & other );

	ElementType( const Record & r );

	ElementType( RecordImp * imp, bool checkType = true );
	
	MappedElementType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedElementType & setName( const QString & );
	QString sortPrefix() const;
	MappedElementType & setSortPrefix( const QString & );


	static MappedElementTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedElementType reload( bool lockForUpdate = false );

	static MappedElementType recordByName( const QString &elementType );





	static MappedRecord assetGroupType();




	static Table * table();
	//static ElementTypeSchema * schema();
};


