
#ifndef GRAPHITE_PRIVATE_H
#define GRAPHITE_PRIVATE_H

#include <qdatetime.h>
#include <qlist.h>
#include <qmutex.h>
#include <qstring.h>
#include <qthread.h>

class QTcpSocket;

class GraphiteDataPoint;

class GraphiteSender : public QObject
{
Q_OBJECT
public:
	GraphiteSender( const QString & host, quint16 port );
	~GraphiteSender();
	
	
public slots:
	void sendQueuedDataPoints();
	
protected:
	void connectSocket();
	bool event( QEvent * );

	QTcpSocket * mSocket;
	QString mGraphiteHost;
	quint16 mGraphitePort;
};

class GraphiteThread : public QThread
{
Q_OBJECT
public:
	GraphiteThread();
	~GraphiteThread();

	// Thread safe functions
	void record( const QString & path, double value, const QDateTime & timestamp );
	bool hasQueuedRecords();
	GraphiteDataPoint popQueuedRecord();
	
	static GraphiteThread * instance();
	
protected:
	void run();
	static GraphiteThread * mThread;

	QString mGraphiteHost;
	quint16 mGraphitePort;
	GraphiteSender * mSender;
	QMutex mQueueMutex;
	QList<GraphiteDataPoint> mQueue;
	friend class GraphiteSender;
};

#endif // GRAPHITE_PRIVATE_H
