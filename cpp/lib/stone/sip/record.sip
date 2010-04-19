
%MappedType MappedRecord
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#define MappedRecord Record
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Record(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp );
%End
};

class Record
{

%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#undef arglist
%End

/*
%ConvertToSubClassCode
		sipClass = 0;
		Table * t = sipCpp->table();
		if( t ) {
			TableSchema * ts = t->schema();
			QPair<QString,QString> scm = getSchemaCastModule(ts->schema());
			if( ! scm.first.isEmpty() ) {
				QString type = ts->className();
				// This is very tricky.  We are actually casting up a Record object
				// This only works because all record subclasses contain NO extra
				// data, and there are no virtual functions.
				sipClass = getRecordWrapper( scm.first.toLatin1().constData(), scm.second + type );
			}
		}
%End
*/
public:
	Record( const Record & r );
	Record( RecordImp * /Transfer/, bool notused = false );
	Record( Table * table = 0 );

	~Record();

	bool operator==( const Record & other ) const;
	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = (long)sipCpp->key();
%End

/*
	SIP_PYOBJECT __getattr__( const QString & attrName );
%MethodCode
		LOG_5( "attrName = " + *a0 );
		Table * t = sipCpp->table();
		QVariant ret;
		do {
			if( t ) {
				TableSchema * ts = t->schema();
				if (ts && ts->field(*a0)) {
					ret = sipCpp->getValue(*a0);
					break;
				}
			}
			sipIsErr = 1;
		} while (0);
		if( !sipIsErr ) {
			sipRes = wrapQVariant(ret,false,false);
			sipIsErr = (sipRes==0);
		}
%End

	SIP_PYOBJECT __setattr__( const QString & attrName, SIP_PYOBJECT value );
%MethodCode
		Table * t = sipCpp->table();
		QVariant ret;
		do {
			if( t ) {
				TableSchema * ts = t->schema();
				if (ts && ts->field(*a0)) {
					sipCpp->setValue(*a0,unwrapQVariant(a1));
					break;
				}
			}
			sipIsErr = 1;
		} while (0);
%End
*/

	bool isValid() const;

	bool isRecord() const;

	unsigned int key( bool generate = false ) const;

	QVariant getValue( const QString & column ) const;

	MappedRecord & setValue( const QString & column, const QVariant & value );

	MappedRecord & setColumnLiteral( const QString & column, const QString & literal );
	
	MappedRecord & setForeignKey( const QString & column, const Record & other );
	MappedRecord foreignKey( const QString & column ) const;
	MappedRecord foreignKey( int column ) const;

	QString columnLiteral( const QString & column ) const;
	
	QVariant getValue( int column ) const;

	MappedRecord & setValue( int column, const QVariant & value );

	QString stateString() const;
	QString dump() const;

	int remove();

	MappedRecord & reload( bool lockForUpdate=false );

	MappedRecord & commit( bool sync = true );

	RecordImp * imp() const;

	bool isUpdated() const;

	Table * table() const;

	MappedRecord copy() const;

	static int totalRecordCount();
	static int totalRecordImpCount();
};

