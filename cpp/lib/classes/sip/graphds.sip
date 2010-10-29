
%MappedType MappedGraphDs
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphdslist.h"
#include "graphdstable.h"
#define MappedGraphDs GraphDs
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GraphDs(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GraphDsSchema::instance() );
%End
};

class GraphDs : Record
{
%TypeHeaderCode
#include <graphds.h>
#include "host.h"

%End
public:
	GraphDs();

	GraphDs( uint key );

	GraphDs( const GraphDs & other );

	GraphDs( const Record & r );

	GraphDs( RecordImp * imp, bool checkType = true );
	
	MappedGraphDs copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString varname() const;
	MappedGraphDs & setVarname( const QString & );
	QString dsType() const;
	MappedGraphDs & setDsType( const QString & );
	MappedHost host() const;
	MappedGraphDs & setHost( const Host & );
	QString cdef() const;
	MappedGraphDs & setCdef( const QString & );
	QString fieldName() const;
	MappedGraphDs & setFieldName( const QString & );
	QString fileName() const;
	MappedGraphDs & setFileName( const QString & );
	bool negative() const;
	MappedGraphDs & setNegative( const bool & );
	QString graphds() const;
	MappedGraphDs & setGraphds( const QString & );


	static MappedGraphDsList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGraphDs reload( bool lockForUpdate = false );







	static Table * table();
	//static GraphDsSchema * schema();
};


