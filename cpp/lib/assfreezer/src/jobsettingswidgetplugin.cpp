
/* $Author: brobison $
 * $LastChangedDate: 2010-02-16 17:20:26 +1100 (Tue, 16 Feb 2010) $
 * $Rev: 9358 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/jobsettingswidgetplugin.cpp $
 */

#include "jobsettingswidgetplugin.h"

#include "jobaftereffectssettingswidget.h"
#include "jobbatchsettingswidget.h"
#include "jobfusionsettingswidget.h"
#include "jobmaxsettingswidget.h"
#include "jobmayasettingswidget.h"
#include "jobmaxscriptsettingswidget.h"
#include "jobshakesettingswidget.h"
#include "jobxsisettingswidget.h"

class BuiltinCustomJobSettingsWidgetsPlugin : public CustomJobSettingsWidgetPlugin
{
public:
	QStringList jobTypes();
	CustomJobSettingsWidget * createCustomJobSettingsWidget( const QString & jobType, QWidget * parent, JobSettingsWidget::Mode );
};

QStringList BuiltinCustomJobSettingsWidgetsPlugin::jobTypes()
{
	return JobMaxSettingsWidget::jobTypes()
		 + JobMayaSettingsWidget::jobTypes()
		 + JobAfterEffectsSettingsWidget::jobTypes()
		 + JobShakeSettingsWidget::jobTypes()
		 + JobBatchSettingsWidget::jobTypes()
		 + JobMaxScriptSettingsWidget::jobTypes()
		 + JobXSISettingsWidget::jobTypes()
		 + JobFusionSettingsWidget::jobTypes()
		 + JobFusionVideoMakerSettingsWidget::jobTypes();
}

CustomJobSettingsWidget * BuiltinCustomJobSettingsWidgetsPlugin::createCustomJobSettingsWidget( const QString & jobType, QWidget * parent, JobSettingsWidget::Mode mode )
{
	if( JobMaxSettingsWidget::jobTypes().contains( jobType ) )
		return new JobMaxSettingsWidget( parent, mode );
	else if( JobMayaSettingsWidget::jobTypes().contains( jobType ) )
		return new JobMayaSettingsWidget( parent, mode );
	else if( JobAfterEffectsSettingsWidget::jobTypes().contains( jobType ) )
		return new JobAfterEffectsSettingsWidget( parent, mode );
	else if( JobShakeSettingsWidget::jobTypes().contains( jobType ) )
		return new JobShakeSettingsWidget( parent, mode );
	else if( JobBatchSettingsWidget::jobTypes().contains( jobType ) )
		return new JobBatchSettingsWidget( parent, mode );
	else if( JobMaxScriptSettingsWidget::jobTypes().contains( jobType ) )
		return new JobMaxScriptSettingsWidget( parent, mode );
	else if( JobXSISettingsWidget::jobTypes().contains( jobType ) )
		return new JobXSISettingsWidget( parent, mode );
	else if( JobFusionSettingsWidget::jobTypes().contains( jobType ) )
		return new JobFusionSettingsWidget( parent, mode );
	else if( JobFusionVideoMakerSettingsWidget::jobTypes().contains( jobType ) )
		return new JobFusionVideoMakerSettingsWidget( parent, mode );
	return 0;
}

static BuiltinCustomJobSettingsWidgetsPlugin * sBuiltinPlugin = 0;

void registerBuiltinCustomJobSettingsWidgets()
{
	if( !sBuiltinPlugin ) {
		sBuiltinPlugin = new BuiltinCustomJobSettingsWidgetsPlugin();
		CustomJobSettingsWidgetsFactory::registerPlugin( sBuiltinPlugin );
	}
}

bool CustomJobSettingsWidgetsFactory::mPluginsLoaded = false;

QMap<QString,CustomJobSettingsWidgetPlugin*>  CustomJobSettingsWidgetsFactory::mCustomJobSettingsWidgetsPlugins;

bool CustomJobSettingsWidgetsFactory::supportsJobType( const QString & jobType )
{
	return !jobType.isEmpty() && mCustomJobSettingsWidgetsPlugins.contains( jobType );
}

void CustomJobSettingsWidgetsFactory::registerPlugin( CustomJobSettingsWidgetPlugin * wp )
{
	QStringList types = wp->jobTypes();
	foreach( QString t, types )
		if( !mCustomJobSettingsWidgetsPlugins.contains(t) ) {
			mCustomJobSettingsWidgetsPlugins[t] = wp;
			LOG_3( "Registering CustomJobSettingsWidget for jobtype: " + t );
		}
}

CustomJobSettingsWidget * CustomJobSettingsWidgetsFactory::createCustomJobSettingsWidget( const QString & jobType, QWidget * parent, JobSettingsWidget::Mode mode  )
{
	if( jobType.isEmpty() )
		return 0;

	if( mCustomJobSettingsWidgetsPlugins.contains( jobType ) ) {
		CustomJobSettingsWidget * jsw = mCustomJobSettingsWidgetsPlugins[jobType]->createCustomJobSettingsWidget(jobType,parent,mode);
		return jsw;
	}
	return 0;
}


