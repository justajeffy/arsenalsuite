


%MappedType MappedLicenseList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "licenselist.h"
#include "licensetable.h"
#define MappedLicenseList LicenseList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, LicenseSchema::instance() );
%End
};

class LicenseList : RecordList
{
%TypeHeaderCode
#include <licenselist.h>
#include "host.h"
#include "software.h"

%End
public:
	LicenseList();
	LicenseList( const RecordList &, Table * t = 0 );
	LicenseList( const LicenseList & );
	LicenseList( const Record &, Table * t = 0 );
	
	~LicenseList();

//	void insert( LicenseIter, const License & );

//	LicenseIter at( uint );

//	LicenseIter find( const Record & );

//	LicenseIter remove( const LicenseIter & );

	int remove( const Record & );
	
	int remove();
	
	//LicenseIter begin();

	//LicenseIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedLicenseList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedLicenseList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedLicenseList sorted( const QString & c, bool a = true ) const;

	MappedLicenseList unique() const;
	MappedLicenseList reversed() const;
	MappedLicenseList reloaded() const;

	QStringList licenses() const;
	MappedLicenseList & setLicenses( const QString & );
	MappedHostList hosts() const;
	MappedLicenseList & setHosts( const Host & );
	MappedSoftwareList softwares() const;
	MappedLicenseList & setSoftwares( const Software & );
	QList<int> totals() const;
	MappedLicenseList & setTotals( const int & );
	QList<int> reserved() const;
	MappedLicenseList & setReserved( const int & );
	QList<int> inUses() const;
	MappedLicenseList & setInUses( const int & );


};


