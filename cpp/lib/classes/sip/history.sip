
%MappedType MappedHistory
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "historylist.h"
#include "historytable.h"
#define MappedHistory History
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new History(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HistorySchema::instance() );
%End
};

class History : Record
{
%TypeHeaderCode
#include <history.h>
#include "element.h"
#include "user.h"

%End
public:
	History();

	History( uint key );

	History( const History & other );

	History( const Record & r );

	History( RecordImp * imp, bool checkType = true );
	
	MappedHistory copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QDateTime date() const;
	MappedHistory & setDate( const QDateTime & );
	MappedElement element() const;
	MappedHistory & setElement( const Element & );
	MappedUser user() const;
	MappedHistory & setUser( const User & );
	QString text() const;
	MappedHistory & setText( const QString & );


	static MappedHistoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHistory reload( bool lockForUpdate = false );

	static MappedHistoryList recordsByElement( const Element &fkeyElement );
	static MappedHistoryList recordsByUser( const User &fkeyUsr );






	static Table * table();
	//static HistorySchema * schema();
};


