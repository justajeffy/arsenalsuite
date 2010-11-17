
class AssfreezerMenuPlugin
{
%TypeHeaderCode
#include <assfreezermenus.h>
%End
public:
	virtual void executeMenuPlugin( QMenu * )=0;
};

class AssfreezerMenuFactory
{
%TypeHeaderCode
#include <assfreezermenus.h>
%End
public:
	static AssfreezerMenuFactory * instance();
	
	void registerMenuPlugin( AssfreezerMenuPlugin * plugin /Transfer/, const QString & menuName );
	QList<QAction*> aboutToShow( QMenu * menu, bool addPreSep = false, bool addPostSep = false );
};
