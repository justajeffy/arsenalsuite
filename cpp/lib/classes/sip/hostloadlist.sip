


%MappedType MappedHostLoadList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostloadlist.h"
#include "hostloadtable.h"
#define MappedHostLoadList HostLoadList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostLoadSchema::instance() );
%End
};

class HostLoadList : RecordList
{
%TypeHeaderCode
#include <hostloadlist.h>
#include "host.h"

%End
public:
	HostLoadList();
	HostLoadList( const RecordList &, Table * t = 0 );
	HostLoadList( const HostLoadList & );
	HostLoadList( const Record &, Table * t = 0 );
	
	~HostLoadList();

//	void insert( HostLoadIter, const HostLoad & );

//	HostLoadIter at( uint );

//	HostLoadIter find( const Record & );

//	HostLoadIter remove( const HostLoadIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostLoadIter begin();

	//HostLoadIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostLoadList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostLoadList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostLoadList sorted( const QString & c, bool a = true ) const;

	MappedHostLoadList unique() const;
	MappedHostLoadList reversed() const;
	MappedHostLoadList reloaded() const;

	MappedHostList hosts() const;
	MappedHostLoadList & setHosts( const Host & );
	QList<float> loadAvgs() const;
	MappedHostLoadList & setLoadAvgs( const float & );
	QList<float> loadAvgAdjusts() const;
	MappedHostLoadList & setLoadAvgAdjusts( const float & );


};


