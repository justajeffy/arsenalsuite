
%MappedType MappedGridTemplate
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gridtemplatelist.h"
#include "gridtemplatetable.h"
#define MappedGridTemplate GridTemplate
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GridTemplate(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GridTemplateSchema::instance() );
%End
};

class GridTemplate : Record
{
%TypeHeaderCode
#include <gridtemplate.h>
#include "project.h"

%End
public:
	GridTemplate();

	GridTemplate( uint key );

	GridTemplate( const GridTemplate & other );

	GridTemplate( const Record & r );

	GridTemplate( RecordImp * imp, bool checkType = true );
	
	MappedGridTemplate copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedProject project() const;
	MappedGridTemplate & setProject( const Project & );
	QString name() const;
	MappedGridTemplate & setName( const QString & );


	static MappedGridTemplateList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGridTemplate reload( bool lockForUpdate = false );

	static MappedGridTemplateList recordsByProject( const Project &fkeyProject );






	static Table * table();
	//static GridTemplateSchema * schema();
};


