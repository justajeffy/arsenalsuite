
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of RenderLine.
 *
 * RenderLine is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * RenderLine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RenderLine; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#include "Python.h"

#include <qapplication.h>
#include <qdir.h>
#include <qhostaddress.h>
#include <qlibrary.h>
#include <qpalette.h>

#include "blurqt.h"
#include "database.h"
#include "freezercore.h"
#include "schema.h"
#include "process.h"
#include "path.h"

#include "stonegui.h"
#include "tardstyle.h"

#include "classes.h"
#include "host.h"
#include "jobassignment.h"
#include "user.h"

#include "afcommon.h"
#include "joblistwidget.h"
#include "mainwindow.h"

#ifdef Q_OS_WIN
#include "windows.h"
#endif

extern void classes_loader();

#ifdef Q_OS_WIN
BOOL CALLBACK AFEnumWindowsProc( HWND hwnd, LPARAM otherProcessId )
{
	int pid = (int)otherProcessId;
	int winPid;
	GetWindowThreadProcessId( hwnd, (DWORD*)&winPid );
	LOG_5( "Found window with process id: " + QString::number( winPid ) );
	if( winPid == pid ) {
		LOG_5( "Raising window" );
		if( IsIconic( hwnd ) )
			OpenIcon( hwnd );
		SetForegroundWindow( hwnd );
	//	SetWindowPos( hwnd, HWND_TOP, 0, 0, 0, 0, SWP_ASYNCWINDOWPOS | SWP_NOMOVE | SWP_NOSIZE );
	}
	return true;
}

HANDLE hMutex;
#endif

#ifdef Q_OS_WIN
extern "C" void initsip(void);
extern "C" void initStone(void);
extern "C" void initClasses(void);
extern "C" void initAssfreezer(void);
#endif

void loadPythonPlugins()
{
	LOG_5( "Loading Python" );

#ifdef Q_OS_WIN
	/*
	 * This structure specifies the names and initialisation functions of
	 * the builtin modules.
	 */
	struct _inittab builtin_modules[] = {
		{"sip", initsip},
		{"blur.Stone",initStone},
		{"blur.Classes",initClasses},
		{"blur.Assfreezer", initAssfreezer},
		{NULL, NULL}
	};

	PyImport_ExtendInittab(builtin_modules);
#endif
	
	Py_Initialize();

	const char * builtinModuleImportStr = 
#ifdef Q_OS_WIN
		"import imp,sys\n"
		"class MetaLoader(object):\n"
		"\tdef __init__(self):\n"
		"\t\tself.modules = {}\n"

		"\t\tself.modules['blur.Stone'] = imp.load_module('blur.Stone',None,'',('','',imp.C_BUILTIN))\n"
		"\t\tself.modules['blur.Classes'] = imp.load_module('blur.Classes',None,'',('','',imp.C_BUILTIN))\n"
		"\t\tself.modules['blur.Absubmit'] = imp.load_module('blur.Absubmit',None,'',('','',imp.C_BUILTIN))\n"

		"\t\tself.modules['blur.Assfreezer'] = imp.load_module('blur.Assfreezer',None,'',('','',imp.C_BUILTIN))\n"
		"\tdef find_module(self,fullname,path=None):\n"
		"\t\tif fullname in self.modules:\n"
		"\t\t\treturn self.modules[fullname]\n"
		"sys.meta_path.append(MetaLoader())\n"
		"import blur\n"
		"blur.RedirectOutputToLog()\n";
#else
		"import blur\n"
		"blur.RedirectOutputToLog()\n";
#endif
	PyRun_SimpleString(builtinModuleImportStr);

	LOG_5( "Loading python plugins" );
	
	QDir plugin_dir( "afplugins" );
	QStringList el = plugin_dir.entryList(QStringList() << "*.py" << "*.pys" << "*.pyw", QDir::Files);
	foreach( QString plug, el ) {
		QString name("afplugins/" + plug);
		LOG_5( "Loading plugin: " + name );
		bool error = false;
		QString contents = readFullFile( name, &error );
		if( error ) {
			LOG_3( "Unable to open " + name + " for reading" );
			continue;
		}
		contents.replace("\r","");
		PyRun_SimpleString(contents.toLatin1());
	}
}

