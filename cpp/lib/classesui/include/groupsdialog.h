

#ifndef GROUPS_DIALOG_H
#define GROUPS_DIALOG_H

#include <qmap.h>

#include "classesui.h"

#include "ui_groupsdialogui.h"
#include "user.h"
#include "usergroup.h"
#include "group.h"

class CLASSESUI_EXPORT GroupsDialog : public QDialog, public Ui::GroupsDialogUI
{
Q_OBJECT
public:
	GroupsDialog( QWidget * parent );
	
	void setUser( const User & );
	User user();
	
	GroupList checkedGroups();
	void setCheckedGroups( GroupList );
	
public slots:
	void reset();
	void newGroup();
	void deleteGroup();

protected:
	virtual void accept();

	User mUser;
};

#endif // GROUPS_DIALOG_H

