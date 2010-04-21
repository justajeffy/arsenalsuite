

#include "iniconfig.h"
#include "viewmanager.h"

ViewManager * ViewManager::mInstance = 0;

ViewManager::ViewManager()
{}

ViewManager * ViewManager::instance()
{
	if( !mInstance ) mInstance = new ViewManager();
	return mInstance;
}

void ViewManager::readSavedViews( IniConfig & ini )
{
	int viewCount = ini.readInt( "Count" );
	for( int i=1; i<=viewCount; i++ ) {
		QString savedView = ini.readString( QString("ViewName%1").arg(i) );
		if( !savedView.isEmpty() && !mSavedViews.contains( savedView ) )
			mSavedViews << savedView;
	}
}
	
void ViewManager::writeSavedViews( IniConfig & ini )
{
	ini.writeInt( "Count", mSavedViews.size() );
	for( int i=1; i<=mSavedViews.size(); i++ )
		ini.writeString( QString("ViewName%1").arg(i), mSavedViews[i-1] );
}

void ViewManager::addSavedView( const QString & viewName )
{
	removeSavedView(viewName);
	mSavedViews << viewName;
}

void ViewManager::removeSavedView( const QString & viewName )
{
	mSavedViews.removeAll(viewName);
}

QString ViewManager::generateViewName( const QString & suggestion )
{
	QString viewName = suggestion;
	int viewNum = 1;
	while( mSavedViews.contains( viewName ) ) viewName = suggestion + "_" + QString::number(viewNum++);
	return viewName;
}

QStringList ViewManager::savedViews()
{
	return mSavedViews;
}
