


%MappedType MappedShotList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "shotlist.h"
#include "shottable.h"
#define MappedShotList ShotList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ShotSchema::instance() );
%End
};

class ShotList : ElementList
{
%TypeHeaderCode
#include <shotlist.h>

%End
public:
	ShotList();
	ShotList( const RecordList &, Table * t = 0 );
	ShotList( const ShotList & );
	ShotList( const Record &, Table * t = 0 );
	
	~ShotList();

//	void insert( ShotIter, const Shot & );

//	ShotIter at( uint );

//	ShotIter find( const Record & );

//	ShotIter remove( const ShotIter & );

	int remove( const Record & );
	
	int remove();
	
	//ShotIter begin();

	//ShotIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedShotList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedShotList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedShotList sorted( const QString & c, bool a = true ) const;

	MappedShotList unique() const;
	MappedShotList reversed() const;
	MappedShotList reloaded() const;

	QStringList dialogs() const;
	MappedShotList & setDialogs( const QString & );
	QList<uint> frameEnds() const;
	MappedShotList & setFrameEnds( const uint & );
	QList<uint> frameStarts() const;
	MappedShotList & setFrameStarts( const uint & );
	QList<double> shotNumbers() const;
	MappedShotList & setShotNumbers( const double & );
	QList<uint> frameStartEDLs() const;
	MappedShotList & setFrameStartEDLs( const uint & );
	QList<uint> frameEndEDLs() const;
	MappedShotList & setFrameEndEDLs( const uint & );
	QStringList cameraInfos() const;
	MappedShotList & setCameraInfos( const QString & );
	QList<uint> scriptPages() const;
	MappedShotList & setScriptPages( const uint & );


};


