
#include "dateutil.h"

bool isHoliday( const QDate & date )
{
	QDate jan_1 = QDate(date.year(),1,1);
	QDate jun_1 = QDate(date.year(),6,1);
	QDate sep_1 = QDate(date.year(),9,1);
	QDate oct_1 = QDate(date.year(),10,1);
	QDate nov_1 = QDate(date.year(),11,1);
	QDate xmas = QDate(date.year(),12,25);

	// Memorial day is last friday in may
	QDate mem_day = QDate(date.year(),5,1);
	mem_day = mem_day.addDays((mem_day.dayOfWeek()-1)%7);
	while(mem_day.addDays(7).month() == 5)
		mem_day = mem_day.addDays(7);

	QList<QDate> holidays;
	holidays
		<< QDate(date.year(),1,1)  							// New Years Day
		<< jan_1.addDays((jan_1.dayOfWeek()-1)%7 + 14) 		// Martin Luther King, 3rd Monday of Jan
		<< jun_1.addDays(jun_1.dayOfWeek() == 1 ? -7 : (-jun_1.dayOfWeek()+1)) //Memorial day
		<< QDate(date.year(),7,4)							// Independance day, 4th of july
		<< sep_1.addDays((sep_1.dayOfWeek()-1)%7)			// Labor Day, first Monday in Sept
		//<< oct_1.addDays((oct_1.dayOfWeek()-1)%7+7)			// Columbus Day, second Monday in Oct
		<< nov_1.addDays((nov_1.dayOfWeek()-4)%7+21)		// Thanksgiving, 4th thursday in Nov
		<< xmas;					 						// Christmas

	foreach( QDate holiday, holidays )
		if( holiday == date )
			return true;

	// Blur has the rest of the year off
	if( date > xmas ) return true;

	return false;
}

bool isWorkday( const QDate & date )
{
	return date.dayOfWeek() <= 5 && !isHoliday(date);
}
