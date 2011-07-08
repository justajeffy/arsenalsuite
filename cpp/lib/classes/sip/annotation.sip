
%MappedType MappedAnnotation
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "annotationlist.h"
#include "annotationtable.h"
#define MappedAnnotation Annotation
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Annotation(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AnnotationSchema::instance() );
%End
};

class Annotation : Record
{
%TypeHeaderCode
#include <annotation.h>

%End
public:
	Annotation();

	Annotation( uint key );

	Annotation( const Annotation & other );

	Annotation( const Record & r );

	Annotation( RecordImp * imp, bool checkType = true );
	
	MappedAnnotation copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString notes() const;
	MappedAnnotation & setNotes( const QString & );
	QString markupData() const;
	MappedAnnotation & setMarkupData( const QString & );
	int frameStart() const;
	MappedAnnotation & setFrameStart( const int & );
	int frameEnd() const;
	MappedAnnotation & setFrameEnd( const int & );
	QString sequence() const;
	MappedAnnotation & setSequence( const QString & );


	static MappedAnnotationList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAnnotation reload( bool lockForUpdate = false );

	static MappedAnnotationList recordsBySequence( const QString &sequence );






	static Table * table();
	//static AnnotationSchema * schema();
};


