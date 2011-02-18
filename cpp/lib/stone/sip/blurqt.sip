
%Module blur.Stone 0

%Import QtCore/QtCoremod.sip
%Import QtGui/QtGuimod.sip
%Import QtSql/QtSqlmod.sip
%Import QtXml/QtXmlmod.sip

%DefaultSupertype sip.wrapper

%ModuleHeaderCode
#include "blurqt.h"
#include "path.h"
#include "process.h"
#include "pyembed.h"
%End

void initStone( const QStringList & );

QString stoneOptionsHelp();

void initConfig( const QString & configName, const QString & logfile = QString()  );

void initUserConfig( const QString & userConfigFile );

void shutdown();

IniConfig & config();
IniConfig & userConfig();

Multilog * log();

QString getUserName();

void Log( const QString & message, int severity = 1, const QString & file = QString() );

bool sendEmail( QStringList recipients, const QString & subject, const QString & body, const QString & sender, QStringList attachments = QStringList() );

%Include connection.sip
%Include database.sip
%Include dateutil.sip
%Include field.sip
%Include freezercore.sip
%Include index.sip
%Include indexschema.sip
%Include iniconfig.sip
%Include interval.sip
%Include multilog.sip
%Include path.sip
%Include process.sip
%Include pgconnection.sip
%Include pyembed.sip
%Include record.sip
%Include recordimp.sip
%Include recordlist.sip
%Include recordproxy.sip
%Include recordxml.sip
%Include schema.sip
%Include sqlerrorhandler.sip
%Include table.sip
%Include tableschema.sip
%Include undomanager.sip
%Include updatemanager.sip