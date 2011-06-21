


%MappedType MappedGruntScriptList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gruntscriptlist.h"
#include "gruntscripttable.h"
#define MappedGruntScriptList GruntScriptList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GruntScriptSchema::instance() );
%End
};

class GruntScriptList : RecordList
{
%TypeHeaderCode
#include <gruntscriptlist.h>

%End
public:
	GruntScriptList();
	GruntScriptList( const RecordList &, Table * t = 0 );
	GruntScriptList( const GruntScriptList & );
	GruntScriptList( const Record &, Table * t = 0 );
	
	~GruntScriptList();

//	void insert( GruntScriptIter, const GruntScript & );

//	GruntScriptIter at( uint );

//	GruntScriptIter find( const Record & );

//	GruntScriptIter remove( const GruntScriptIter & );

	int remove( const Record & );
	
	int remove();
	
	//GruntScriptIter begin();

	//GruntScriptIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGruntScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGruntScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGruntScriptList sorted( const QString & c, bool a = true ) const;

	MappedGruntScriptList unique() const;
	MappedGruntScriptList reversed() const;
	MappedGruntScriptList reloaded() const;

	QList<uint> runCounts() const;
	MappedGruntScriptList & setRunCounts( const uint & );
	QList<QDate> lastRuns() const;
	MappedGruntScriptList & setLastRuns( const QDate & );
	QStringList names() const;
	MappedGruntScriptList & setNames( const QString & );


};


