
class FreezerMenuPlugin
{
%TypeHeaderCode
#include <assfreezermenus.h>
%End
public:
	virtual void executeMenuPlugin( QMenu * )=0;
};

class FreezerMenuFactory
{
%TypeHeaderCode
#include <assfreezermenus.h>
%End
public:
	static FreezerMenuFactory * instance();
	
	void registerMenuPlugin( FreezerMenuPlugin * plugin /Transfer/, const QString & menuName );
	QList<QAction*> aboutToShow( QMenu * menu, bool addPreSep = false, bool addPostSep = false );
};
