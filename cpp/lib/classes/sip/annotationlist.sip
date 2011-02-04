


%MappedType MappedAnnotationList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "annotationlist.h"
#include "annotationtable.h"
#define MappedAnnotationList AnnotationList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AnnotationSchema::instance() );
%End
};

class AnnotationList : RecordList
{
%TypeHeaderCode
#include <annotationlist.h>

%End
public:
	AnnotationList();
	AnnotationList( const RecordList &, Table * t = 0 );
	AnnotationList( const AnnotationList & );
	AnnotationList( const Record &, Table * t = 0 );
	
	~AnnotationList();

//	void insert( AnnotationIter, const Annotation & );

//	AnnotationIter at( uint );

//	AnnotationIter find( const Record & );

//	AnnotationIter remove( const AnnotationIter & );

	int remove( const Record & );
	
	int remove();
	
	//AnnotationIter begin();

	//AnnotationIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAnnotationList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAnnotationList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAnnotationList sorted( const QString & c, bool a = true ) const;

	MappedAnnotationList unique() const;
	MappedAnnotationList reversed() const;
	MappedAnnotationList reloaded() const;

	QStringList noteses() const;
	MappedAnnotationList & setNoteses( const QString & );
	QStringList markupDatas() const;
	MappedAnnotationList & setMarkupDatas( const QString & );
	QList<int> frameStarts() const;
	MappedAnnotationList & setFrameStarts( const int & );
	QList<int> frameEnds() const;
	MappedAnnotationList & setFrameEnds( const int & );
	QStringList sequences() const;
	MappedAnnotationList & setSequences( const QString & );


};


