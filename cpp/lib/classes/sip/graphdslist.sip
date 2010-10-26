


%MappedType MappedGraphDsList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "graphdslist.h"
#include "graphdstable.h"
#define MappedGraphDsList GraphDsList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GraphDsSchema::instance() );
%End
};

class GraphDsList : RecordList
{
%TypeHeaderCode
#include <graphdslist.h>
#include "host.h"

%End
public:
	GraphDsList();
	GraphDsList( const RecordList &, Table * t = 0 );
	GraphDsList( const GraphDsList & );
	GraphDsList( const Record &, Table * t = 0 );
	
	~GraphDsList();

//	void insert( GraphDsIter, const GraphDs & );

//	GraphDsIter at( uint );

//	GraphDsIter find( const Record & );

//	GraphDsIter remove( const GraphDsIter & );

	int remove( const Record & );
	
	int remove();
	
	//GraphDsIter begin();

	//GraphDsIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGraphDsList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGraphDsList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGraphDsList sorted( const QString & c, bool a = true ) const;

	MappedGraphDsList unique() const;
	MappedGraphDsList reversed() const;
	MappedGraphDsList reloaded() const;

	QStringList varnames() const;
	MappedGraphDsList & setVarnames( const QString & );
	QStringList dsTypes() const;
	MappedGraphDsList & setDsTypes( const QString & );
	MappedHostList hosts() const;
	MappedGraphDsList & setHosts( const Host & );
	QStringList cdefs() const;
	MappedGraphDsList & setCdefs( const QString & );
	QStringList fieldNames() const;
	MappedGraphDsList & setFieldNames( const QString & );
	QStringList fileNames() const;
	MappedGraphDsList & setFileNames( const QString & );
	QList<bool> negatives() const;
	MappedGraphDsList & setNegatives( const bool & );
	QStringList graphdses() const;
	MappedGraphDsList & setGraphdses( const QString & );


};


