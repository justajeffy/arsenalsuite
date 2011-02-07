


%MappedType MappedTaskList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "tasklist.h"
#include "tasktable.h"
#define MappedTaskList TaskList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, TaskSchema::instance() );
%End
};

class TaskList : ElementList
{
%TypeHeaderCode
#include <tasklist.h>

%End
public:
	TaskList();
	TaskList( const RecordList &, Table * t = 0 );
	TaskList( const TaskList & );
	TaskList( const Record &, Table * t = 0 );
	
	~TaskList();

//	void insert( TaskIter, const Task & );

//	TaskIter at( uint );

//	TaskIter find( const Record & );

//	TaskIter remove( const TaskIter & );

	int remove( const Record & );
	
	int remove();
	
	//TaskIter begin();

	//TaskIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedTaskList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedTaskList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedTaskList sorted( const QString & c, bool a = true ) const;

	MappedTaskList unique() const;
	MappedTaskList reversed() const;
	MappedTaskList reloaded() const;

	QList<uint> shotGroups() const;
	MappedTaskList & setShotGroups( const uint & );


};


