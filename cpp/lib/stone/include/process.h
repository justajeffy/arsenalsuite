
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
 * $Id: process.h 9060 2009-11-23 00:52:42Z brobison $
 */

#ifndef LIB_BLUR_QT_PROCESS_H
#define LIB_BLUR_QT_PROCESS_H

#include <qstring.h>
#include <qlist.h>

#include "blurqt.h"
#include <qprocess.h>

#include <qprocess.h>

#ifdef Q_OS_WIN
#include <windows.h>

class QIODevice;
class QTimer;

class STONE_EXPORT Win32Process : public QObject
{
Q_OBJECT
public:
	Win32Process( QObject * parent = 0 );

	enum LogonFlag {
		LogonWithoutProfile = 0,
		LogonWithProfile = 1,
		LogonWithNetCredentials = 2
	};
 
	void setLogonFlag( LogonFlag flag );

	/// If this is set, the process will be started in it's own login session
	void setLogon( const QString & userName, const QString & password, const QString & domain = QString() );

	bool start( const QString & program, const QStringList & args = QStringList() );

	void setInheritableIOChannels( bool ioc );

	void setWorkingDirectory( const QString & );

	// An empty string list(default) will use the users
	// default environment.  To create a blank environment
	// pass a string list with 1 empty string.
	void setEnvironment( QStringList env );

	QProcess::ProcessError error() const;

/*
	QIODevice * stdin();
	QIODevice * stderr();
	QIODevice * stdout();
*/
	int exitCode();
	
	bool isRunning();

	QProcess::ProcessState state() const;

	Q_PID pid();
	
	void terminate();

	static Win32Process * create( QObject * parent, const QString & cmd, const QString & userName = QString(), const QString & password = QString(), const QString & domain = QString() );
signals:
	void error ( QProcess::ProcessError error );
	void finished ( int exitCode, QProcess::ExitStatus exitStatus );
	void readyReadStandardError();
	void readyReadStandardOutput();
	void started();
	void stateChanged( QProcess::ProcessState newState );

protected slots:
	void _checkup();

protected:
	void _error(QProcess::ProcessError, const QString &);

	int mLogonFlag;
	QString mCmd, mUserName, mPassword, mDomain, mWorkingDir, mErrorString;
	QStringList mEnv;
	bool mInheritableIOChannels;
	int mExitCode;
	QProcess::ProcessError mError;
	QProcess::ProcessState mState;
	PROCESS_INFORMATION mProcessInfo;
	QTimer * mCheckupTimer;
	HANDLE stdin_in, stdin_out, stdout_in, stdout_out, stderr_in, stderr_out;
//	friend class ProcessJob;
};

#endif // Q_OS_WIN
/*
class STONE_EXPORT ProcessJob : public QObject
{
Q_OBJECT
public:
	ProcessJob( QObject * parent = 0 );

	bool addProcess( Process * process );

	QList<Process*> processes();

	void terminate();

protected:

#ifdef Q_OS_WIN
	HANDLE mWindowsJobHandle;
#endif // Q_OS_WIN
};
*/

STONE_EXPORT void openExplorer( const QString & );

STONE_EXPORT void openFrameCycler( const QString & );

STONE_EXPORT void openURL( const QString & );

STONE_EXPORT void vncHost(const QString & host);

/// Returns true if there is a process running with pid
/// and name( if name is not null )
STONE_EXPORT bool isRunning(int pid, const QString & name = QString::null);

/// Kills process with pid
STONE_EXPORT bool killProcess(qint32 pid);

/// Returns the pid of this process
STONE_EXPORT int processID();

/// Reads a pid from 'filePath'
STONE_EXPORT int pidFromFile( const QString & filePath );

/// Writes a pid to 'filePath'
STONE_EXPORT bool pidToFile( const QString & filePath );

/// Returns the number of processes that are named 'name'
/// Return a list of pids if pidList!=0
STONE_EXPORT int pidsByName( const QString & name, QList<int> * pidList=0, bool caseSensitive = false );

