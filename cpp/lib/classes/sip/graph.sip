
%MappedType MappedGraph
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphlist.h"
#include "graphtable.h"
#define MappedGraph Graph
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Graph(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GraphSchema::instance() );
%End
};

class Graph : Record
{
%TypeHeaderCode
#include <graph.h>
#include "graphpage.h"
#include "graphrelationship.h"

%End
public:
	Graph();

	Graph( uint key );

	Graph( const Graph & other );

	Graph( const Record & r );

	Graph( RecordImp * imp, bool checkType = true );
	
	MappedGraph copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	float height() const;
	MappedGraph & setHeight( const float & );
	float width() const;
	MappedGraph & setWidth( const float & );
	QString vlabel() const;
	MappedGraph & setVlabel( const QString & );
	QString period() const;
	MappedGraph & setPeriod( const QString & );
	float upperLimit() const;
	MappedGraph & setUpperLimit( const float & );
	float lowerLimit() const;
	MappedGraph & setLowerLimit( const float & );
	bool stack() const;
	MappedGraph & setStack( const bool & );
	bool graphMax() const;
	MappedGraph & setGraphMax( const bool & );
	MappedGraphPage graphPage() const;
	MappedGraph & setGraphPage( const GraphPage & );
	MappedGraphRelationshipList graphRelationships() const;


	static MappedGraphList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGraph reload( bool lockForUpdate = false );

	static MappedGraph recordByGraphPage( const GraphPage &fkeyGraphPage );






	static Table * table();
	//static GraphSchema * schema();
};


