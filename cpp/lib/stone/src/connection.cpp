
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

#include <qdatetime.h>
#include <qsqldatabase.h>
#include <qsqldriver.h>
#include <qsqlerror.h>

// QSql can suck it
#define protected public
#define private public
#include <qsqlresult.h>
#undef protected
#undef private

#include <qsqlquery.h>

#include "connection.h"
#include "database.h"
#include "iniconfig.h"
#include "sqlerrorhandler.h"
#include "pgconnection.h"

#ifdef Q_OS_WIN
#include <windows.h>
#else
#include <unistd.h>
#endif

namespace Stone {

Connection::Connection(QObject * parent)
: QObject( parent )
, mPort( 0 )
, mReconnectDelay(10)
, mConnectionAttempts(0)
, mMaxConnectionAttempts(-1)
{}

Connection * Connection::create( const QString & dbType )
{
	if( dbType == "QPSQL7" ) {
		PGConnection * c = new PGConnection();
		return c;
	}
	LOG_1( "Unable to create connection for dbType: " + dbType );
	return 0;
}

Connection * Connection::createFromIni( IniConfig & cfg, const QString & section )
{
	cfg.pushSection( section );
	Connection * ret = create( cfg.readString( "DatabaseDriver" ) );
	if( ret )
		ret->setOptionsFromIni(cfg);
	cfg.popSection();
	Q_ASSERT(ret != 0);
	return ret;
}

void Connection::setHost( const QString & host )
{
	mHost = host;
}

void Connection::setPort( int port )
{
	LOG_3( "Port set to " + QString::number(port) );
	mPort = port;
}

void Connection::setDatabaseName( const QString & dbName )
{
	mDatabaseName = dbName;
}

void Connection::setUserName( const QString & userName )
{
	mUserName = userName;
}

void Connection::setPassword( const QString & password )
{
	mPassword = password;
}

void Connection::setReconnectDelay( int reconnectDelay )
{
	mReconnectDelay = reconnectDelay;
}

void Connection::setMaxConnectionAttempts( int maxConnectionAttempts )
{
	mMaxConnectionAttempts = maxConnectionAttempts;
}

void Connection::setOptionsFromIni( const IniConfig & cfg )
{
	setHost( cfg.readString( "Host" ) );
	setPort( cfg.readInt( "Port" ) );
	setDatabaseName( cfg.readString( "DatabaseName" ) );
	setUserName( cfg.readString( "User" ) );
	setPassword( cfg.readString( "Password" ) );
	setReconnectDelay( cfg.readInt( "ReconnectDelay", 30 ) );
	setMaxConnectionAttempts( cfg.readInt( "MaxConnectionAttempts", -1 ) );
}

bool Connection::checkConnection()
{
	// Retry once right away
	if( !isConnected() && !reconnect() )
	{
		emit connectionLost();
		emit connectionLost2();
		// Now either quit should have been called
		// or we are reconnected
	}
	return isConnected();
}

static int qSqlConnNumber()
{
	static int sConnNumber = 1;
	return sConnNumber++;
}

QSqlDbConnection::QSqlDbConnection( const QString & driverName )
{
	mDb = QSqlDatabase::addDatabase( driverName, "QSqlDbConnection" + QString::number(qSqlConnNumber()) );
}

QSqlDbConnection::~QSqlDbConnection()
{
	if( mDb.isOpen() )
		mDb.close();
}

void QSqlDbConnection::setOptionsFromIni( const IniConfig & cfg )
{
	QStringList opts = cfg.readString( "Options" ).split( ";" );
	int timeout = cfg.readInt( "Timeout", 0 );
	if( timeout > 0 )
		opts += ("connect_timeout=" + QString::number(timeout));
	mExtraConnectOptions = opts.join( ";" );
	Connection::setOptionsFromIni(cfg);
}

void QSqlDbConnection::setupSqlDbOptions()
{
	mDb.setHostName( mHost );
	mDb.setPort( mPort );
	mDb.setDatabaseName( mDatabaseName );
	mDb.setUserName( mUserName );
	mDb.setPassword( mPassword );
	mDb.setConnectOptions( mExtraConnectOptions );
}

Connection::Capabilities QSqlDbConnection::capabilities() const
{
	return mDb.driver()->hasFeature( QSqlDriver::Transactions ) ? Cap_Transactions : static_cast<Connection::Capabilities>(0);
}

static int getQueryType( const QSqlQuery & query )
{
	QString q = query.lastQuery().simplified();
	if( q.startsWith( "select", Qt::CaseInsensitive ) )
		return Database::EchoSelect;
	else if( q.startsWith( "update", Qt::CaseInsensitive ) )
		return Database::EchoUpdate;
	else if( q.startsWith( "insert", Qt::CaseInsensitive ) )
		return Database::EchoInsert;
	else if( q.startsWith( "delete", Qt::CaseInsensitive ) )
		return Database::EchoDelete;
	return -1;
}

static QString queryNameFromType( int queryType )
{
	switch( queryType ) {
		case Database::EchoSelect:
			return QString("SELECT");
		case Database::EchoUpdate:
			return QString("UPDATE");
		case Database::EchoInsert:
			return QString("INSERT");
		case Database::EchoDelete:
			return QString("DELETE");
	}
	return QString("UNKNOWN");
}

QSqlQuery QSqlDbConnection::fakePrepare( const QString & sql )
{
// We can use the QSqlResult hack on windows because the symbols arent exported
#ifdef Q_OS_WIN
	checkConnection();
	QSqlQuery q(mDb);
	q.prepare(sql);
#else
	QSqlResult * result = mDb.driver()->createResult();
	QSqlQuery q( result );
	result->QSqlResult::prepare( sql );
#endif
	return q;
}

QSqlQuery QSqlDbConnection::exec( const QString & sql, const QList<QVariant> & vars, bool reExecLostConn, Table * table )
{
	QSqlQuery query = fakePrepare(sql);
	foreach( QVariant v, vars )
		query.addBindValue( v );
	exec( query, reExecLostConn, table, true );
	return query;
}

static QString boundValueString( const QSqlQuery & q )
{
	QStringList valueStrings;
	QMapIterator<QString, QVariant> i(q.boundValues());
	while (i.hasNext()) {
		QString valueString;
		i.next();
		if( !i.key().isEmpty() && i.key() != ":f" )
			valueString = i.key() + ":";
		valueString += i.value().toString();
		valueStrings += valueString;
	}
	if( valueStrings.size() )
		return "(" + valueStrings.join(",") + ")";
	return QString();
}

bool QSqlDbConnection::exec( QSqlQuery & query, bool reExecLostConn, Table * table )
{
	return exec( query, reExecLostConn, table, false );
}

bool QSqlDbConnection::exec( QSqlQuery & query, bool reExecLostConn, Table * table, bool usingFakePrepareHack )
{
	bool result = false;
	int queryType = getQueryType( query );
	do {
		// If gui dialog is connected to the connectionLost signal
		// then it will block in checkConnection until a connection
		// is made(or the user quits the app).
		if( isConnected() || (((mMaxConnectionAttempts < 0) || (mConnectionAttempts < mMaxConnectionAttempts)) && checkConnection()) ) {
			QTime time;
			time.start();
#ifndef Q_OS_WIN
			if( usingFakePrepareHack ) {
				QSqlResult * qsr = (QSqlResult*)query.result();
			    qsr->resetBindCount();

				if (qsr->lastError().isValid())
					qsr->setLastError(QSqlError());

				result = qsr->QSqlResult::exec();
			} else
#endif
				result = query.exec();
			
			if( result ) {
				if( table )
					table->addSqlTime( time.elapsed(), queryType );
	
				Database * db = table ? table->database() : Database::current();
				if( queryType > 0 && db && (db->echoMode() & queryType) ) {
					LOG_3( query.executedQuery() + boundValueString(query) );
				}
				break;
			} else {
				if( !isConnected() || isConnectionError(query.lastError() ) ) {
					LOG_1( "Connection Error During " + queryNameFromType( queryType ) + (reExecLostConn ? (", retrying") : QString()) );
					reconnect();
					continue;
				}
				mLastErrorText = query.executedQuery() + "\n" + query.lastError().text();
				LOG_1( mLastErrorText );
				SqlErrorHandler::instance()->handleError( mLastErrorText );
				break;
			}
		} else {
			LOG_5( "Here2" );
			if( mMaxConnectionAttempts >= 0 && mConnectionAttempts++ >= mMaxConnectionAttempts )
				break;
			QDateTime now = QDateTime::currentDateTime();
			do {
				// This will only happen in a non-gui application, otherwise the lost connection
				// dialog in stonegui will enter it's event look inside the check connection call above.
				QTime t;
				t.start();
				QCoreApplication::instance()->processEvents( QEventLoop::WaitForMoreEvents, 50 );
				if( t.elapsed() < 50 ) {
					//LOG_5( "QApplication::processEvents returned before the timeout period, we must be outside the event loop" );
					#ifdef Q_OS_WIN
					Sleep( 1000 );
					#else
					sleep( 1 );
					#endif
				}
			} while( now.secsTo( QDateTime::currentDateTime() ) < mReconnectDelay );
			LOG_5( "Here3" );
		}
	} while( reExecLostConn );
	return result;
}

bool QSqlDbConnection::reconnect()
{
	if( mDb.isOpen() )
		mDb.close();
	mDb.setHostName( mHost );
	mDb.setPort( mPort );
	mDb.setDatabaseName( mDatabaseName );
	mDb.setUserName( mUserName );
	mDb.setPassword( mPassword );
	mDb.setConnectOptions( mExtraConnectOptions );
	LOG_3( "Connecting... " + connectString() );
	if( !mDb.open() ){
		mLastErrorText = mDb.lastError().driverText();
		LOG_3( "Could not reconnect to database: " + mLastErrorText );
		return false;
	}
	mConnectionAttempts = 0;
	emit connected();
	return true;
}
	
bool QSqlDbConnection::isConnected()
{
	return mDb.isOpen();
}

QString QSqlDbConnection::connectString()
{
	return "Host: " + mDb.hostName() + " Port: " + QString::number(mDb.port()) + " Database: " + mDb.databaseName() + " User: " + mDb.userName() + " Options: " + mDb.connectOptions();
}

bool QSqlDbConnection::isConnectionError( const QSqlError & e )
{
	if( e.type() == QSqlError::ConnectionError
		|| e.databaseText().contains( "server closed the connection" )
		|| e.databaseText().contains( "Software caused connection abort" )
		|| e.databaseText().contains( "Connection timed out" ) )
		return true;
	return false;
}

bool QSqlDbConnection::beginTransaction()
{
	return mDb.transaction();
}

bool QSqlDbConnection::commitTransaction()
{
	return mDb.commit();
}

bool QSqlDbConnection::rollbackTransaction()
{
	return mDb.rollback();
}

} //namespace

