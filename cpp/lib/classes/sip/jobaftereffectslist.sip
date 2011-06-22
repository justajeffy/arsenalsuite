


%MappedType MappedJobAfterEffectsList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffectslist.h"
#include "jobaftereffectstable.h"
#define MappedJobAfterEffectsList JobAfterEffectsList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAfterEffectsSchema::instance() );
%End
};

class JobAfterEffectsList : JobList
{
%TypeHeaderCode
#include <jobaftereffectslist.h>

%End
public:
	JobAfterEffectsList();
	JobAfterEffectsList( const RecordList &, Table * t = 0 );
	JobAfterEffectsList( const JobAfterEffectsList & );
	JobAfterEffectsList( const Record &, Table * t = 0 );
	
	~JobAfterEffectsList();

//	void insert( JobAfterEffectsIter, const JobAfterEffects & );

//	JobAfterEffectsIter at( uint );

//	JobAfterEffectsIter find( const Record & );

//	JobAfterEffectsIter remove( const JobAfterEffectsIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAfterEffectsIter begin();

	//JobAfterEffectsIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAfterEffectsList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAfterEffectsList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAfterEffectsList sorted( const QString & c, bool a = true ) const;

	MappedJobAfterEffectsList unique() const;
	MappedJobAfterEffectsList reversed() const;
	MappedJobAfterEffectsList reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobAfterEffectsList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobAfterEffectsList & setFrameEnds( const uint & );
	QList<uint> widths() const;
	MappedJobAfterEffectsList & setWidths( const uint & );
	QList<uint> heights() const;
	MappedJobAfterEffectsList & setHeights( const uint & );
	QStringList comps() const;
	MappedJobAfterEffectsList & setComps( const QString & );


};


