


%MappedType MappedDiskImageList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "diskimagelist.h"
#include "diskimagetable.h"
#define MappedDiskImageList DiskImageList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, DiskImageSchema::instance() );
%End
};

class DiskImageList : RecordList
{
%TypeHeaderCode
#include <diskimagelist.h>

%End
public:
	DiskImageList();
	DiskImageList( const RecordList &, Table * t = 0 );
	DiskImageList( const DiskImageList & );
	DiskImageList( const Record &, Table * t = 0 );
	
	~DiskImageList();

//	void insert( DiskImageIter, const DiskImage & );

//	DiskImageIter at( uint );

//	DiskImageIter find( const Record & );

//	DiskImageIter remove( const DiskImageIter & );

	int remove( const Record & );
	
	int remove();
	
	//DiskImageIter begin();

	//DiskImageIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedDiskImageList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedDiskImageList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedDiskImageList sorted( const QString & c, bool a = true ) const;

	MappedDiskImageList unique() const;
	MappedDiskImageList reversed() const;
	MappedDiskImageList reloaded() const;

	QStringList diskImages() const;
	MappedDiskImageList & setDiskImages( const QString & );
	QStringList paths() const;
	MappedDiskImageList & setPaths( const QString & );
	QList<QDateTime> created() const;
	MappedDiskImageList & setCreated( const QDateTime & );


};


