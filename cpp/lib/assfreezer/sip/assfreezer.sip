
%Module blur.Assfreezer

%Import QtCore/QtCoremod.sip
%Import QtGui/QtGuimod.sip
%Import blur/classes.sip

%DefaultSupertype sip.wrapper

%Include jobsettingswidget.sip
%Include jobsettingswidgetplugin.sip
%Include jobviewerplugin.sip
%Include hostviewerplugin.sip
%Include framenthdialog.sip

%PostInitialisationCode
registerBuiltinCustomJobSettingsWidgets();
%End
