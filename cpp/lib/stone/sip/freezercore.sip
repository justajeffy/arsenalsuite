
class ThreadTask : QEvent
{
%TypeHeaderCode
#include <freezercore.h>
%End
public:
	ThreadTask( int type = 0, QObject * reciever = 0 );
	
	virtual void run();
};

class FreezerCore : QObject
{
%TypeHeaderCode
#include <freezercore.h>
%End
public:
	FreezerCore();
	~FreezerCore();

	static FreezerCore * instance();
	
	static void shutdown();

	void shutdownThreads();

	static void addTask( ThreadTask * /Transfer/ );
	static void wakeup();
};

