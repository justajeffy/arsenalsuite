

#ifndef ASSFREEZER_VIEW_H
#define ASSFREEZER_VIEW_H

#include <qwidget.h>
#include <qmap.h>

#include "afcommon.h"

class QMainWindow;
class QToolBar;
class QMenu;

class ASSFREEZER_EXPORT AssfreezerView : public QWidget
{
Q_OBJECT
public:
	AssfreezerView( QWidget * parent );
	~AssfreezerView();

	virtual QString viewType() const = 0;

	QString viewName() const;
	void setViewName( const QString & );

    IniConfig & viewConfig();

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
	bool mRefreshScheduled;
	int mRefreshCount;
};

#endif // ASSFREEZER_VIEW_H
