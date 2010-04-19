
#include <qtimer.h>
#include <qevent.h>

#include "blurqt.h"
#include "freezercore.h"
#include "iniconfig.h"

#include "assfreezerview.h"
#include "viewmanager.h"

AssfreezerView::AssfreezerView( QWidget * parent )
: QWidget( parent )
, mRefreshScheduled( false )
, mRefreshCount( 0 )
{}

AssfreezerView::~AssfreezerView()
{
	FreezerCore::instance()->cancelObjectTasks(this);
}

void AssfreezerView::refresh()
{
	if( !mRefreshScheduled ) {
		mRefreshScheduled = true;
		mRefreshCount++;
		QTimer::singleShot( 0, this, SLOT( doRefresh() ) );
	}
}

int AssfreezerView::refreshCount() const
{
	return mRefreshCount;
}

void AssfreezerView::doRefresh()
{
	mRefreshScheduled = false;
}

void AssfreezerView::restorePopup( QWidget * w )
{
#ifndef Q_OS_WIN
	w->hide();
	w->setWindowFlags( w->windowFlags() | Qt::Tool );
	w->setAttribute( Qt::WA_DeleteOnClose, true );
	w->show();
#endif // !Q_OS_WIN
	w->installEventFilter( this );
	QString popupName = "Popup" + QString::number( mNextPopupNumber );
	IniConfig & cfg = userConfig();
	cfg.pushSection(popupName);
	QRect frameRect = cfg.readRect( "WindowGeometry", QRect( 0, 0, 200, 400 ) );
	w->resize( frameRect.size() );
	w->move( frameRect.topLeft() );
	cfg.popSection();
	mPopupList[w] = mNextPopupNumber;
	QList<int> values = mPopupList.values();
	while( values.contains( mNextPopupNumber ) ) mNextPopupNumber++;
}

bool AssfreezerView::eventFilter( QObject * o, QEvent * e )
{
	QWidget * w = qobject_cast<QWidget*>(o);
	if( w && mPopupList.contains( w ) ) {
		QEvent::Type type = e->type();
		if( type == QEvent::Resize || type == QEvent::Move ) {
			IniConfig & cfg = userConfig();
			cfg.pushSection( "Popup" + QString::number( mPopupList[w] ) );
			cfg.writeRect( "WindowGeometry", QRect( w->pos(), w->size() ) );
			cfg.popSection();
		}
		if( type == QEvent::Close ) {
			mNextPopupNumber = qMin( mNextPopupNumber, mPopupList[w] );
			mPopupList.remove( w );
		}
	}
	return QWidget::eventFilter( o, e );
}

QString AssfreezerView::statusBarMessage() const
{
	return mStatusBarMessage;
}

void AssfreezerView::setStatusBarMessage( const QString & sbm )
{
	mStatusBarMessage = sbm;
	emit statusBarMessageChanged( mStatusBarMessage );
}

void AssfreezerView::clearStatusBar()
{
	setStatusBarMessage(QString());
}

QString AssfreezerView::viewName() const
{
	if( mViewName.isEmpty() )
		const_cast<AssfreezerView*>(this)->setViewName( ViewManager::instance()->generateViewName( viewType() ) );
	return mViewName;
}

void AssfreezerView::setViewName( const QString & viewName )
{
	mViewName = viewName;
}

void AssfreezerView::save( IniConfig & ini )
{
	ini.writeString("ViewName",mViewName);
}

void AssfreezerView::restore( IniConfig & )
{
	applyOptions();
}
