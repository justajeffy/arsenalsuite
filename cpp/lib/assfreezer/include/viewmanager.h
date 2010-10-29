
#ifndef VIEW_MANAGER_H
#define VIEW_MANAGER_H

#include <qstringlist.h>

class IniConfig;
class AssfreezerView;

class ViewManager
{
public:
	ViewManager();

	static ViewManager * instance();

	void readSavedViews( IniConfig & );
	
	void writeSavedViews( IniConfig & );

	void addSavedView( const QString & viewName );
	void removeSavedView( const QString & viewName );

	QString generateViewName( const QString & suggestion );

	QStringList savedViews();

protected:
	QStringList mSavedViews;

	static ViewManager * mInstance;
};


#endif // VIEW_MANAGER_H