int main( int argc, char * argv[] )
{
	int result=0;

#ifdef Q_OS_WIN
	hMutex = CreateMutex( NULL, true, L"AssFreezerSingleProcessMutex");
	if (hMutex == NULL) {
		LOG_5( "Error: Couldn't create mutex, exiting" );
		return false;
	}
	if( GetLastError() == ERROR_ALREADY_EXISTS ) {
		LOG_5( "Error: Another process owns the mutex, exiting" );
		QList<int> pids;
		if( pidsByName( "assfreezer.exe", &pids ) ) {
			int otherProcessId = pids[0];
			if( otherProcessId == processID() ) {
				if( pids.size() < 2 )
					return false;
				otherProcessId = pids[1];
			}
			LOG_5( "Trying to find window with process pid of " + QString::number( otherProcessId ) );
			EnumWindows( AFEnumWindowsProc, LPARAM(otherProcessId) );
		}
		return false;
	}

	QLibrary excdll( "exchndl.dll" );
	if( !excdll.load() ) {
		qWarning( excdll.errorString().toLatin1().constData() );
	}
	disableWindowsErrorReporting( "assburner.exe" );

#endif

	QApplication a(argc, argv);

	initConfig( "assfreezer.ini" );

#ifdef Q_OS_WIN
	QString cp = "h:/public/" + getUserName() + "/Blur";
	if( !QDir( cp ).exists() )
		cp = "C:/Documents and Settings/" + getUserName();
	initUserConfig( cp + "/assfreezer.ini" );
#else
	initUserConfig( QDir::homePath() + "/.assfreezer" );
#endif

	initStone( argc, argv );
 	classes_loader();
	initStoneGui();
	{
		JobList showJobs;
		bool showTime = false;
	
		for( int i = 1; i<argc; i++ ){
			QString arg( argv[i] );
			if( arg == "-h" || arg == "--help" )
			{
				LOG_5( QString("AssFreezer v") + VERSION );
				LOG_5( "Options:" );
				LOG_5( "-current-render" );
				LOG_5( "\tShow the current job that is rendering on this machine\n" );
				LOG_5( "-show-time" );
				LOG_5( "\tOutputs summary of time executed for all sql statement at program close\n" );
				LOG_5( "-user USER" );
				LOG_5( "\tSet the logged in user to USER: Requires Admin Privs" );
				LOG_5( stoneOptionsHelp() );
				return 0;
			}
			else if( arg == "-show-time" )
				showTime = true;
			else if( arg == "-current-render" ) {
				showJobs = Host::currentHost().activeAssignments().jobs();
			}
			else if( arg == "-user" && (i+1 < argc) ) {
				QString impersonate( argv[++i] );
				if( User::hasPerms( "User", true ) ) // If you can edit users, you can login as anyone
					User::setCurrentUser( impersonate );
			}
		}
		
		// Share the database across threads, each with their own connection
		FreezerCore::setDatabaseForThread( classesDb(), Connection::createFromIni( config(), "Database" ) );
		
		{
			MainWindow m;
			IniConfig & cfg = userConfig();
			cfg.pushSection( "MainWindow" );
			QStringList fg = cfg.readString( "FrameGeometry", "" ).split(',');
			cfg.popSection();
			if( fg.size()==4 ) {
				m.resize( QSize( fg[2].toInt(), fg[3].toInt() ) );
				m.move( QPoint( fg[0].toInt(), fg[1].toInt() ) );
			}
			if( showJobs.size() )
				m.jobPage()->setJobList( showJobs );
			m.show();
			loadPythonPlugins();
			result = a.exec();
			if( showTime ){
				Database * tm = Database::current();
				LOG_5( 			"                  Sql Time Elapsed" );
				LOG_5(			"|   Select  |   Update  |  Insert  |  Delete  |  Total  |" );
				LOG_5( 			"-----------------------------------------------" );
				LOG_5( QString(	"|     %1    |     %2    |    %3    |    %4    |    %5   |\n")
					.arg( tm->elapsedSqlTime( Table::SqlSelect ) )
					.arg( tm->elapsedSqlTime( Table::SqlUpdate ) )
					.arg( tm->elapsedSqlTime( Table::SqlInsert ) )
					.arg( tm->elapsedSqlTime( Table::SqlDelete ) )
					.arg( tm->elapsedSqlTime() )
				);
				LOG_5( 			"                  Index Time Elapsed" );
				LOG_5(			"|   Added  |   Updated  |  Incoming  |  Deleted  |  Search  |  Total  |" );
				LOG_5( 			"-----------------------------------------------" );
				LOG_5( QString(	"|     %1     |     %2    |    %3    |    %4   |    %5    |   %6    |\n")
					.arg( tm->elapsedIndexTime( Table::IndexAdded ) )
					.arg( tm->elapsedIndexTime( Table::IndexUpdated ) )
					.arg( tm->elapsedIndexTime( Table::IndexIncoming ) )
					.arg( tm->elapsedIndexTime( Table::IndexRemoved ) )
					.arg( tm->elapsedIndexTime( Table::IndexSearch ) )
					.arg( tm->elapsedIndexTime() )
				);
				tm->printStats();
			}
		}
	}
	shutdown();
#ifdef Q_OS_WIN
	CloseHandle( hMutex );
#endif
	return result;
}

