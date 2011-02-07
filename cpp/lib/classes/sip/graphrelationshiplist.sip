


%MappedType MappedGraphRelationshipList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphrelationshiplist.h"
#include "graphrelationshiptable.h"
#define MappedGraphRelationshipList GraphRelationshipList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GraphRelationshipSchema::instance() );
%End
};

class GraphRelationshipList : RecordList
{
%TypeHeaderCode
#include <graphrelationshiplist.h>
#include "graphds.h"
#include "graph.h"

%End
public:
	GraphRelationshipList();
	GraphRelationshipList( const RecordList &, Table * t = 0 );
	GraphRelationshipList( const GraphRelationshipList & );
	GraphRelationshipList( const Record &, Table * t = 0 );
	
	~GraphRelationshipList();

//	void insert( GraphRelationshipIter, const GraphRelationship & );

//	GraphRelationshipIter at( uint );

//	GraphRelationshipIter find( const Record & );

//	GraphRelationshipIter remove( const GraphRelationshipIter & );

	int remove( const Record & );
	
	int remove();
	
	//GraphRelationshipIter begin();

	//GraphRelationshipIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGraphRelationshipList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGraphRelationshipList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGraphRelationshipList sorted( const QString & c, bool a = true ) const;

	MappedGraphRelationshipList unique() const;
	MappedGraphRelationshipList reversed() const;
	MappedGraphRelationshipList reloaded() const;

	MappedGraphDsList graphDses() const;
	MappedGraphRelationshipList & setGraphDses( const GraphDs & );
	MappedGraphList graphs() const;
	MappedGraphRelationshipList & setGraphs( const Graph & );


};


