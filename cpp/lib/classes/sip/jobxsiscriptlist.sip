


%MappedType MappedJobXSIScriptList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsiscriptlist.h"
#include "jobxsiscripttable.h"
#define MappedJobXSIScriptList JobXSIScriptList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobXSIScriptSchema::instance() );
%End
};

class JobXSIScriptList : JobList
{
%TypeHeaderCode
#include <jobxsiscriptlist.h>

%End
public:
	JobXSIScriptList();
	JobXSIScriptList( const RecordList &, Table * t = 0 );
	JobXSIScriptList( const JobXSIScriptList & );
	JobXSIScriptList( const Record &, Table * t = 0 );
	
	~JobXSIScriptList();

//	void insert( JobXSIScriptIter, const JobXSIScript & );

//	JobXSIScriptIter at( uint );

//	JobXSIScriptIter find( const Record & );

//	JobXSIScriptIter remove( const JobXSIScriptIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobXSIScriptIter begin();

	//JobXSIScriptIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobXSIScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobXSIScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobXSIScriptList sorted( const QString & c, bool a = true ) const;

	MappedJobXSIScriptList unique() const;
	MappedJobXSIScriptList reversed() const;
	MappedJobXSIScriptList reloaded() const;

	QList<int> frameStarts() const;
	MappedJobXSIScriptList & setFrameStarts( const int & );
	QList<int> frameEnds() const;
	MappedJobXSIScriptList & setFrameEnds( const int & );
	QList<bool> scriptRequiresUis() const;
	MappedJobXSIScriptList & setScriptRequiresUis( const bool & );
	QStringList scriptFiles() const;
	MappedJobXSIScriptList & setScriptFiles( const QString & );
	QStringList xsiFiles() const;
	MappedJobXSIScriptList & setXsiFiles( const QString & );
	QStringList scriptMethods() const;
	MappedJobXSIScriptList & setScriptMethods( const QString & );
	QStringList frameLists() const;
	MappedJobXSIScriptList & setFrameLists( const QString & );


};


