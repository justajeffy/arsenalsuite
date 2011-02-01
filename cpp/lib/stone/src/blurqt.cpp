
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of libstone.
 *
 * libstone is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * libstone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with libstone; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id: blurqt.cpp 9590 2010-03-25 01:19:50Z brobison $
 */

#include <qglobal.h>

#ifdef Q_OS_WIN
#include "windows.h"
#include "shellapi.h"
#endif

#include "pyembed.h"
 
#include <qcoreapplication.h>
#include <stdlib.h>
#include <qfile.h>
#include <qfileinfo.h>
#include <qdir.h>
#include <qprocess.h>
#include <qfiledialog.h>
#include <qlibrary.h>
#include <qpainter.h>
#include <qbitmap.h>

#include "blurqt.h"
#include "database.h"
#include "freezercore.h"
#include "iniconfig.h"
#include "interval.h"
#include "multilog.h"
#include "record.h"
#include "schema.h"

IniConfig sConfig, sUserConfig;
static bool sUserConfigRead = false;
static QString sConfigName, sLogFile;

void initStone( int argc, char ** argv )
{
	QStringList args;
	for( int i = 1; i<argc; i++ )
		args << QString::fromLatin1( argv[i] );
	initStone(args);
}

void initStone( const QStringList & args )
{
	IniConfig & cfg = config();
	int argc = args.size();
	for( int i=0; i < argc; i++ ) {
		QString arg = args[i];
		bool hasNext = i+1<argc;
		if( arg == "-db-host" && hasNext ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "Host", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-db-port" && hasNext ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "Port", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-db-name" && hasNext ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "DatabaseName", args[++i] );
			cfg.popSection();
		}
		if( arg == "-db-user" && hasNext ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "User", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-db-password" && hasNext ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "Password", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-rum-host" && hasNext ) {
			cfg.pushSection( "Update Server" );
			cfg.writeString( "Host", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-rum-port" && hasNext ) {
			cfg.pushSection( "Update Server" );
			cfg.writeString( "Port", args[++i] );
			cfg.popSection();
		} else
		if( arg == "-show-sql" ) {
			cfg.pushSection( "Database" );
			cfg.writeString( "EchoMode", "EchoSelect,EchoUpdate,EchoInsert,EchoDelete" );
			cfg.popSection();
		}
		if( arg == "-log-file" && hasNext ) {
			sLogFile = args[++i];
		}
	}
}

QString stoneOptionsHelp()
{
	QStringList ret;
	// Keep this list in sync with the docs in blurqt.h
	ret << "-show-sql";
	ret << "\tOutputs all executed sql to stdout";
	ret << "-show-time";
	ret << "\tOutputs time information at program termination, include sql and index time";
	ret << "-create-database";
	ret << "\tCreates all missing tables in the database, then exits";
	ret << "-verify-database";
	ret << "\tVerifies all tables in the database, then exits";
	ret << "-output-schema FILE";
	ret << "\tOutputs the database schema in xml format to FILE";
	ret << "-db-host HOST";
	ret << "\tSet the database host to HOST. Can be either a hostname or an ipv4 address";
	ret << "-db-port PORT";
	ret << "\tSet the database port to PORT";
	ret << "-db-user USER";
	ret << "\tSet the database username to USER";
	ret << "-db-password PASS";
	ret << "\tSet the database password to PASS";
	ret << "-rum-host HOST";
	ret << "\tSet the update server host to HOST. Can be either a hostname or an ipv4 address";
	ret << "-rum-port PORT";
	ret << "\tSet the update server port to PORT";
	return ret.join("\n");
}

void initConfig( const QString & configName, const QString & logfile )
{
	if( !QCoreApplication::instance() ) {
		fprintf( stderr, "Calling initConfig before creating a QApplication object is not recommented\nCreating a QCoreApplication object now to avoid a crash\n" );
		int argc = 0;
		new QCoreApplication(argc, (char**)0);
	}
#ifdef Q_OS_WIN
	// Used for 64 bit dlls, won't show up under syswow64
	QCoreApplication::addLibraryPath("c:/windows/system32/blur64/");
	QCoreApplication::addLibraryPath("c:/blur/common/");
#endif
	sConfigName = configName;
	sConfig.setFileName( configName );
	sConfig.readFromFile();
	sLogFile = logfile;
	if( !sLogFile.isEmpty() && sLogFile.right(4) != ".log" )
		sLogFile = sLogFile + ".log";
	qRegisterMetaType<Record>("Record");
	qRegisterMetaType<RecordList>("RecordList");
	qRegisterMetaType<Interval>("Interval");
}

void initUserConfig( const QString & fileName )
{
	sUserConfigRead = true;
	sUserConfig.setFileName( fileName );
	sUserConfig.readFromFile();
}

static Multilog * mLog = 0;

void shutdown()
{
	FreezerCore::shutdown();
//	Database::shutdown();
	sConfig.writeToFile();
	if( sUserConfigRead )
		sUserConfig.writeToFile();
	delete mLog;
	mLog = 0;
}

IniConfig & config()
{
	return sConfig;
}

IniConfig & userConfig()
{
	return sUserConfig;
}

static bool sLoggingEnabled = true;

Multilog * log()
{
	if( sLoggingEnabled && !mLog ) {
		sConfig.pushSection( "Logging" );
		sLoggingEnabled = sConfig.readBool( "Enabled", true );
		if( sLoggingEnabled ) {
			mLog = new Multilog(
			sLogFile.isEmpty() ? sConfig.readString( "File", sConfigName.replace(".ini","") + ".log" ) : sLogFile, // Filename
			sConfig.readBool( "EchoStdOut", true ),
			sConfig.readInt( "MaxSeverity", 2 ), // Only critical and important errors by default
			sConfig.readInt( "MaxFiles", 10 ),
			sConfig.readInt( "MaxSize", 1024 * 1024 ) ); // One megabyte
		}
		sConfig.popSection();
	}
	return mLog;
}

void Log( const QString & message, int severity, const QString & file )
{
	if( sLoggingEnabled && log() ) {
		log()->log( severity, message, file );
	}
}

bool sendEmail( QStringList recipients, const QString & subject, const QString & body, const QString & sender, QStringList attachments )
{
	bool success = runPythonFunction( "blur.email", "send", VarList() << sender << recipients << subject << body << attachments ).toBool();
	if( !success ) {
		LOG_1( "Unable to send email: \nSubject:\t" + subject + "\nRecipients:\t" + recipients.join(",")
		 + "\nBody:\t" + body + "\nattachments:\t" + attachments.join(","));
	}
	return success;
}

#ifdef Q_WS_WIN

QString getUserName()
{
	char buf[100];
	int size=100;
	GetUserNameA(buf, (LPDWORD)(&size));
	buf[size]=0;
	return QString(buf);
}

#else

#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

QString getUserName()
{
	struct passwd * ps = getpwuid(getuid());
	if( !ps )
		return QString::null;
	return QString(ps->pw_name);
}

#endif // Q_WS_WIN

