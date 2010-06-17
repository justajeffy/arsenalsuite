


%MappedType MappedJobErrorHandlerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorhandlerlist.h"
#include "joberrorhandlertable.h"
#define MappedJobErrorHandlerList JobErrorHandlerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobErrorHandlerSchema::instance() );
%End
};

class JobErrorHandlerList : RecordList
{
%TypeHeaderCode
#include <joberrorhandlerlist.h>
#include "jobtype.h"
#include "joberrorhandlerscript.h"

%End
public:
	JobErrorHandlerList();
	JobErrorHandlerList( const RecordList &, Table * t = 0 );
	JobErrorHandlerList( const JobErrorHandlerList & );
	JobErrorHandlerList( const Record &, Table * t = 0 );
	
	~JobErrorHandlerList();

//	void insert( JobErrorHandlerIter, const JobErrorHandler & );

//	JobErrorHandlerIter at( uint );

//	JobErrorHandlerIter find( const Record & );

//	JobErrorHandlerIter remove( const JobErrorHandlerIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobErrorHandlerIter begin();

	//JobErrorHandlerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobErrorHandlerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobErrorHandlerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobErrorHandlerList sorted( const QString & c, bool a = true ) const;

	MappedJobErrorHandlerList unique() const;
	MappedJobErrorHandlerList reversed() const;
	MappedJobErrorHandlerList reloaded() const;

	MappedJobTypeList jobTypes() const;
	MappedJobErrorHandlerList & setJobTypes( const JobType & );
	QStringList errorRegExs() const;
	MappedJobErrorHandlerList & setErrorRegExs( const QString & );
	MappedJobErrorHandlerScriptList jobErrorHandlerScripts() const;
	MappedJobErrorHandlerList & setJobErrorHandlerScripts( const JobErrorHandlerScript & );


};


