
%MappedType MappedThreadNotify
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "threadnotifylist.h"
#include "threadnotifytable.h"
#define MappedThreadNotify ThreadNotify
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ThreadNotify(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ThreadNotifySchema::instance() );
%End
};

class ThreadNotify : Record
{
%TypeHeaderCode
#include <threadnotify.h>
#include "thread.h"
#include "user.h"

%End
public:
	ThreadNotify();

	ThreadNotify( uint key );

	ThreadNotify( const ThreadNotify & other );

	ThreadNotify( const Record & r );

	ThreadNotify( RecordImp * imp, bool checkType = true );
	
	MappedThreadNotify copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedThread thread() const;
	MappedThreadNotify & setThread( const Thread & );
	MappedUser user() const;
	MappedThreadNotify & setUser( const User & );
	uint options() const;
	MappedThreadNotify & setOptions( const uint & );


	static MappedThreadNotifyList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedThreadNotify reload( bool lockForUpdate = false );

	static MappedThreadNotifyList recordsByThread( const Thread &fkeyThread );
	static MappedThreadNotifyList recordsByUser( const User &fkeyUser );





	enum {
		RequiresSignoff = 1,
		SignedOff = 2,
		HasBeenRead = 4
	};

	bool requiresSignoff() const;
	void setRequiresSignoff( bool rs );

	bool signedOff() const;
	void setSignedOff( bool );
	
	bool read() const;
	void setRead( bool );
	



	static Table * table();
	//static ThreadNotifySchema * schema();
};


