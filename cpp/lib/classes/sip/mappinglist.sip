


%MappedType MappedMappingList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "mappinglist.h"
#include "mappingtable.h"
#define MappedMappingList MappingList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, MappingSchema::instance() );
%End
};

class MappingList : RecordList
{
%TypeHeaderCode
#include <mappinglist.h>
#include "host.h"
#include "mappingtype.h"
#include "hostmapping.h"

%End
public:
	MappingList();
	MappingList( const RecordList &, Table * t = 0 );
	MappingList( const MappingList & );
	MappingList( const Record &, Table * t = 0 );
	
	~MappingList();

//	void insert( MappingIter, const Mapping & );

//	MappingIter at( uint );

//	MappingIter find( const Record & );

//	MappingIter remove( const MappingIter & );

	int remove( const Record & );
	
	int remove();
	
	//MappingIter begin();

	//MappingIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedMappingList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedMappingList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedMappingList sorted( const QString & c, bool a = true ) const;

	MappedMappingList unique() const;
	MappedMappingList reversed() const;
	MappedMappingList reloaded() const;

	MappedHostList hosts() const;
	MappedMappingList & setHosts( const Host & );
	QStringList shares() const;
	MappedMappingList & setShares( const QString & );
	MappedMappingTypeList mappingTypes() const;
	MappedMappingList & setMappingTypes( const MappingType & );
	QStringList mounts() const;
	MappedMappingList & setMounts( const QString & );
	MappedHostMappingList hostMappings();


};


