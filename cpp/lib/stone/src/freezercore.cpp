
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
 * $Id$
 */

#include <qsqldatabase.h>
#include <qsqlerror.h>

#include "blurqt.h"
#include "database.h"
#include "freezercore.h"
#include "iniconfig.h"
//#include "lostconnectiondialog.h"

namespace Stone {

ThreadTask::ThreadTask( int type, QObject * receiver )
: QEvent( QEvent::Type(type) )
, mReceiver( receiver )
, mCancel( false )
{}

BackgroundThread::BackgroundThread( FreezerCore * fc )
: mExit( false )
, mFC( fc )
, mTask( 0 )
{}

void BackgroundThread::run()
{
	while( !mExit ) {
		mFC->getTask(this);
		if( !mTask ) {
			mFC->wait();
			continue;
		}
		mTask->run();
		mFC->deliver(this);
		//qApp->wakeUpGuiThread();
	}
}

void ThreadTask::run()
{
}

FreezerCore::FreezerCore()
{
/*	IniConfig & c = config();
	c.pushSection("Database");
	mDb = QSqlDatabase::addDatabase(c.readString( "DatabaseDriver", "QPSQL7" ));
	c.popSection(); */
	for( int i=0; i<1; i++ ) {
		BackgroundThread * bt = new BackgroundThread( this );
		mThreads += bt;
		bt->start();
	}
}

FreezerCore::~FreezerCore()
{
	shutdownThreads();
}

void FreezerCore::shutdownThreads()
{
	foreach( BackgroundThread * thread, mThreads ) {
		thread->mExit = true;
		thread->wait();
		delete thread;
	}
}
/*
bool FreezerCore::checkConnection()
{
	// Retry once right away
	QString error;
	if( !isConnected() && !reconnect(&error) )
	{
		emit connectionLost();
		emit connectionLost2();
		// Now either quit should have been called
		// or we are reconnected
	}
	return isConnected();
}

QString FreezerCore::connectString()
{
	return "Host: " + mDb.hostName() + " Database: " + mDb.databaseName() + " User: " + mDb.userName() + " Options: " + mDb.connectOptions();
}

bool FreezerCore::reconnect(QString * error)
{
	lockDb();
	IniConfig & c = config();
	c.pushSection("Database");
	if( mDb.isOpen() ) {
		mDb.close();
	}
	mDb.setHostName(c.readString( "Host", "war.x" ));
	mDb.setDatabaseName(c.readString( "DatabaseName", "blur" ));
	mDb.setUserName(c.readString( "User", "brobison" ));
	mDb.setPassword(c.readString( "Password", "" ));
	mDb.setPort(c.readInt( "Port", 5432 ));
	mDb.setConnectOptions( "connect_timeout=" + c.readString( "Timeout", "2" ) );
	c.popSection();
	LOG_3( "FreezerCore::reconnect: Connecting... " + connectString() );
	if( !mDb.open() ){
		QString er = mDb.lastError().driverText();
		LOG_3( "FreezerCore::reconnect: Couldnt reconnect to database: " + er );
		if( error )
			*error = er;
		unlockDb();
		return false;
	}
	unlockDb();
	emit connected();
	return true;
}

bool FreezerCore::isConnected()
{
	return mDb.isOpen();
}
*/
void FreezerCore::getTask( BackgroundThread * thread )
{
	mTaskMutex.lock();
	if( !mTasks.isEmpty() ) {
		thread->mTask = mTasks.back();
		mTasks.pop_back();
	}
	mTaskMutex.unlock();
}

void FreezerCore::addTask( ThreadTask * task )
{
	FreezerCore * fc = instance();
	fc->mTaskMutex.lock();
	fc->mTasks.push_front( task );
	fc->mTaskMutex.unlock();
}

void FreezerCore::deliver( BackgroundThread * thread )
{
	mTaskMutex.lock();
	ThreadTask * task = thread->mTask;
	if( task && !task->mCancel && task->mReceiver ) {
	//	printf( "Delivering task to object %p\n", task->mReceiver );
		QCoreApplication::postEvent( task->mReceiver, task );
	} else {
	//	if( task->mReceiver && task->mCancel )
	//		printf( "Delivery canceled for task to object %p\n", task->mReceiver );
		delete task;
	}
	thread->mTask = 0;
	mTaskMutex.unlock();
}

void FreezerCore::cancelObjectTasks( QObject * object )
{
	mTaskMutex.lock();
	printf( "Cancelling tasks for object %p\n", object );
	foreach( ThreadTask * task, mTasks ) {
		if( task->mReceiver == object ) {
			mTasks.removeAll(task);
			delete task;
		}
	}
	foreach( BackgroundThread * thread, mThreads )
		if( thread->mTask && thread->mTask->mReceiver == object )
			thread->mTask->mCancel = true;
	mTaskMutex.unlock();
}

void FreezerCore::cancelTask( ThreadTask * task )
{
	FreezerCore * fc = instance();
	fc->mTaskMutex.lock();
	task->mCancel = true;
	fc->mTasks.removeAll(task);
	fc->mTaskMutex.unlock();
}

class SetThreadDatabaseTask : public ThreadTask
{
public:
	SetThreadDatabaseTask( Database * db, Connection * c )
	: mDb( db ), mConn( c ) {}
	void run() {
		mConn->reconnect();
		mDb->setConnection( mConn );
		Database::setCurrent( mDb );
	}
	Database * mDb;
	Connection * mConn;
};

void FreezerCore::setDatabaseForThread( Database * db, Connection * c )
{
	addTask( new SetThreadDatabaseTask( db, c ) );
}

void FreezerCore::wakeup()
{
	FreezerCore * fc = instance();
	fc->mWait.wakeAll();
}

void FreezerCore::wait()
{
	mTaskMutex.lock();
	mWait.wait( &mTaskMutex, 50 );
	mTaskMutex.unlock();
}

FreezerCore * FreezerCore::mCore = 0;

FreezerCore * FreezerCore::instance()
{
	if( !mCore ){
		mCore = new FreezerCore;
	}
	return mCore;
}

void FreezerCore::shutdown()
{
	if( mCore ) {
		delete mCore;
		mCore = 0;
	}
}

} //namespace

