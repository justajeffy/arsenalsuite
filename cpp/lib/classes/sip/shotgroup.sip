
%MappedType MappedShotGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "shotgrouplist.h"
#include "shotgrouptable.h"
#define MappedShotGroup ShotGroup
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ShotGroup(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ShotGroupSchema::instance() );
%End
};

class ShotGroup : Element
{
%TypeHeaderCode
#include <shotgroup.h>

%End
public:
	ShotGroup();

	ShotGroup( uint key );

	ShotGroup( const ShotGroup & other );

	ShotGroup( const Record & r );

	ShotGroup( RecordImp * imp, bool checkType = true );
	
	MappedShotGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedShotGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedShotGroup reload( bool lockForUpdate = false );



	static ElementType type();



	int frameStart() const;
	int frameEnd() const;
	int frameStartEDL() const;
	int frameEndEDL() const;

	MappedRecordList shots() const;



	static Table * table();
	//static ShotGroupSchema * schema();
};


