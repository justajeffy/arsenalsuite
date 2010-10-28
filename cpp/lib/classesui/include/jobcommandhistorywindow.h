
/* $Author$
 * $LastChangedDate$
 * $Rev$
 * $HeadURL$
 */

#ifndef JOB_ASSIGNMENT_WINDOW_H
#define JOB_ASSIGNMENT_WINDOW_H

#include <qmainwindow.h>

#include "jobassignment.h"

#include "classesui.h"

#include "ui_jobcommandhistorywindowui.h"

class CLASSESUI_EXPORT JobAssignmentWindow : public QMainWindow, public Ui::JobCommandHistoryWindowUI
{
Q_OBJECT
public:
	JobAssignmentWindow( QWidget * parent=0 );
	~JobAssignmentWindow();

	void setJobAssignment(const JobAssignment &);
	JobAssignment jobAssignment();

public slots:
	void refresh();

protected slots:
	void doRefresh();

protected:
	bool mRefreshRequested;
	JobAssignment mJobAssignment;
	QString mLogRoot;
};

#endif // JOB_ASSIGNMENT_WINDOW_H

