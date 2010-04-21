
/* $Header$
 */


#ifndef JOB_STAT_WIDGET_H
#define JOB_STAT_WIDGET_H

#include <qtreewidget.h>

#include "job.h"

class JobStatWidget : public QTreeWidget
{
Q_OBJECT
public:
	JobStatWidget( QWidget * parent = 0 );

	void setJobs( const JobList & );
	JobList jobs() const;

	void refresh();

protected:
	JobList mJobs;

};

#endif // JOB_STAT_WIDGET_H
