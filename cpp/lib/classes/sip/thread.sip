
%MappedType MappedThread
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "threadlist.h"
#include "threadtable.h"
#define MappedThread Thread
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Thread(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ThreadSchema::instance() );
%End
};

class Thread : Record
{
%TypeHeaderCode
#include <thread.h>
#include "element.h"
#include "job.h"
#include "user.h"
#include "thread.h"
#include "threadnotify.h"

%End
public:
	Thread();

	Thread( uint key );

	Thread( const Thread & other );

	Thread( const Record & r );

	Thread( RecordImp * imp, bool checkType = true );
	
	MappedThread copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QDateTime dateTime() const;
	MappedThread & setDateTime( const QDateTime & );
	QString body() const;
	MappedThread & setBody( const QString & );
	MappedElement element() const;
	MappedThread & setElement( const Element & );
	MappedJob job() const;
	MappedThread & setJob( const Job & );
	MappedUser user() const;
	MappedThread & setUser( const User & );
	MappedThread reply() const;
	MappedThread & setReply( const Thread & );
	QString topic() const;
	MappedThread & setTopic( const QString & );
	uint todoStatus() const;
	MappedThread & setTodoStatus( const uint & );
	uint hasAttachments() const;
	MappedThread & setHasAttachments( const uint & );
	MappedThreadNotifyList threadNotifies() const;


	static MappedThreadList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedThread reload( bool lockForUpdate = false );

	static MappedThreadList recordsByElement( const Element &fkeyElement );
	static MappedThreadList recordsByJob( const Job &fkeyJob );
	static MappedThreadList recordsByUser( const User &fkeyUsr );






	QString attachmentsPath() const;
	
	QStringList attachmentFiles() const;
	
	




	static Table * table();
	//static ThreadSchema * schema();
};


