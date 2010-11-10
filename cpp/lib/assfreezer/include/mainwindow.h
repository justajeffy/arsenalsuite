/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of Assburner.
 *
 * Assburner is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Assburner is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Blur; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
 
#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <QMenu>
#include <QToolBar>
#include <QMainWindow>

#include "afcommon.h"

const QString VERSION("1.1.2");

class QLabel;
class QTimer;
class QTabWidget;
class QStackedWidget;

class AssfreezerView;
class JobListWidget;
class HostListWidget;
class Service;

class ASSFREEZER_EXPORT MainWindow : public QMainWindow
{
Q_OBJECT
public:
	MainWindow(QWidget * parent=0);
	~MainWindow();

	virtual void closeEvent( QCloseEvent * );
	virtual bool event( QEvent * );

	bool autoRefreshEnabled() const;

	bool autoRefreshOnWindowActivation() const;

	JobListWidget * jobPage() const { return mJobPage; }
	HostListWidget * hostPage() const { return mHostPage; }

public slots:
	void setAutoRefreshEnabled( bool );
	void setAutoRefreshOnWindowActivation( bool );

	void openHostServiceMatrixWindow();
	void openUserServiceMatrixWindow();

	void enableAdmin();
	void applyOptions();
	void showDisplayPrefs();
	void showSettings();
	void showAbout();

	void setCounterState(bool);
	void updateCounter();

	void autoRefresh();

	void showProjectWeightDialog();

	void showHostView();
	void showJobView();

	void createJobView();
	void createHostView();
	void closeCurrentView();

	void cloneView( AssfreezerView * view );
	void cloneCurrentView();
	void saveCurrentViewAs();
	void saveViewAs( AssfreezerView * );
	void moveViewLeft( AssfreezerView * );
	void moveViewRight( AssfreezerView * );
	void moveCurrentViewLeft();
	void moveCurrentViewRight();

	// Pops up dialog to prompt user
	void renameView( AssfreezerView * view );
	void renameCurrentView();

	AssfreezerView * currentView() const { return mCurrentView; }

	void insertView( AssfreezerView * view, bool checkViewModeCheckCurrent=true );
	void removeView( AssfreezerView * view );

	void setCurrentView( const QString & );
	void setCurrentView( AssfreezerView * );

    void showNextView();

    void toggleFilter(bool);

    void saveCurrentViewToFile();
    void saveViewToFile( AssfreezerView * );
    void loadViewFromFile(bool notUsed=true);
    void loadViewFromFile(const QString &);

signals:
    void currentViewChanged( AssfreezerView * );

protected slots:
	void currentTabChanged( int );
	void populateViewMenu();
	void populateRestoreViewMenu();
    void populateToolsMenu();

	void restoreViewActionTriggered(QAction*);
	bool checkViewModeChange();

	void hostViewActionToggled(bool);
	void jobViewActionToggled(bool);
private:
	virtual bool eventFilter( QObject *, QEvent * );
	virtual void keyPressEvent( QKeyEvent * event );

	void showTabMenu( const QPoint & pos, AssfreezerView * view );

	void saveViews();
	void saveView( AssfreezerView * );
	void restoreViews();
	AssfreezerView * restoreSavedView( const QString & viewName, bool updateWindow = true );
	AssfreezerView * restoreView( IniConfig &, const QString & viewName, bool updateWindow = true );

	void repopulateToolBar();

	void setupStackedView();
	void setupTabbedView();

	// Periodic check to ensure renderfarm is 'online'
	void updateFarmStatus( const Service & managerService );

	QTabWidget * mTabWidget;
	QStackedWidget * mStackedWidget;

	QList<AssfreezerView*> mViews;
	AssfreezerView * mCurrentView;
	
	JobListWidget * mJobPage;
	HostListWidget * mHostPage;
	QLabel * mCounterLabel;
	QLabel * mFarmStatusLabel;

	bool mAdminEnabled, mCounterActive;

	QTimer * mAutoRefreshTimer;

	/* Actions */
	QAction* FileExitAction;
	QAction* HelpAboutAction;

	QAction* ViewHostsAction;
	QAction* ViewJobsAction;

	QAction* DisplayPrefsAction;
	QAction* SettingsAction;
	QAction* AdminAction;
	QAction* HostServiceMatrixAction;
	QAction* UserServiceMatrixAction;
	QAction* AutoRefreshAction;

	QAction * mNewJobViewAction;
	QAction * mNewHostViewAction;
	QAction * mSaveViewAsAction;
	QAction * mCloseViewAction;
	QAction * mMoveViewLeftAction;
	QAction * mMoveViewRightAction;

    QAction * mFilterViewAction;

	QAction * mSaveViewToFileAction;
	QAction * mLoadViewFromFileAction;

	QMenu * mFileMenu, * mToolsMenu, * mOptionsMenu, * mViewMenu, * mRestoreViewMenu, * mHelpMenu;
	QToolBar *Toolbar;
};

#endif // MAIN_WINDOW_H

