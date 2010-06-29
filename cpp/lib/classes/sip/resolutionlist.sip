


%MappedType MappedResolutionList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "resolutionlist.h"
#include "resolutiontable.h"
#define MappedResolutionList ResolutionList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ResolutionSchema::instance() );
%End
};

class ResolutionList : RecordList
{
%TypeHeaderCode
#include <resolutionlist.h>
#include "project.h"

%End
public:
	ResolutionList();
	ResolutionList( const RecordList &, Table * t = 0 );
	ResolutionList( const ResolutionList & );
	ResolutionList( const Record &, Table * t = 0 );
	
	~ResolutionList();

//	void insert( ResolutionIter, const Resolution & );

//	ResolutionIter at( uint );

//	ResolutionIter find( const Record & );

//	ResolutionIter remove( const ResolutionIter & );

	int remove( const Record & );
	
	int remove();
	
	//ResolutionIter begin();

	//ResolutionIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedResolutionList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedResolutionList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedResolutionList sorted( const QString & c, bool a = true ) const;

	MappedResolutionList unique() const;
	MappedResolutionList reversed() const;
	MappedResolutionList reloaded() const;

	QStringList deliveryFormats() const;
	MappedResolutionList & setDeliveryFormats( const QString & );
	MappedProjectList projects() const;
	MappedResolutionList & setProjects( const Project & );
	QList<uint> heights() const;
	MappedResolutionList & setHeights( const uint & );
	QStringList outputFormats() const;
	MappedResolutionList & setOutputFormats( const QString & );
	QStringList names() const;
	MappedResolutionList & setNames( const QString & );
	QList<uint> widths() const;
	MappedResolutionList & setWidths( const uint & );
	QList<float> pixelAspects() const;
	MappedResolutionList & setPixelAspects( const float & );
	QList<uint> fpses() const;
	MappedResolutionList & setFpses( const uint & );


};


