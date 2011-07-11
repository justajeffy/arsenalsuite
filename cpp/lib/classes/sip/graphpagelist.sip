


%MappedType MappedGraphPageList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphpagelist.h"
#include "graphpagetable.h"
#define MappedGraphPageList GraphPageList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GraphPageSchema::instance() );
%End
};

class GraphPageList : RecordList
{
%TypeHeaderCode
#include <graphpagelist.h>
#include "graphpage.h"
#include "graph.h"

%End
public:
	GraphPageList();
	GraphPageList( const RecordList &, Table * t = 0 );
	GraphPageList( const GraphPageList & );
	GraphPageList( const Record &, Table * t = 0 );
	
	~GraphPageList();

//	void insert( GraphPageIter, const GraphPage & );

//	GraphPageIter at( uint );

//	GraphPageIter find( const Record & );

//	GraphPageIter remove( const GraphPageIter & );

	int remove( const Record & );
	
	int remove();
	
	//GraphPageIter begin();

	//GraphPageIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGraphPageList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGraphPageList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGraphPageList sorted( const QString & c, bool a = true ) const;

	MappedGraphPageList unique() const;
	MappedGraphPageList reversed() const;
	MappedGraphPageList reloaded() const;

	MappedGraphPageList graphPages() const;
	MappedGraphPageList & setGraphPages( const GraphPage & );
	QStringList names() const;
	MappedGraphPageList & setNames( const QString & );
	MappedGraphList graphs();


};


