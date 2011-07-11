
%MappedType MappedGraphPage
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphpagelist.h"
#include "graphpagetable.h"
#define MappedGraphPage GraphPage
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GraphPage(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GraphPageSchema::instance() );
%End
};

class GraphPage : Record
{
%TypeHeaderCode
#include <graphpage.h>
#include "graphpage.h"
#include "graph.h"

%End
public:
	GraphPage();

	GraphPage( uint key );

	GraphPage( const GraphPage & other );

	GraphPage( const Record & r );

	GraphPage( RecordImp * imp, bool checkType = true );
	
	MappedGraphPage copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedGraphPage graphPage() const;
	MappedGraphPage & setGraphPage( const GraphPage & );
	QString name() const;
	MappedGraphPage & setName( const QString & );
	MappedGraph graph() const;


	static MappedGraphPageList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGraphPage reload( bool lockForUpdate = false );

	static MappedGraphPageList recordsByGraphPage( const GraphPage &fkeyGraphPage );
	static MappedGraphPage recordByname( const QString &name );






	static Table * table();
	//static GraphPageSchema * schema();
};


