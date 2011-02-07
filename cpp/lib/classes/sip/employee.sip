
%MappedType MappedEmployee
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "employeelist.h"
#include "employeetable.h"
#define MappedEmployee Employee
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Employee(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, EmployeeSchema::instance() );
%End
};

class Employee : User
{
%TypeHeaderCode
#include <employee.h>

%End
public:
	Employee();

	Employee( uint key );

	Employee( const Employee & other );

	Employee( const Record & r );

	Employee( RecordImp * imp, bool checkType = true );
	
	MappedEmployee copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString firstName() const;
	MappedEmployee & setFirstName( const QString & );
	QString lastName() const;
	MappedEmployee & setLastName( const QString & );
	QDate dateOfHire() const;
	MappedEmployee & setDateOfHire( const QDate & );
	QDate dateOfTermination() const;
	MappedEmployee & setDateOfTermination( const QDate & );
	QDate dateOfBirth() const;
	MappedEmployee & setDateOfBirth( const QDate & );
	QString logon() const;
	MappedEmployee & setLogon( const QString & );
	uint lockedOut() const;
	MappedEmployee & setLockedOut( const uint & );
	QDateTime beBackAt() const;
	MappedEmployee & setBeBackAt( const QDateTime & );
	QString comment() const;
	MappedEmployee & setComment( const QString & );
	uint userLevel() const;
	MappedEmployee & setUserLevel( const uint & );
	uint noPostDays() const;
	MappedEmployee & setNoPostDays( const uint & );
	QString initials() const;
	MappedEmployee & setInitials( const QString & );
	uint missingTimeSheetCount() const;
	MappedEmployee & setMissingTimeSheetCount( const uint & );


	static MappedEmployeeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedEmployee reload( bool lockForUpdate = false );



	static ElementType type();



	QString fullName() const;


	static Table * table();
	//static EmployeeSchema * schema();
};


