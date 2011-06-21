
%MappedType MappedThumbnail
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "thumbnaillist.h"
#include "thumbnailtable.h"
#define MappedThumbnail Thumbnail
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Thumbnail(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ThumbnailSchema::instance() );
%End
};

class Thumbnail : Record
{
%TypeHeaderCode
#include <thumbnail.h>
#include "element.h"
#include "user.h"

%End
public:
	Thumbnail();

	Thumbnail( uint key );

	Thumbnail( const Thumbnail & other );

	Thumbnail( const Record & r );

	Thumbnail( RecordImp * imp, bool checkType = true );
	
	MappedThumbnail copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString clipRect() const;
	MappedThumbnail & setClipRect( const QString & );
	QDateTime date() const;
	MappedThumbnail & setDate( const QDateTime & );
	MappedElement element() const;
	MappedThumbnail & setElement( const Element & );
	MappedUser user() const;
	MappedThumbnail & setUser( const User & );
	QString originalFile() const;
	MappedThumbnail & setOriginalFile( const QString & );
	QByteArray image() const;
	MappedThumbnail & setImage( const QByteArray & );


	static MappedThumbnailList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedThumbnail reload( bool lockForUpdate = false );

	static MappedThumbnail recordByElement( const Element &fkeyElement );





	QString filePath() const;



	static Table * table();
	//static ThumbnailSchema * schema();
};


