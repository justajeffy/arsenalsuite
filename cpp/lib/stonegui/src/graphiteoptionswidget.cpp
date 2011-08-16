
#include "graphitewidget.h"
#include "graphiteoptionswidget.h"

GraphiteOptionsWidget::GraphiteOptionsWidget( QWidget * parent )
: QWidget( parent )
, mGraphiteWidget( 0 )
{
	setupUi(this);
	connect( mTimeRangeCombo, SIGNAL( currentIndexChanged(int) ), SLOT( timeRangeComboChanged() ) );
	connect( mValueRangeCombo, SIGNAL( currentIndexChanged(int) ), SLOT( valueRangeComboChanged() ) );
	mTimeRangeGroup->hide();
	mValueRangeGroup->hide();
}

void GraphiteOptionsWidget::setGraphiteWidget( GraphiteWidget * graphiteWidget )
{
	mGraphiteWidget = graphiteWidget;
}

static void apply( GraphiteWidget * gw, GraphiteDesc::AreaMode areaMode, const QDateTime & start, const QDateTime & end, int minValue, int maxValue )
{
	gw->setAreaMode( areaMode );
	gw->setDateRange( start, end );
	gw->setValueRange( minValue, maxValue );
	gw->refresh();
}

void GraphiteOptionsWidget::applyOptions()
{
	if( !mGraphiteWidget ) return;
	QDateTime start, end;
	int minValue = INT_MAX, maxValue = INT_MAX;
	GraphiteDesc::AreaMode areaMode = GraphiteDesc::None;
	
	QString trt = mTimeRangeCombo->currentText();
	if( trt == "Last Week" ) {
		start = QDateTime::currentDateTime().addDays(-7);
	} else if( trt == "Last Month" ) {
		start = QDateTime::currentDateTime().addMonths(-1);
	} else if( trt == "Last Year" ) {
		start = QDateTime::currentDateTime().addYears(-1);
	} else if( trt == "Specify Range..." ) {
		end = mEndDateTimeEdit->dateTime();
		start = mStartDateTimeEdit->dateTime();
	}
	
	QString vrt = mValueRangeCombo->currentText();
	if( vrt.startsWith( "Percentage" ) ) {
		minValue = 0;
		maxValue = 100;
	} else if( vrt == "Specify Range..." ) {
		minValue = mMinValueSpin->value();
		maxValue = mMaxValueSpin->value();
	}

	areaMode = GraphiteDesc::areaModeFromString(mAreaModeCombo->currentText());
	
	apply( mGraphiteWidget, areaMode, start, end, minValue, maxValue );
}

void GraphiteOptionsWidget::resetOptions()
{
	
}

void GraphiteOptionsWidget::timeRangeComboChanged()
{
	bool manual = mTimeRangeCombo->currentText() == "Specify Range...";
	if( manual )
		mTimeRangeGroup->show();
	else
		mTimeRangeGroup->hide();
}

void GraphiteOptionsWidget::valueRangeComboChanged()
{
	bool manual = mValueRangeCombo->currentText() == "Specify Range...";
	if( manual )
		mValueRangeGroup->show();
	else
		mValueRangeGroup->hide();
}

