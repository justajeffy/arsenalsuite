


%MappedType MappedUserList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userlist.h"
#include "usertable.h"
#define MappedUserList UserList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, UserSchema::instance() );
%End
};

class UserList : ElementList
{
%TypeHeaderCode
#include <userlist.h>
#include "host.h"
#include "client.h"
#include "jobhistory.h"
#include "userelement.h"
#include "usermapping.h"
#include "userrole.h"
#include "usergroup.h"

%End
public:
	UserList();
	UserList( const RecordList &, Table * t = 0 );
	UserList( const UserList & );
	UserList( const Record &, Table * t = 0 );
	
	~UserList();

//	void insert( UserIter, const User & );

//	UserIter at( uint );

//	UserIter find( const Record & );

//	UserIter remove( const UserIter & );

	int remove( const Record & );
	
	int remove();
	
	//UserIter begin();

	//UserIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedUserList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedUserList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedUserList sorted( const QString & c, bool a = true ) const;

	MappedUserList unique() const;
	MappedUserList reversed() const;
	MappedUserList reloaded() const;

	QList<QDate> dateoflastlogons() const;
	MappedUserList & setDateoflastlogons( const QDate & );
	QStringList emails() const;
	MappedUserList & setEmails( const QString & );
	MappedHostList hosts() const;
	MappedUserList & setHosts( const Host & );
	QStringList gpgkeies() const;
	MappedUserList & setGpgkeies( const QString & );
	QStringList jids() const;
	MappedUserList & setJids( const QString & );
	QStringList pagers() const;
	MappedUserList & setPagers( const QString & );
	QStringList passwords() const;
	MappedUserList & setPasswords( const QString & );
	QStringList remoteipses() const;
	MappedUserList & setRemoteipses( const QString & );
	QStringList schedules() const;
	MappedUserList & setSchedules( const QString & );
	QStringList shells() const;
	MappedUserList & setShells( const QString & );
	QStringList sids() const;
	MappedUserList & setSids( const QString & );
	QList<uint> uids() const;
	MappedUserList & setUids( const uint & );
	QList<uint> threadNotifyByJabbers() const;
	MappedUserList & setThreadNotifyByJabbers( const uint & );
	QList<uint> threadNotifyByEmails() const;
	MappedUserList & setThreadNotifyByEmails( const uint & );
	MappedClientList clients() const;
	MappedUserList & setClients( const Client & );
	QList<uint> intranets() const;
	MappedUserList & setIntranets( const uint & );
	QStringList homeDirs() const;
	MappedUserList & setHomeDirs( const QString & );
	QList<uint> disabled() const;
	MappedUserList & setDisabled( const uint & );
	QList<uint> gids() const;
	MappedUserList & setGids( const uint & );
	QStringList usrs() const;
	MappedUserList & setUsrs( const QString & );
	QList<uint> keyUsrs() const;
	MappedUserList & setKeyUsrs( const uint & );
	QStringList lastLogonTypes() const;
	MappedUserList & setLastLogonTypes( const QString & );
	QList<uint> logonCounts() const;
	MappedUserList & setLogonCounts( const uint & );
	MappedJobHistoryList jobHistories();
	MappedUserElementList userElements();
	MappedUserMappingList userMappings();
	MappedUserRoleList userRoles();
	MappedUserGroupList userGroups();


};


