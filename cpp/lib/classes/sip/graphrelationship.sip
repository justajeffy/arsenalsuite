
%MappedType MappedGraphRelationship
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphrelationshiplist.h"
#include "graphrelationshiptable.h"
#define MappedGraphRelationship GraphRelationship
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GraphRelationship(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GraphRelationshipSchema::instance() );
%End
};

class GraphRelationship : Record
{
%TypeHeaderCode
#include <graphrelationship.h>
#include "graphds.h"
#include "graph.h"

%End
public:
	GraphRelationship();

	GraphRelationship( uint key );

	GraphRelationship( const GraphRelationship & other );

	GraphRelationship( const Record & r );

	GraphRelationship( RecordImp * imp, bool checkType = true );
	
	MappedGraphRelationship copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedGraphDs graphDs() const;
	MappedGraphRelationship & setGraphDs( const GraphDs & );
	MappedGraph graph() const;
	MappedGraphRelationship & setGraph( const Graph & );


	static MappedGraphRelationshipList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGraphRelationship reload( bool lockForUpdate = false );

	static MappedGraphRelationshipList recordsByGraphDs( const GraphDs &fkeyGraphDs );
	static MappedGraphRelationshipList recordsByGraph( const Graph &fkeyGraph );






	static Table * table();
	//static GraphRelationshipSchema * schema();
};