STONE_EXPORT bool killAll( const QString & processName, int timeout = 0, bool caseSensitive = false );

STONE_EXPORT QString backtick(const QString & cmd);

/// Enums through all the windows, if any of the window titles
/// matches the titles list, then all the processes with names
/// contained in the toKill list will be terminated
STONE_EXPORT bool killWindows( QStringList titles, QStringList toKill, QString * windowFound = 0, bool caseSensitive = false );

#ifdef Q_OS_WIN
/// returns a list of window handles
/// for every window that has a title that matches
/// the regular expression nameRE
STONE_EXPORT QList<HWND> getWindowsByName( const QString & nameRE );

STONE_EXPORT bool processHasNamedWindow( int pid, const QString & nameRE, bool processRecursive = false );

#endif // Q_OS_WIN
STONE_EXPORT bool setProcessPriorityClass( int pid, unsigned long priorityClass );

STONE_EXPORT int setProcessPriorityClassByName( const QString & name, unsigned long priorityClass );

/// Returns the amount of free memory in the system
struct STONE_EXPORT SystemMemInfo {
	SystemMemInfo() : freeMemory(0), cachedMemory(0), totalMemory(0), caps(0) {}
	enum Caps {
		FreeMemory = 1,
		CachedMemory = 2,
		TotalMemory = 4
	};
	// Kilobytes
	int freeMemory, cachedMemory, totalMemory;
	int caps;
};

STONE_EXPORT SystemMemInfo systemMemoryInfo();

struct STONE_EXPORT ProcessMemInfo {
	ProcessMemInfo() : currentSize(0), maxSize(0), caps(0) {}
	enum Caps {
		CurrentSize = 1,
		MaxSize = 2,
		Recursive = 4
	};
	// Kilobytes
	int currentSize, maxSize;
	int caps;
};

STONE_EXPORT ProcessMemInfo processMemoryInfo( qint32 pid, bool recursive = false );

class QProcess;
/// Returns the pid of the process
/// Q_PID doesn't return the pid on windows, instead returns
/// a process information struct.  This function works around
/// that so you can get a valid integer pid for all platforms
STONE_EXPORT qint32 qprocessId( QProcess * );
STONE_EXPORT qint32 qpidToId( Q_PID qpid );

STONE_EXPORT qint32 processParentId( qint32 pid );

STONE_EXPORT QList<qint32> processChildrenIds( qint32 pid, bool recursive = false );

STONE_EXPORT bool systemShutdown( bool reboot = false );

#ifdef Q_OS_WIN
/// Win32 only
/// Returns the Process ID of the process that created the window hWin. */
STONE_EXPORT qint32 windowProcess( HWND hWin );

struct STONE_EXPORT WindowInfo {
	QString title;
	qint32 processId;
	HWND hWin;
};
/**
 *  Win32 only
 *  Returns WindowInfo structures filled with the information about all toplevel windows
 *  belonging to the process with pid.  If recursive is true, returns all windows for all
 *  descendant processes along with pid. */
STONE_EXPORT QList<WindowInfo> windowInfoByProcess( qint32 pid, bool recursive = false );

/**
 *	Win32 only
 *	Returns true if running inside  a 32 bit application on 64 bit windows.
 *  Wow64 is the name of window's 32 bit compatibility layer. */
STONE_EXPORT bool isWow64();

/**
 *  Win32 only
 *  Turns off windows error reporting crash dialog for executableName.
 *
 *  Addes executableName key HKEY_LOCAL_MACHINE/Software/Microsoft/PCHealth/ErrorReporting/ExclusionList with
 *  DWORD value of 1.  Sets KEY_WOW64_64KEY when running under Wow64 to workaround registry redirect. */
STONE_EXPORT bool disableWindowsErrorReporting( const QString & executableName );
#endif

#endif // LIB_BLUR_QT_PROCESS_H

