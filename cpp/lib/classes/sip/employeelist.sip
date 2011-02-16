


%MappedType MappedEmployeeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "employeelist.h"
#include "employeetable.h"
#define MappedEmployeeList EmployeeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, EmployeeSchema::instance() );
%End
};

class EmployeeList : UserList
{
%TypeHeaderCode
#include <employeelist.h>

%End
public:
	EmployeeList();
	EmployeeList( const RecordList &, Table * t = 0 );
	EmployeeList( const EmployeeList & );
	EmployeeList( const Record &, Table * t = 0 );
	
	~EmployeeList();

//	void insert( EmployeeIter, const Employee & );

//	EmployeeIter at( uint );

//	EmployeeIter find( const Record & );

//	EmployeeIter remove( const EmployeeIter & );

	int remove( const Record & );
	
	int remove();
	
	//EmployeeIter begin();

	//EmployeeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedEmployeeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedEmployeeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedEmployeeList sorted( const QString & c, bool a = true ) const;

	MappedEmployeeList unique() const;
	MappedEmployeeList reversed() const;
	MappedEmployeeList reloaded() const;

	QStringList firstNames() const;
	MappedEmployeeList & setFirstNames( const QString & );
	QStringList lastNames() const;
	MappedEmployeeList & setLastNames( const QString & );
	QList<QDate> dateOfHires() const;
	MappedEmployeeList & setDateOfHires( const QDate & );
	QList<QDate> dateOfTerminations() const;
	MappedEmployeeList & setDateOfTerminations( const QDate & );
	QList<QDate> dateOfBirths() const;
	MappedEmployeeList & setDateOfBirths( const QDate & );
	QStringList logons() const;
	MappedEmployeeList & setLogons( const QString & );
	QList<uint> lockedOuts() const;
	MappedEmployeeList & setLockedOuts( const uint & );
	QList<QDateTime> beBackAts() const;
	MappedEmployeeList & setBeBackAts( const QDateTime & );
	QStringList comments() const;
	MappedEmployeeList & setComments( const QString & );
	QList<uint> userLevels() const;
	MappedEmployeeList & setUserLevels( const uint & );
	QList<uint> noPostDayses() const;
	MappedEmployeeList & setNoPostDayses( const uint & );
	QStringList initialses() const;
	MappedEmployeeList & setInitialses( const QString & );
	QList<uint> missingTimeSheetCounts() const;
	MappedEmployeeList & setMissingTimeSheetCounts( const uint & );


};


