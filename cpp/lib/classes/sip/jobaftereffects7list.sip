


%MappedType MappedJobAfterEffects7List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffects7list.h"
#include "jobaftereffects7table.h"
#define MappedJobAfterEffects7List JobAfterEffects7List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAfterEffects7Schema::instance() );
%End
};

class JobAfterEffects7List : JobAfterEffectsList
{
%TypeHeaderCode
#include <jobaftereffects7list.h>

%End
public:
	JobAfterEffects7List();
	JobAfterEffects7List( const RecordList &, Table * t = 0 );
	JobAfterEffects7List( const JobAfterEffects7List & );
	JobAfterEffects7List( const Record &, Table * t = 0 );
	
	~JobAfterEffects7List();

//	void insert( JobAfterEffects7Iter, const JobAfterEffects7 & );

//	JobAfterEffects7Iter at( uint );

//	JobAfterEffects7Iter find( const Record & );

//	JobAfterEffects7Iter remove( const JobAfterEffects7Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAfterEffects7Iter begin();

	//JobAfterEffects7Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAfterEffects7List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAfterEffects7List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAfterEffects7List sorted( const QString & c, bool a = true ) const;

	MappedJobAfterEffects7List unique() const;
	MappedJobAfterEffects7List reversed() const;
	MappedJobAfterEffects7List reloaded() const;



};


