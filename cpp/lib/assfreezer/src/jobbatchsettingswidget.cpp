
/* $Author$
 * $LastChangedDate: 2010-02-16 17:20:26 +1100 (Tue, 16 Feb 2010) $
 * $Rev: 9358 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/jobbatchsettingswidget.cpp $
 */


#include "jobbatchsettingswidget.h"

JobBatchSettingsWidget::JobBatchSettingsWidget( QWidget * parent, JobSettingsWidget::Mode mode )
: CustomJobSettingsWidget( parent, mode )
, mProxy( 0 )
{
	setupUi( this );

	mProxy = new RecordProxy( this );
	mCommandEdit->setProxy( mProxy );
	mPassFramesCheck->setProxy( mProxy );
	mRunAsSubmitterCheck->setProxy( mProxy );
	
	connect( mCommandEdit, SIGNAL( textEdited( const QString & ) ), SLOT( settingsChange() ) );

	if( mode == JobSettingsWidget::ModifyJobs )
		mVerticalLayout->addLayout( mApplyResetLayout );
}

JobBatchSettingsWidget::~JobBatchSettingsWidget()
{
}

QStringList JobBatchSettingsWidget::supportedJobTypes()
{
	return jobTypes();
}

QStringList JobBatchSettingsWidget::jobTypes()
{
	return QStringList( "Batch" );
}

void JobBatchSettingsWidget::resetSettings()
{
	mProxy->setRecordList( mSelectedJobs, false, false );
	CustomJobSettingsWidget::resetSettings();
}

void JobBatchSettingsWidget::applySettings()
{
	mProxy->applyChanges( /*commit=*/ mMode == JobSettingsWidget::ModifyJobs );
	CustomJobSettingsWidget::resetSettings();
}
