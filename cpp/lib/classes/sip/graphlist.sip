


%MappedType MappedGraphList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphlist.h"
#include "graphtable.h"
#define MappedGraphList GraphList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GraphSchema::instance() );
%End
};

class GraphList : RecordList
{
%TypeHeaderCode
#include <graphlist.h>
#include "graphpage.h"
#include "graphrelationship.h"

%End
public:
	GraphList();
	GraphList( const RecordList &, Table * t = 0 );
	GraphList( const GraphList & );
	GraphList( const Record &, Table * t = 0 );
	
	~GraphList();

//	void insert( GraphIter, const Graph & );

//	GraphIter at( uint );

//	GraphIter find( const Record & );

//	GraphIter remove( const GraphIter & );

	int remove( const Record & );
	
	int remove();
	
	//GraphIter begin();

	//GraphIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGraphList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGraphList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGraphList sorted( const QString & c, bool a = true ) const;

	MappedGraphList unique() const;
	MappedGraphList reversed() const;
	MappedGraphList reloaded() const;

	QList<float> heights() const;
	MappedGraphList & setHeights( const float & );
	QList<float> widths() const;
	MappedGraphList & setWidths( const float & );
	QStringList vlabels() const;
	MappedGraphList & setVlabels( const QString & );
	QStringList periods() const;
	MappedGraphList & setPeriods( const QString & );
	QList<float> upperLimits() const;
	MappedGraphList & setUpperLimits( const float & );
	QList<float> lowerLimits() const;
	MappedGraphList & setLowerLimits( const float & );
	QList<bool> stacks() const;
	MappedGraphList & setStacks( const bool & );
	QList<bool> graphMaxs() const;
	MappedGraphList & setGraphMaxs( const bool & );
	MappedGraphPageList graphPages() const;
	MappedGraphList & setGraphPages( const GraphPage & );
	MappedGraphRelationshipList graphRelationships();


};


