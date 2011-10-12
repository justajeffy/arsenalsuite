
#ifndef HOST_SERVICE_MATRIX_H
#define HOST_SERVICE_MATRIX_H

#include <qaction.h>
#include <qtimer.h>

#include "host.h"
#include "hostservice.h"
#include "hoststatus.h"
#include "service.h"

#include "recordsupermodel.h"
#include "recordtreeview.h"

#include "afcommon.h"

#include "ui_hostservicematrixwindowui.h"

class HostServiceModel;

class FREEZER_EXPORT HostServiceModel : public RecordSuperModel
{
Q_OBJECT
public:
	HostServiceModel( QObject * parent = 0 );

	HostService findHostService( const Host & host, int column ) const;
	HostService findHostService( const QModelIndex & ) const;
	QVariant serviceData ( const Host &, int column, int role ) const;

	void setHostFilter( const QString &, bool cascading=false );
    void setServiceFilter( const QString &, bool cascading=false );
    void setStatusFilter( const QString &, bool cascading=false );
    void setOSFilter( const QString &, bool cascading=false );
    void setUserLoggedFilter( bool, bool, bool cascading=false );

public slots:
	void updateServices();

protected:
    bool hostFiltering;
    QString currentHostFilter;

    bool statusFiltering;
    QString currentStatusFilter;

    bool osFiltering;
    QString currentOsFilter;

    bool userFiltering;

    HostList currentFilteredList;

	ServiceList mServices;
};

class FREEZER_EXPORT HostServiceMatrix : public RecordTreeView
{
Q_OBJECT
public:
	HostServiceMatrix( QWidget * parent = 0 );
    HostServiceModel * getModel() const;

public slots:
	void setHostFilter( const QString & );
	void setServiceFilter( const QString & );
    void setStatusFilter( const QString & );
    void setOSFilter( const QString & );
    void setUserLoggedFilter( int );

    void setUserLoggedType( bool );

    void hostTimerExpired();
    void statusTimerExpired();
    void osTimerExpired();

	void slotShowMenu( const QPoint & pos, const QModelIndex & underMouse );

	void updateServices();
protected:
    QTimer* hostFTimer;
    QTimer* statusFTimer;
    QTimer* osFTimer;

    bool useLoggedIn;
    bool userFiltering;

	QString mHostFilter, mServiceFilter, mHostStatusFilter, mHostOsFilter;
	HostServiceModel * mModel;
};

class FREEZER_EXPORT HostServiceMatrixWindow : public QMainWindow, public Ui::HostServiceMatrixWindowUi
{
Q_OBJECT
public:
	HostServiceMatrixWindow( QWidget * parent = 0 );

    void refreshHostGroups();

public slots:
    void setShowMyGroupsOnly( bool );
    void showOptionsMenu();
    void performHostGroupRefresh();
    void hostGroupChanged( const Record & hgr );
	void newService();

    void saveHostGroup();
    void manageHostLists();

protected:
	HostServiceMatrix * mView;
    bool mHostGroupRefreshPending;
    HostList hostList() const;

    QAction * mShowMyGroupsOnlyAction, * mManageGroupsAction, * mSaveGroupAction;
};

#endif // HOST_SERVICE_MATRIX_H
