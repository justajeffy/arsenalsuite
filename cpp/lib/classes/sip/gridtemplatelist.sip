


%MappedType MappedGridTemplateList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gridtemplatelist.h"
#include "gridtemplatetable.h"
#define MappedGridTemplateList GridTemplateList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GridTemplateSchema::instance() );
%End
};

class GridTemplateList : RecordList
{
%TypeHeaderCode
#include <gridtemplatelist.h>
#include "project.h"

%End
public:
	GridTemplateList();
	GridTemplateList( const RecordList &, Table * t = 0 );
	GridTemplateList( const GridTemplateList & );
	GridTemplateList( const Record &, Table * t = 0 );
	
	~GridTemplateList();

//	void insert( GridTemplateIter, const GridTemplate & );

//	GridTemplateIter at( uint );

//	GridTemplateIter find( const Record & );

//	GridTemplateIter remove( const GridTemplateIter & );

	int remove( const Record & );
	
	int remove();
	
	//GridTemplateIter begin();

	//GridTemplateIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGridTemplateList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGridTemplateList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGridTemplateList sorted( const QString & c, bool a = true ) const;

	MappedGridTemplateList unique() const;
	MappedGridTemplateList reversed() const;
	MappedGridTemplateList reloaded() const;

	MappedProjectList projects() const;
	MappedGridTemplateList & setProjects( const Project & );
	QStringList names() const;
	MappedGridTemplateList & setNames( const QString & );


};


