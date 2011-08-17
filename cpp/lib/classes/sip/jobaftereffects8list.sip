


%MappedType MappedJobAfterEffects8List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffects8list.h"
#include "jobaftereffects8table.h"
#define MappedJobAfterEffects8List JobAfterEffects8List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAfterEffects8Schema::instance() );
%End
};

class JobAfterEffects8List : JobAfterEffectsList
{
%TypeHeaderCode
#include <jobaftereffects8list.h>

%End
public:
	JobAfterEffects8List();
	JobAfterEffects8List( const RecordList &, Table * t = 0 );
	JobAfterEffects8List( const JobAfterEffects8List & );
	JobAfterEffects8List( const Record &, Table * t = 0 );
	
	~JobAfterEffects8List();

//	void insert( JobAfterEffects8Iter, const JobAfterEffects8 & );

//	JobAfterEffects8Iter at( uint );

//	JobAfterEffects8Iter find( const Record & );

//	JobAfterEffects8Iter remove( const JobAfterEffects8Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAfterEffects8Iter begin();

	//JobAfterEffects8Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAfterEffects8List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAfterEffects8List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAfterEffects8List sorted( const QString & c, bool a = true ) const;

	MappedJobAfterEffects8List unique() const;
	MappedJobAfterEffects8List reversed() const;
	MappedJobAfterEffects8List reloaded() const;



};


