


%MappedType MappedSoftwareList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "softwarelist.h"
#include "softwaretable.h"
#define MappedSoftwareList SoftwareList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, SoftwareSchema::instance() );
%End
};

class SoftwareList : RecordList
{
%TypeHeaderCode
#include <softwarelist.h>
#include "hostsoftware.h"

%End
public:
	SoftwareList();
	SoftwareList( const RecordList &, Table * t = 0 );
	SoftwareList( const SoftwareList & );
	SoftwareList( const Record &, Table * t = 0 );
	
	~SoftwareList();

//	void insert( SoftwareIter, const Software & );

//	SoftwareIter at( uint );

//	SoftwareIter find( const Record & );

//	SoftwareIter remove( const SoftwareIter & );

	int remove( const Record & );
	
	int remove();
	
	//SoftwareIter begin();

	//SoftwareIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedSoftwareList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedSoftwareList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedSoftwareList sorted( const QString & c, bool a = true ) const;

	MappedSoftwareList unique() const;
	MappedSoftwareList reversed() const;
	MappedSoftwareList reloaded() const;

	QStringList names() const;
	MappedSoftwareList & setNames( const QString & );
	QStringList versions() const;
	MappedSoftwareList & setVersions( const QString & );
	QStringList installedPaths() const;
	MappedSoftwareList & setInstalledPaths( const QString & );
	QStringList executables() const;
	MappedSoftwareList & setExecutables( const QString & );
	QList<bool> sixtyfourbits() const;
	MappedSoftwareList & setSixtyfourbits( const bool & );
	QList<bool> actives() const;
	MappedSoftwareList & setActives( const bool & );
	MappedHostSoftwareList hostSoftwares();


};


