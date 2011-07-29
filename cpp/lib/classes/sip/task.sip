
%MappedType MappedTask
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "tasklist.h"
#include "tasktable.h"
#define MappedTask Task
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Task(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, TaskSchema::instance() );
%End
};

class Task : Element
{
%TypeHeaderCode
#include <task.h>

%End
public:
	Task();

	Task( uint key );

	Task( const Task & other );

	Task( const Record & r );

	Task( RecordImp * imp, bool checkType = true );
	
	MappedTask copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint shotGroup() const;
	MappedTask & setShotGroup( const uint & );


	static MappedTaskList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedTask reload( bool lockForUpdate = false );



	static ElementType type();




	static Table * table();
	//static TaskSchema * schema();
};


