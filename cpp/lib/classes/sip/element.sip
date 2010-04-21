
%MappedType MappedElement
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementlist.h"
#include "elementtable.h"
#define MappedElement Element
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Element(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ElementSchema::instance() );
%End
};

class Element : Record
{
%TypeHeaderCode
#include <element.h>
#include "element.h"
#include "elementstatus.h"
#include "elementtype.h"
#include "project.h"
#include "thumbnail.h"
#include "assettype.h"
#include "pathtemplate.h"
#include "statusset.h"
#include "assettemplate.h"
#include "assetproperty.h"
#include "deliveryelement.h"
#include "elementuser.h"
#include "pathtracker.h"

%End
public:
	Element();

	Element( uint key );

	Element( const Element & other );

	Element( const Record & r );

	Element( RecordImp * imp, bool checkType = true );
	
	MappedElement copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	float daysBid() const;
	MappedElement & setDaysBid( const float & );
	QString description() const;
	MappedElement & setDescription( const QString & );
	QString filePath() const;
	MappedElement & setFilePath( const QString & );
	MappedElement parent() const;
	MappedElement & setParent( const Element & );
	MappedElementStatus elementStatus() const;
	MappedElement & setElementStatus( const ElementStatus & );
	MappedElementType elementType() const;
	MappedElement & setElementType( const ElementType & );
	MappedProject project() const;
	MappedElement & setProject( const Project & );
	MappedThumbnail thumbnail() const;
	MappedElement & setThumbnail( const Thumbnail & );
	QString name() const;
	MappedElement & setName( const QString & );
	float daysScheduled() const;
	MappedElement & setDaysScheduled( const float & );
	float daysEstimated() const;
	MappedElement & setDaysEstimated( const float & );
	MappedAssetType assetType() const;
	MappedElement & setAssetType( const AssetType & );
	MappedPathTemplate pathTemplate() const;
	MappedElement & setPathTemplate( const PathTemplate & );
	MappedStatusSet statusSet() const;
	MappedElement & setStatusSet( const StatusSet & );
	bool allowTime() const;
	MappedElement & setAllowTime( const bool & );
	QDate startDate() const;
	MappedElement & setStartDate( const QDate & );
	QDate dateComplete() const;
	MappedElement & setDateComplete( const QDate & );
	MappedAssetTemplate assetTemplate() const;
	MappedElement & setAssetTemplate( const AssetTemplate & );
	float mDaysEstimatedCache() const;
	MappedElement & setMDaysEstimatedCache( const float & );
	float mDaysScheduledCache() const;
	MappedElement & setMDaysScheduledCache( const float & );
	float mDaysSpentCache() const;
	MappedElement & setMDaysSpentCache( const float & );
	float mDaysSpentCache8() const;
	MappedElement & setMDaysSpentCache8( const float & );
	float mDaysBidCache() const;
	MappedElement & setMDaysBidCache( const float & );
	uint mCacheValid() const;
	MappedElement & setMCacheValid( const uint & );
	QString mPathCache() const;
	MappedElement & setMPathCache( const QString & );
	int mPathCacheNumber() const;
	MappedElement & setMPathCacheNumber( const int & );
	MappedAssetPropertyList assetProperties() const;
	MappedDeliveryElementList deliveryElements() const;
	MappedElementUserList elementUsers() const;
	MappedPathTrackerList pathTrackers() const;


	static MappedElementList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedElement reload( bool lockForUpdate = false );

	static MappedElementList recordsByParent( const Element &fkeyElement );
	static MappedElementList recordsByProject( const Project &fkeyProject );
	static MappedElementList recordsByAssetTemplate( const AssetTemplate &fkeyAssetTemplate );


	static ElementType type();



	bool isTask() const;

	// Assigned user stuff
	MappedRecordList users( bool recursive = false ) const;

	QStringList userStringList() const;

	MappedRecord addUser( const User & );

	void removeUser( const User & );

	void setUsers( EmployeeList );

	bool hasUser ( const User & );

//	static Element recordByElementAndName( const Element &, const QString & );

//	float daysSpent() const;

	// Template Stuff
	static MappedRecord createFromTemplate( const AssetTemplate &, RecordList & created );
	void copyTemplateRecurse( const Element &, RecordList & created );
	void createFileDependancies( const Element & dependant, bool recursive );

	// File Tracker Stuff
	MappedRecordList trackers( bool recursive = true ) const;
	MappedRecordList findTrackers( const QRegExp &, bool recursive = true ) const;
	MappedRecord tracker( const QString & key ) const;
	
	QString displayName( bool needContext = false ) const;
	QString displayPath() const;
	QString prettyPath() const;

	QString status() const;

	/***************************************************************
		Path functions
	****************************************************************/
	QString uri() const;
	
	MappedRecord childFromUri( const QString & dotPath );
	
	static MappedRecord fromUri( const QString & dotPath );

	/// Returns the ProjectStorage record for this project with storageName
	MappedRecord storageByName( const QString & storageName ) const;
	MappedRecord defaultStorage() const;
	MappedRecord storageByDriveLetter( const QString & driveLetter ) const;

	MappedRecord pathTracker( const ProjectStorage & ps = ProjectStorage() );

	QString path( const ProjectStorage & ps = ProjectStorage() );
	QString path( const QString & storageName );
	
	bool setPath( const QString & path, const ProjectStorage & storage = ProjectStorage() );
	bool setPath( const QString & path, const QString & storageName );

	static MappedRecord fromPath( const QString & path, bool matchClosest = false );

	QString setCachedPath( const QString & ) const;
	static void invalidatePathCache();

	QString elementPath() const;
	static MappedRecord fromElementPath( const QString & );
	
//	static bool import( const QString & fileName );

//	bool importRecurse( const QString & fileName, int level, RecordList * created = 0 ) const;

//	static MappedRecord fromDir( const QString & dir );

	bool createPath( bool createParents );
	
	void createAllPaths( bool );
	
	static QString driveToUnix( const QString & drive );

	/*********************************************************
		Drag and drop
	**********************************************************/
	void dropped( QWidget * window, const Record &, Qt::DropAction );
	//void copy( const Element & copyParent );
	void move( const Element & newParent );

	/**********************************************************
		Relations
	***********************************************************/
	MappedRecordList dependencies() const;
	MappedRecordList dependants() const;

	void setDependencies( ElementList elist );
	void setDependants( ElementList elist );
	
	MappedRecordList children( const AssetType assetType, bool recursive=false ) const;
	MappedRecordList children( bool recursive = false ) const;

	MappedRecord ancestorByAssetType( const AssetType & at );

	MappedRecordList coordinators() const;
	MappedRecordList producers() const;
	MappedRecordList supervisors() const;
	
	QStringList propertyNames() const;

	QVariant getProperty( const QString & propertyName, const QVariant & defaultValue = QVariant(), bool storeDefault = false ) const;
	
	QVariant setProperty( const QString & propertyName, const QVariant & value );


	static Table * table();
	//static ElementSchema * schema();
};


