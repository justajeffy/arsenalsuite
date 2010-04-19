


%MappedType MappedServerFileActionTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactiontypelist.h"
#include "serverfileactiontypetable.h"
#define MappedServerFileActionTypeList ServerFileActionTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ServerFileActionTypeSchema::instance() );
%End
};

class ServerFileActionTypeList : RecordList
{
%TypeHeaderCode
#include <serverfileactiontypelist.h>

%End
public:
	ServerFileActionTypeList();
	ServerFileActionTypeList( const RecordList &, Table * t = 0 );
	ServerFileActionTypeList( const ServerFileActionTypeList & );
	ServerFileActionTypeList( const Record &, Table * t = 0 );
	
	~ServerFileActionTypeList();

//	void insert( ServerFileActionTypeIter, const ServerFileActionType & );

//	ServerFileActionTypeIter at( uint );

//	ServerFileActionTypeIter find( const Record & );

//	ServerFileActionTypeIter remove( const ServerFileActionTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//ServerFileActionTypeIter begin();

	//ServerFileActionTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedServerFileActionTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedServerFileActionTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedServerFileActionTypeList sorted( const QString & c, bool a = true ) const;

	MappedServerFileActionTypeList unique() const;
	MappedServerFileActionTypeList reversed() const;
	MappedServerFileActionTypeList reloaded() const;

	QStringList names() const;
	MappedServerFileActionTypeList & setNames( const QString & );


};


