
%MappedType Mappedt__
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "tl__list.h"
#include "tl__table.h"
#define Mappedt__ t__
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new t__(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, t__Schema::instance() );
%End
};

class t__ : b__
{
%TypeHeaderCode
#include <tl__.h>
<%CLASSHEADERS%>
%End
public:
	t__();

	t__( uint key );

	t__( const t__ & other );

	t__( const Record & r );

	t__( RecordImp * imp, bool checkType = true );
	
	Mappedt__ copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

<%METHODDEFS%>

	static Mappedt__List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	Mappedt__ reload( bool lockForUpdate = false );

<%INDEXDEFS%>

<%ELEMENTHACKS%>

<%BASEHEADER%>

	static Table * table();
	//static t__Schema * schema();
};


