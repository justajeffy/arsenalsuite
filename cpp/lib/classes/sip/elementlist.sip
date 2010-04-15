


%MappedType MappedElementList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementlist.h"
#include "elementtable.h"
#define MappedElementList ElementList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ElementSchema::instance() );
%End
};

class ElementList : RecordList
{
%TypeHeaderCode
#include <elementlist.h>
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
	ElementList();
	ElementList( const RecordList &, Table * t = 0 );
	ElementList( const ElementList & );
	ElementList( const Record &, Table * t = 0 );
	
	~ElementList();

//	void insert( ElementIter, const Element & );

//	ElementIter at( uint );

//	ElementIter find( const Record & );

//	ElementIter remove( const ElementIter & );

	int remove( const Record & );
	
	int remove();
	
	//ElementIter begin();

	//ElementIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedElementList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedElementList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedElementList sorted( const QString & c, bool a = true ) const;

	MappedElementList unique() const;
	MappedElementList reversed() const;
	MappedElementList reloaded() const;

	QList<float> daysBids() const;
	MappedElementList & setDaysBids( const float & );
	QStringList descriptions() const;
	MappedElementList & setDescriptions( const QString & );
	QStringList filePaths() const;
	MappedElementList & setFilePaths( const QString & );
	MappedElementList parents() const;
	MappedElementList & setParents( const Element & );
	MappedElementStatusList elementStatuses() const;
	MappedElementList & setElementStatuses( const ElementStatus & );
	MappedElementTypeList elementTypes() const;
	MappedElementList & setElementTypes( const ElementType & );
	MappedProjectList projects() const;
	MappedElementList & setProjects( const Project & );
	MappedThumbnailList thumbnails() const;
	MappedElementList & setThumbnails( const Thumbnail & );
	QStringList names() const;
	MappedElementList & setNames( const QString & );
	QList<float> daysScheduled() const;
	MappedElementList & setDaysScheduled( const float & );
	QList<float> daysEstimated() const;
	MappedElementList & setDaysEstimated( const float & );
	MappedAssetTypeList assetTypes() const;
	MappedElementList & setAssetTypes( const AssetType & );
	MappedPathTemplateList pathTemplates() const;
	MappedElementList & setPathTemplates( const PathTemplate & );
	MappedStatusSetList statusSets() const;
	MappedElementList & setStatusSets( const StatusSet & );
	QList<bool> allowTimes() const;
	MappedElementList & setAllowTimes( const bool & );
	QList<QDate> startDates() const;
	MappedElementList & setStartDates( const QDate & );
	QList<QDate> datesComplete() const;
	MappedElementList & setDatesComplete( const QDate & );
	MappedAssetTemplateList assetTemplates() const;
	MappedElementList & setAssetTemplates( const AssetTemplate & );
	QList<float> mDaysEstimatedCaches() const;
	MappedElementList & setMDaysEstimatedCaches( const float & );
	QList<float> mDaysScheduledCaches() const;
	MappedElementList & setMDaysScheduledCaches( const float & );
	QList<float> mDaysSpentCaches() const;
	MappedElementList & setMDaysSpentCaches( const float & );
	QList<float> mDaysSpentCache8s() const;
	MappedElementList & setMDaysSpentCache8s( const float & );
	QList<float> mDaysBidCaches() const;
	MappedElementList & setMDaysBidCaches( const float & );
	QList<uint> mCacheValids() const;
	MappedElementList & setMCacheValids( const uint & );
	QStringList mPathCaches() const;
	MappedElementList & setMPathCaches( const QString & );
	QList<int> mPathCacheNumbers() const;
	MappedElementList & setMPathCacheNumbers( const int & );
	MappedAssetPropertyList assetProperties();
	MappedDeliveryElementList deliveryElements();
	MappedElementUserList elementUsers();
	MappedPathTrackerList pathTrackers();
	ElementList children( const ElementType & et = ElementType(), bool recursive = false );
	ElementList children( const ElementTypeList & et, bool recursive = false );


};


