
// QList<uint> is implemented as a Python list of integers.
%MappedType QList<uint>
{
%TypeHeaderCode
#include <qlist.h>
%End

%ConvertFromTypeCode
    // Create the list.
    PyObject *l;

    if ((l = PyList_New(sipCpp->size())) == NULL)
        return NULL;

    // Set the list elements.
    for (int i = 0; i < sipCpp->size(); ++i)
    {
        PyObject *pobj;

        if ((pobj = PyInt_FromLong(sipCpp->value(i))) == NULL)
        {
            Py_DECREF(l);

            return NULL;
        }

        PyList_SET_ITEM(l, i, pobj);
    }

    return l;
%End

%ConvertToTypeCode
    // Check the type if that is all that is required.
    if (sipIsErr == NULL)
        return PyList_Check(sipPy);

    QList<uint> *ql = new QList<uint>;
 
    for (int i = 0; i < PyList_GET_SIZE(sipPy); ++i) {
		long l = PyInt_AsLong(PyList_GET_ITEM(sipPy, i));
        ql->append(l >= 0 ? l : 0);
 	}

    *sipCppPtr = ql;
 
    return sipGetState(sipTransferObj);
%End
};


%MappedType MappedRecordList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#define MappedRecordList RecordList
%End

// We are never going to use MappedRecord as a c++ method argument type
// only as a return type, so ConvertToTypeCode implementation isn't needed
%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp );
%End
};

class RecordList
{
%TypeHeaderCode
#include <recordlist.h>
%End
public:
	RecordList();
	RecordList( const RecordList & other, Table * table );
	RecordList( const RecordList & other );
	RecordList( const MappedRecord & rec, Table * table = 0 );

	MappedRecordList & operator += ( const Record & );
	MappedRecordList & operator += ( const RecordList & );

	MappedRecordList operator + ( const RecordList & );

	MappedRecordList & operator -= ( const RecordList & );
	MappedRecordList operator - ( const RecordList & );
	
	// Returns the intersection of the two lists
	MappedRecordList operator & ( const RecordList & );

	// Sets this as the intersection between this and other
	// returns a reference to this
	MappedRecordList & operator &= ( const RecordList & other );
	
	// Returns the union of this and other
	MappedRecordList operator | ( const RecordList & other );
	
	// Sets this to the union of this and other
	// Returns a reference to this
	MappedRecordList & operator |= ( const RecordList & other );
	
	bool operator==( const RecordList & );

//	RecordIter at( uint ) const;
//	RecordImp * imp( uint ) const;

	int findIndex( const Record & );
//	RecordIter find( const Record & );

	void append( const Record & );
	
//	void insert( RecordIter it, const Record & r );
	
	int remove( const Record & );
//	int remove( RecordImp * );

//	RecordIter remove( const RecordIter & );

	void clear();

	bool contains( const Record & ) const;
//	bool contains( RecordImp * ) const;

	bool isEmpty() const;

	unsigned int size() const;
	unsigned int count() const;
    int __len__();
%MethodCode
	sipRes = sipCpp->count();
%End

	MappedRecord operator[](int i);
%MethodCode
	int len;
	
	len = sipCpp->count();
	
	if ((a0 = sipConvertFromSequenceIndex(a0, len)) < 0)
		sipIsErr = 1;
	else
		sipRes = new Record((*sipCpp)[a0]);
%End

	void commit( bool newPrimaryKeys = true, bool sync = true );
	int remove();

	QList<QVariant> getValue( const QString & column );
	void setValue( const QString & column, const QVariant & value );

	QList<QVariant> getValue( int column );
	void setValue( int column, const QVariant & value );

	QString	keyString() const;

	MappedRecordList foreignKey( int column ) const;
	MappedRecordList foreignKey( const QString & column ) const;

	void setColumnLiteral( const QString & column, const QString & value );

	QList<uint> keys( int idx=-1 ) const;

//	RecordIter begin() const;

//	RecordIter end() const;

	Table * table() const;

	MappedRecordList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedRecordList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const;

	MappedRecordList sorted( const QString & column, bool asc = true ) const;

	MappedRecordList unique() const;

	MappedRecordList reversed() const;

	MappedRecordList copy( bool updateCopiedRelations = false );
	
	void reload();

	MappedRecordList reloaded() const;

	QString dump() const;
};

