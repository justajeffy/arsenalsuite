

#ifndef FREEZER_VIEW_H
#define FREEZER_VIEW_H

#include <qwidget.h>
#include <qmap.h>

#include "afcommon.h"

class QMainWindow;
class QToolBar;
class QMenu;

class FREEZER_EXPORT FreezerView : public QWidget
{
Q_OBJECT
public:
	FreezerView( QWidget * parent );
	~FreezerView();

	virtual QString viewType() const = 0;

    static QString generateViewCode();
    QString viewCode() const;
    void setViewCode( const QString & viewCode );

	QString viewName() const;
	void setViewName( const QString & );

    IniConfig & viewConfig();
    void setViewConfig( IniConfig );

	void restorePopup( QWidget * );

	virtual QToolBar * toolBar( QMainWindow * ) { return 0; }

	virtual void populateViewMenu( QMenu * ) {}

	virtual void applyOptions() {}

	virtual void save( IniConfig & ini );
	virtual void restore( IniConfig & ini );

	QString statusBarMessage() const;
	void setStatusBarMessage( const QString & );
	void clearStatusBar();

	int refreshCount() const;

public slots:
	void refresh();

signals:
	void statusBarMessageChanged( const QString & );

protected slots:
	virtual void doRefresh();

protected:
	bool eventFilter( QObject *, QEvent * );

	/// Stores pointers to each popup window
	/// to save/restore window geometry
	QMap<QWidget*,int> mPopupList;
	int mNextPopupNumber;

	QString mViewName, mStatusBarMessage;
    mutable QString mViewCode;
	bool mRefreshScheduled;
	int mRefreshCount;
    QDateTime mRefreshLast;
    IniConfig mIniConfig;
};

#endif // FREEZER_VIEW_H
