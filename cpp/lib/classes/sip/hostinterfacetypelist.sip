


%MappedType MappedHostInterfaceTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostinterfacetypelist.h"
#include "hostinterfacetypetable.h"
#define MappedHostInterfaceTypeList HostInterfaceTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostInterfaceTypeSchema::instance() );
%End
};

class HostInterfaceTypeList : RecordList
{
%TypeHeaderCode
#include <hostinterfacetypelist.h>

%End
public:
	HostInterfaceTypeList();
	HostInterfaceTypeList( const RecordList &, Table * t = 0 );
	HostInterfaceTypeList( const HostInterfaceTypeList & );
	HostInterfaceTypeList( const Record &, Table * t = 0 );
	
	~HostInterfaceTypeList();

//	void insert( HostInterfaceTypeIter, const HostInterfaceType & );

//	HostInterfaceTypeIter at( uint );

//	HostInterfaceTypeIter find( const Record & );

//	HostInterfaceTypeIter remove( const HostInterfaceTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostInterfaceTypeIter begin();

	//HostInterfaceTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostInterfaceTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostInterfaceTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostInterfaceTypeList sorted( const QString & c, bool a = true ) const;

	MappedHostInterfaceTypeList unique() const;
	MappedHostInterfaceTypeList reversed() const;
	MappedHostInterfaceTypeList reloaded() const;

	QStringList names() const;
	MappedHostInterfaceTypeList & setNames( const QString & );


};


