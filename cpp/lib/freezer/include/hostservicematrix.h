
#ifndef HOST_SERVICE_MATRIX_H
#define HOST_SERVICE_MATRIX_H

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

    HostService findHostService( const QModelIndex & idx );
    Service serviceByColumn( int column ) const;

    void setHostList( HostList hosts );

    void setHostFilter( const QString &, bool cs );

public slots:
	void updateServices();

protected:
    HostStatusList mStatuses;
    QMap<Host,HostServiceList> mHostServicesByHost;
	ServiceList mServices;
};

class FREEZER_EXPORT HostServiceMatrix : public RecordTreeView
{
Q_OBJECT
public:
	HostServiceMatrix( QWidget * parent = 0 );

    bool hostFilterCS() const { return mHostFilterCS; }
    bool serviceFilterCS() const { return mServiceFilterCS; }

public slots:
	void setHostFilter( const QString & );
	void setServiceFilter( const QString & );

    void setHostFilterCS( bool cs );
    void setServiceFilterCS( bool cs );

	void slotShowMenu( const QPoint & pos, const QModelIndex & underMouse );

	void updateServices();
protected:

	QString mHostFilter, mServiceFilter;
    bool mHostFilterCS, mServiceFilterCS;
	HostServiceModel * mModel;
};

class FREEZER_EXPORT HostServiceMatrixWindow : public QMainWindow, public Ui::HostServiceMatrixWindowUi
{
Q_OBJECT
public:
	HostServiceMatrixWindow( QWidget * parent = 0 );

public slots:
	void newService();

protected:
    virtual bool eventFilter( QObject * o, QEvent * e );

	HostServiceMatrix * mView;
};

#endif // HOST_SERVICE_MATRIX_H
