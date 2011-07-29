
%MappedType MappedAssetTemplate
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assettemplatelist.h"
#include "assettemplatetable.h"
#define MappedAssetTemplate AssetTemplate
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new AssetTemplate(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AssetTemplateSchema::instance() );
%End
};

class AssetTemplate : Record
{
%TypeHeaderCode
#include <assettemplate.h>
#include "element.h"
#include "assettype.h"
#include "project.h"

%End
public:
	AssetTemplate();

	AssetTemplate( uint key );

	AssetTemplate( const AssetTemplate & other );

	AssetTemplate( const Record & r );

	AssetTemplate( RecordImp * imp, bool checkType = true );
	
	MappedAssetTemplate copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedAssetTemplate & setElement( const Element & );
	MappedAssetType assetType() const;
	MappedAssetTemplate & setAssetType( const AssetType & );
	MappedProject project() const;
	MappedAssetTemplate & setProject( const Project & );
	QString name() const;
	MappedAssetTemplate & setName( const QString & );


	static MappedAssetTemplateList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAssetTemplate reload( bool lockForUpdate = false );

	static MappedAssetTemplateList recordsByAssetType( const AssetType &fkeyAssetType );
	static MappedAssetTemplateList recordsByProject( const Project &fkeyProject );
	static MappedAssetTemplateList recordsByProjectAndAssetType( const Project &fkeyProject, const AssetType &fkeyAssetType );




	/// Creates a new asset using this template
	/// returns the asset.
	MappedRecord create( const QString & name, const Element & parent, const Project & project );


	static Table * table();
	//static AssetTemplateSchema * schema();
};


