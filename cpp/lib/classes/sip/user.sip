
%MappedType MappedUser
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userlist.h"
#include "usertable.h"
#define MappedUser User
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new User(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, UserSchema::instance() );
%End
};

class User : Element
{
%TypeHeaderCode
#include <user.h>
#include "host.h"
#include "client.h"
#include "jobhistory.h"
#include "userelement.h"
#include "usermapping.h"
#include "userrole.h"
#include "usergroup.h"

%End
public:
	User();

	User( uint key );

	User( const User & other );

	User( const Record & r );

	User( RecordImp * imp, bool checkType = true );
	
	MappedUser copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QDate dateoflastlogon() const;
	MappedUser & setDateoflastlogon( const QDate & );
	QString email() const;
	MappedUser & setEmail( const QString & );
	MappedHost host() const;
	MappedUser & setHost( const Host & );
	QString gpgkey() const;
	MappedUser & setGpgkey( const QString & );
	QString jid() const;
	MappedUser & setJid( const QString & );
	QString pager() const;
	MappedUser & setPager( const QString & );
	QString password() const;
	MappedUser & setPassword( const QString & );
	QString remoteips() const;
	MappedUser & setRemoteips( const QString & );
	QString schedule() const;
	MappedUser & setSchedule( const QString & );
	QString shell() const;
	MappedUser & setShell( const QString & );
	QString sid() const;
	MappedUser & setSid( const QString & );
	uint uid() const;
	MappedUser & setUid( const uint & );
	uint threadNotifyByJabber() const;
	MappedUser & setThreadNotifyByJabber( const uint & );
	uint threadNotifyByEmail() const;
	MappedUser & setThreadNotifyByEmail( const uint & );
	MappedClient client() const;
	MappedUser & setClient( const Client & );
	uint intranet() const;
	MappedUser & setIntranet( const uint & );
	QString homeDir() const;
	MappedUser & setHomeDir( const QString & );
	uint disabled() const;
	MappedUser & setDisabled( const uint & );
	uint gid() const;
	MappedUser & setGid( const uint & );
	QString usr() const;
	MappedUser & setUsr( const QString & );
	uint keyUsr() const;
	MappedUser & setKeyUsr( const uint & );
	QString lastLogonType() const;
	MappedUser & setLastLogonType( const QString & );
	uint logonCount() const;
	MappedUser & setLogonCount( const uint & );
	MappedJobHistoryList jobHistories() const;
	MappedUserElementList userElements() const;
	MappedUserMappingList userMappings() const;
	MappedUserRoleList userRoles() const;
	MappedUserGroupList userGroups() const;


	static MappedUserList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedUser reload( bool lockForUpdate = false );

	static MappedUser recordByHost( const Host &fkeyHost );
	static MappedUser recordByUserName( const QString &name );
	static MappedUser recordByProject( const Project &fkeyProject );
	static MappedUser recordByUserNameAndDisabled( const QString &name, const uint &disabled );


	static ElementType type();




	static MappedRecord currentUser();
	static void setCurrentUser( const QString & );
	
	static MappedRecord activeByUserName( const QString & );

	static MappedRecord setupProjectUser( Project p, Client c, bool ftp, bool web );
	
	static bool hasPerms( const QString &, bool modify = false, const Project & project = Project() );
	static void permAction( QAction *, const QString &, bool modify = false );

	/* Roles */
	MappedRecordList roles() const;
	void addRole( const AssetType & );
	void removeRole( const AssetType & );

	/* ToolBar Elements */
	MappedRecordList toolBarElements() const;
	void addToolBarElement( const Element & );
	void removeToolBarElement( const Element & );

	bool relatedElement( const Element &, bool recurse=false );

	static uint nextUID();
	static uint nextGID();

	void setDefaultNotificationMethods( NotificationMethodList );
	MappedRecordList defaultNotificationMethods() const;


	static Table * table();
	//static UserSchema * schema();
};


