
%Module blur.Assfreezer

%Import QtCore/QtCoremod.sip
%Import QtGui/QtGuimod.sip
%Import blur/classes.sip

%DefaultSupertype sip.wrapper

%Include jobsettingswidget.sip
%Include jobsettingswidgetplugin.sip
%Include framenthdialog.sip

class JobViewerPlugin
{
%TypeHeaderCode
#include <jobviewerplugin.h>
%End
public:
    JobViewerPlugin();
    virtual ~JobViewerPlugin();
    virtual QString name();
    virtual QString icon();
    virtual void view( const JobList & );
    virtual bool enabled( const JobList & );
};

class JobViewerFactory
{
%TypeHeaderCode
#include <jobviewerfactory.h>
%End
    public:
    static void registerPlugin( JobViewerPlugin * jvp /Transfer/ );
};

class HostViewerPlugin
{
%TypeHeaderCode
#include <hostviewerplugin.h>
%End
public:
    HostViewerPlugin();
    virtual ~HostViewerPlugin();
    virtual QString name();
    virtual QString icon();
    virtual void view( const HostList & );
    virtual bool enabled( const HostList & );
};

class HostViewerFactory
{
%TypeHeaderCode
#include <hostviewerfactory.h>
%End
    public:
    static void registerPlugin( HostViewerPlugin * jvp /Transfer/ );
};

%PostInitialisationCode
registerBuiltinCustomJobSettingsWidgets();
%End
