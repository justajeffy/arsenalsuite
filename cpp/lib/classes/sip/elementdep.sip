
%MappedType MappedElementDep
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementdeplist.h"
#include "elementdeptable.h"
#define MappedElementDep ElementDep
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ElementDep(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ElementDepSchema::instance() );
%End
};

class ElementDep : Record
{
%TypeHeaderCode
#include <elementdep.h>
#include "element.h"
#include "element.h"

%End
public:
	ElementDep();

	ElementDep( uint key );

	ElementDep( const ElementDep & other );

	ElementDep( const Record & r );

	ElementDep( RecordImp * imp, bool checkType = true );
	
	MappedElementDep copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedElementDep & setElement( const Element & );
	MappedElement elementDep() const;
	MappedElementDep & setElementDep( const Element & );


	static MappedElementDepList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedElementDep reload( bool lockForUpdate = false );

	static MappedElementDepList recordsByElement( const Element &fkeyElement );
	static MappedElementDepList recordsByElementDep( const Element &fkeyElementDep );






	static Table * table();
	//static ElementDepSchema * schema();
};


