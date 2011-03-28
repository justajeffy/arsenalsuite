
%MappedType MappedPathTemplate
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathtemplatelist.h"
#include "pathtemplatetable.h"
#define MappedPathTemplate PathTemplate
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new PathTemplate(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, PathTemplateSchema::instance() );
%End
};

class PathTemplate : Record
{
%TypeHeaderCode
#include <pathtemplate.h>

%End
public:
	PathTemplate();

	PathTemplate( uint key );

	PathTemplate( const PathTemplate & other );

	PathTemplate( const Record & r );

	PathTemplate( RecordImp * imp, bool checkType = true );
	
	MappedPathTemplate copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	int version() const;
	MappedPathTemplate & setVersion( const int & );
	QString fileNameTemplate() const;
	MappedPathTemplate & setFileNameTemplate( const QString & );
	QString pathTemplate() const;
	MappedPathTemplate & setPathTemplate( const QString & );
	QString name() const;
	MappedPathTemplate & setName( const QString & );
	QString pythonCode() const;
	MappedPathTemplate & setPythonCode( const QString & );


	static MappedPathTemplateList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedPathTemplate reload( bool lockForUpdate = false );

	static MappedPathTemplate recordByName( const QString &name );





/*
	Template replacements

	[Name] - the name of the element/asset
	[ParentPath] - the path of the parent asset
*/

MappedRecord createTracker( const Element & parent );

QString getPath( const Element & element, const ProjectStorage & storage = ProjectStorage() );

QString getPath( const FileTracker & ft );

QString getPath( const PathTracker & pt, const ProjectStorage & storage = ProjectStorage() );

QString getFileName( const FileTracker & ft );


	static Table * table();
	//static PathTemplateSchema * schema();
};


