


%MappedType MappedThumbnailList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "thumbnaillist.h"
#include "thumbnailtable.h"
#define MappedThumbnailList ThumbnailList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ThumbnailSchema::instance() );
%End
};

class ThumbnailList : RecordList
{
%TypeHeaderCode
#include <thumbnaillist.h>
#include "element.h"
#include "user.h"

%End
public:
	ThumbnailList();
	ThumbnailList( const RecordList &, Table * t = 0 );
	ThumbnailList( const ThumbnailList & );
	ThumbnailList( const Record &, Table * t = 0 );
	
	~ThumbnailList();

//	void insert( ThumbnailIter, const Thumbnail & );

//	ThumbnailIter at( uint );

//	ThumbnailIter find( const Record & );

//	ThumbnailIter remove( const ThumbnailIter & );

	int remove( const Record & );
	
	int remove();
	
	//ThumbnailIter begin();

	//ThumbnailIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedThumbnailList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedThumbnailList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedThumbnailList sorted( const QString & c, bool a = true ) const;

	MappedThumbnailList unique() const;
	MappedThumbnailList reversed() const;
	MappedThumbnailList reloaded() const;

	QStringList clipRects() const;
	MappedThumbnailList & setClipRects( const QString & );
	QList<QDateTime> dates() const;
	MappedThumbnailList & setDates( const QDateTime & );
	MappedElementList elements() const;
	MappedThumbnailList & setElements( const Element & );
	MappedUserList users() const;
	MappedThumbnailList & setUsers( const User & );
	QStringList originalFiles() const;
	MappedThumbnailList & setOriginalFiles( const QString & );
	QList<QByteArray> images() const;
	MappedThumbnailList & setImages( const QByteArray & );


};


