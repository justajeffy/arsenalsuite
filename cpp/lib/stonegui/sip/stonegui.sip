
%Module blur.Stonegui 0

%Import QtCore/QtCoremod.sip
%Import QtGui/QtGuimod.sip
%Import blur/blurqt.sip

%DefaultSupertype sip.wrapper

%Include configdbdialog.sip
%Include fieldcheckbox.sip
%Include fieldlineedit.sip
%Include fieldspinbox.sip
%Include fieldtextedit.sip
%Include lostconnectiondialog.sip
%Include modeliter.sip
%Include qvariantcmp.sip
%Include recordcombo.sip
%Include recorddelegate.sip
%Include recordlistmodel.sip
%Include recordlistview.sip
%Include recordtreeview.sip
%Include recordsupermodel.sip
%Include supermodel.sip

%ModuleHeaderCode
#include "iconserver.h"
%End

QPixmap icon( const QString & name );
