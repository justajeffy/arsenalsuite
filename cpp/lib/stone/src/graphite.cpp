
#include <qhostinfo.h>
#include <QTcpSocket>
#include <qtextstream.h>

#include "blurqt.h"
#include "graphite.h"
#include "graphite_p.h"
#include "iniconfig.h"

struct GraphiteDataPoint
{
	GraphiteDataPoint( const QString & _path, double _value, const QDateTime & _timestamp ) : path(_path), value(_value), timestamp(_timestamp) {}
	GraphiteDataPoint(){}
	QString path;
	double value;
	QDateTime timestamp;
};

GraphiteSender::GraphiteSender( const QString & host, quint16 port )
: mSocket( 0 )
, mGraphiteHost( host )
, mGraphitePort( port )
{
	mSocket = new QTcpSocket(this);
	connect( mSocket, SIGNAL( connected() ), SLOT( sendQueuedDataPoints() ) );
	if( GraphiteThread::instance()->hasQueuedRecords() )
		connectSocket();
}

GraphiteSender::~GraphiteSender()
{}

void GraphiteSender::connectSocket()
{
	if( mSocket ) {
		LOG_5( "Connecting to graphite host: " + mGraphiteHost + ":" + QString::number( mGraphitePort ) );
		mSocket->connectToHost( mGraphiteHost, mGraphitePort );
	}
}

void GraphiteSender::sendQueuedDataPoints()
{
	if( !mSocket ) return;
	if( mSocket->state() != QTcpSocket::ConnectedState ) {
		if( GraphiteThread::instance()->hasQueuedRecords() && mSocket->state() == QTcpSocket::UnconnectedState )
			connectSocket();
		return;
	}

	QTextStream ts(mSocket);
	while( GraphiteThread::instance()->hasQueuedRecords() ) {
		
		GraphiteDataPoint dp = GraphiteThread::instance()->popQueuedRecord();
		// Write to socket
		ts << dp.path << " " << dp.value << " " << dp.timestamp.toTime_t() << endl;
		LOG_5( "Wrote Value to Graphite: " + dp.path + " " + QString::number(dp.value) + " " + QString::number( dp.timestamp.toTime_t() ) );
	}
}

bool GraphiteSender::event( QEvent * event )
{
	if( event->type() == QEvent::User ) {
		sendQueuedDataPoints();
		return true;
	}
	return QObject::event(event);
}

GraphiteThread::GraphiteThread()
: mSender( 0 )
{
	IniConfig & ini = config();
	ini.pushSection( "Graphite" );
	mGraphiteHost = ini.readString( "Host", "graphite.blur.com" );
	mGraphitePort = ini.readInt( "Port", 2003 );
	ini.popSection();
}

GraphiteThread::~GraphiteThread()
{}

bool GraphiteThread::hasQueuedRecords()
{
	bool ret;
	mQueueMutex.lock();
	ret = mQueue.size();
	mQueueMutex.unlock();
	return ret;
}

GraphiteDataPoint GraphiteThread::popQueuedRecord()
{
	GraphiteDataPoint ret;
	mQueueMutex.lock();
	if( !mQueue.isEmpty() ) {
		ret = mQueue.back();
		mQueue.pop_back();
	}
	mQueueMutex.unlock();
	return ret;
}

void GraphiteThread::record( const QString & path, double value, const QDateTime & timestamp )
{
	mQueueMutex.lock();
	mQueue.push_front( GraphiteDataPoint(path,value,timestamp) );
	mQueueMutex.unlock();
	if( mSender )
		QApplication::postEvent( mSender, new QEvent( QEvent::User ) );
	// Doesn't work, FUCK YOU Qt!
	//QMetaObject::invokeMethod( mSender, SLOT( sendQueuedDataPoints() ), Qt::QueuedConnection );
}

void GraphiteThread::run()
{
	mSender = new GraphiteSender(mGraphiteHost, mGraphitePort);
	LOG_5( "Calling exec()" );
	exec();
	LOG_5( "Destorying mSender" );
	delete mSender;
	mSender = 0;
}

GraphiteThread * GraphiteThread::instance()
{
	if( mThread == 0 ) {
		mThread = new GraphiteThread();
		mThread->start();
	}
	return mThread;
}

GraphiteThread * GraphiteThread::mThread = 0;


void graphiteRecord( const QString & _path, double value, const QDateTime & timestamp )
{
	QString path(_path);
	if( path.contains( "%(user)" ) )
		path = path.replace( "%(user)", getUserName() );
	if( path.contains( "%(host)" ) )
		path = path.replace( "%(host)", QHostInfo::localHostName().section(".",0,0) );
	GraphiteThread::instance()->record(path,value,timestamp);
}

