


%MappedType MappedPathTemplateList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathtemplatelist.h"
#include "pathtemplatetable.h"
#define MappedPathTemplateList PathTemplateList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, PathTemplateSchema::instance() );
%End
};

class PathTemplateList : RecordList
{
%TypeHeaderCode
#include <pathtemplatelist.h>

%End
public:
	PathTemplateList();
	PathTemplateList( const RecordList &, Table * t = 0 );
	PathTemplateList( const PathTemplateList & );
	PathTemplateList( const Record &, Table * t = 0 );
	
	~PathTemplateList();

//	void insert( PathTemplateIter, const PathTemplate & );

//	PathTemplateIter at( uint );

//	PathTemplateIter find( const Record & );

//	PathTemplateIter remove( const PathTemplateIter & );

	int remove( const Record & );
	
	int remove();
	
	//PathTemplateIter begin();

	//PathTemplateIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedPathTemplateList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedPathTemplateList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedPathTemplateList sorted( const QString & c, bool a = true ) const;

	MappedPathTemplateList unique() const;
	MappedPathTemplateList reversed() const;
	MappedPathTemplateList reloaded() const;

	QList<int> versions() const;
	MappedPathTemplateList & setVersions( const int & );
	QStringList fileNameTemplates() const;
	MappedPathTemplateList & setFileNameTemplates( const QString & );
	QStringList pathTemplates() const;
	MappedPathTemplateList & setPathTemplates( const QString & );
	QStringList names() const;
	MappedPathTemplateList & setNames( const QString & );
	QStringList pythonCodes() const;
	MappedPathTemplateList & setPythonCodes( const QString & );


};


