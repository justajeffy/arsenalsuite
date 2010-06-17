
%MappedType MappedAssetType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assettypelist.h"
#include "assettypetable.h"
#define MappedAssetType AssetType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new AssetType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AssetTypeSchema::instance() );
%End
};

class AssetType : Record
{
%TypeHeaderCode
#include <assettype.h>
#include "elementtype.h"
#include "pathtemplate.h"
#include "assettemplate.h"

%End
public:
	AssetType();

	AssetType( uint key );

	AssetType( const AssetType & other );

	AssetType( const Record & r );

	AssetType( RecordImp * imp, bool checkType = true );
	
	MappedAssetType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedAssetType & setName( const QString & );
	uint hasDaily() const;
	MappedAssetType & setHasDaily( const uint & );
	int disabled() const;
	MappedAssetType & setDisabled( const int & );
	MappedElementType elementType() const;
	MappedAssetType & setElementType( const ElementType & );
	bool isTask() const;
	MappedAssetType & setIsTask( const bool & );
	MappedPathTemplate pathTemplate() const;
	MappedAssetType & setPathTemplate( const PathTemplate & );
	QString nameRegExp() const;
	MappedAssetType & setNameRegExp( const QString & );
	bool allowTime() const;
	MappedAssetType & setAllowTime( const bool & );
	QString color() const;
	MappedAssetType & setColor( const QString & );
	QString description() const;
	MappedAssetType & setDescription( const QString & );
	QString sortColumn() const;
	MappedAssetType & setSortColumn( const QString & );
	QString tags() const;
	MappedAssetType & setTags( const QString & );
	int sortNumber() const;
	MappedAssetType & setSortNumber( const int & );
	MappedAssetTemplateList assetTemplates() const;


	static MappedAssetTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAssetType reload( bool lockForUpdate = false );

	static MappedAssetType recordByName( const QString &timeSheetCategory );





	MappedRecord findDefaultTemplate( const Project & project = Project() );

	MappedRecord construct();

	MappedRecord getGroupElement( const Element & );

	/* Returns the AssetType for a character */
	static MappedRecord character();

	/* Returns the AssetType for a prop */
	static MappedRecord prop();

	/* Returns the AssetType for an environment */
	static MappedRecord environment();

	static MappedRecord camera();

	static MappedRecord light();




	static Table * table();
	//static AssetTypeSchema * schema();
};


