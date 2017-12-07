/*
Auhtors: Amandeep Sidhu and Robert J. Hijmans
         University of California, Davis

partly based on code by __________

Version 0.1
Date: July 2016

License: GNU General Public License (GNU GPL) v. 2
*/

#include "SimDate.h"
using namespace std;
#include <vector>
#include <string>
#include <sstream>


const int month_days[12] =      {31,28,31,30,31,30,31,31,30,31,30,31};
const int month_days_leap[12] = {31,29,31,30,31,30,31,31,30,31,30,31};

SimDate::SimDate() {
	vyear = 0;
	vmonth = 1;
	vday = 1;
};

SimDate::SimDate(const int& year, const int& month, const int& day) {
	vyear = year;
	vmonth = month;
	vday = day;
};


SimDate::SimDate(const string& s) {
	std::stringstream ss(s);
	std::vector<std::string> elems;
	std::string item;
	while (std::getline(ss, item, '-')) {
		elems.push_back(item);
	}
	vyear = stoi(elems[0].c_str());
	vmonth= stoi(elems[1].c_str());
	vday = stoi(elems[2].c_str());
};



bool leapyear(int year) {
	//check for leapyear
	if (year % 4 == 0 && ((year % 400 == 0) || (year % 100 != 0 ))) {
		return true;
	} else {
		return false;
	}
};


bool SimDate::is_leap_year() const {
	return leapyear(vyear);
};


SimDate::SimDate(int doy, int year) {
	if (doy == 0) doy = 1;

	if (doy < 0) {  // this is a weird case, but let's try to handle it
		while ( doy < 0 ) {
			year--;
			doy = doy + 365 + leapyear(year);
		}
		doy = 365 + leapyear(year) - doy;

	} else {
		while ( doy > 366 ) {
			doy = doy - 365 - leapyear(year);
			year++;
		}
	}

	const int *mdays;
	if ( leapyear(year) ) { mdays =  month_days_leap;
	} else { 	mdays = month_days; }

	int month= 0 ;
	while ( doy > mdays[month] ) {
			doy = doy - mdays[month];
			month++;
	}

	vyear = year;
	vmonth = month+1;
	vday = doy;
}


int SimDate::day() const { return vday ; };
int SimDate::month() const { return vmonth ; };
int SimDate::year() const { return vyear ; };



int SimDate::dayofyear() {

	const int *mdays;
	if ( is_leap_year() ) { mdays =  month_days_leap;
	} else { 	mdays = month_days; }

	int doy = 0;
	for (int i=0; i < vmonth-1; i++) {
			doy = doy + mdays[i];
	}
	return( doy + vday );
};


void SimDate::set_day  (const int& day)   { SimDate::vday = day; };
void SimDate::set_month(const int& month) { SimDate::vmonth = month; };
void SimDate::set_year (const int& year)  { SimDate::vyear = year; };


bool SimDate::valid() const {
	if (vmonth > 12 || vmonth < 1) {
			return false;
	} else if (vday > 31 || vday < 1) {
			return false;
	} else if ((vday == 31 && ( vmonth == 2 || vmonth == 4 || vmonth == 6 || vmonth == 9 || vmonth == 11) ) ) {
 			return false;
	} else if (vday == 30  && vmonth == 2 ) {
			return false;
	} else if (vday == 29 && vmonth == 2 && !is_leap_year()) {
		return false;
	}
	return true;
}



bool operator == (const SimDate& d1,const SimDate& d2){
	if( (d1.day() == d2.day()) && (d1.month() == d2.month()) && (d1.year() == d2.year())) {
		return true;
	} else {
		return false;
	}
}



bool operator !=(const SimDate& d1, const SimDate& d2){
	return !(d1 == d2);
}



inline SimDate next_SimDate(const SimDate& d) {
	SimDate ndat;
	if (!d.valid()) {
		return ndat;
		// should throw error?
	}; // return 0-1-1

	ndat = SimDate(d.year(),d.month(),(d.day() + 1));
	if (ndat.valid())
		return ndat;

	ndat=SimDate(d.year(),(d.month() + 1),1);

	if (ndat.valid())
		return ndat;

	ndat = SimDate((d.year() + 1),1,1);
	return ndat;
};



inline SimDate previous_SimDate(const SimDate& d){
	SimDate ndat;
	if (!d.valid()) {
		return ndat;
	}; // return 0-1-1

	ndat = SimDate(d.year(),d.month(),(d.day() - 1 ));

	if (ndat.valid())
		return ndat;

	ndat = SimDate(d.year(),(d.month() - 1),31);

	if (ndat.valid())
		return ndat;

	ndat = SimDate(d.year(),(d.month() - 1),30);

	if (ndat.valid())
		return ndat;

	ndat = SimDate(d.year(),(d.month() - 1),29);

	if (ndat.valid())
		return ndat;

	ndat = SimDate(d.year(),(d.month() - 1),28);

	if (ndat.valid())
		return ndat;

	ndat = SimDate((d.year() - 1), 12, 31);
		return ndat;
};



SimDate SimDate::operator ++(int){ // postfix operator SimDate d = *this;
	SimDate d = *this;
	*this = next_SimDate(d);
	return d;
}



SimDate SimDate::operator ++() {
	*this = next_SimDate(*this);
	return *this;
}



SimDate SimDate::operator --(int){ // postfix operator SimDate d = *this;
	SimDate d = *this;
	*this = previous_SimDate(d);
	return d;
}



SimDate SimDate::operator --(){
	*this = previous_SimDate(*this);
	return *this;
}



ostream & operator << (ostream& os, const SimDate& d){
	os << d.year() << "-" << d.month() << "-" << d.day();
	return os;
}



bool operator < (const SimDate& d1, const SimDate& d2){

	if (d1.year() < d2.year()) {
			return true;
	}
	if (d1.year() > d2.year()) {
			return false;
	}
	if (d1.month() < d2.month()) {
			return true;
	}
	if (d1.month() > d2.month()) {
			return false;
	}
	if ( d1.day() < d2.day()) {
			return true;
	}
	return false;
};



bool operator <=(const SimDate& d1, const SimDate& d2){
	if (d1 == d2) {
		return true;
	}
	return (d1 < d2);
}



bool operator >=(const SimDate& d1, const SimDate& d2) {
	if (d1 == d2) {
		return true;
	}
	return ! ( d1 < d2 ) ;
}



bool operator > (const SimDate& d1, const SimDate& d2) {
	if (d1 == d2) {
		return false;
	}
	return !(d1 < d2);
}



int operator - (SimDate& d1,  SimDate& d2) {

	if(d1 == d2) { return 0; }
	
	bool negative = false;
	if (d1 < d2) {
		SimDate tmp = d1;
		d1 = d2;
		d2 = tmp;
		negative = true;
	}

	int day1 = d1.dayofyear();
	int year1 = d1.year();
	int day2 = d2.dayofyear();
	int year2 = d2.year();

	if (year2 == year1) {
		if (negative) {
			return (day2 - day1);
		} else {
			return (day1 - day2);		
		}
	}

	int x = 0;

	if (leapyear(year2)) {
		x = 366 - day2;
	} else {
		x = 365 - day2;
	}
	year2++;

	while (year2 != year1) {
		if (leapyear(year2)) {
			x = 366 + x;
		} else {
			x = 365 + x;
		}
		year2++;
	}

	x = x + day1;

	if (negative) {
		return (-x);
	} else { 
		return x;
	}
}



SimDate operator +(SimDate &d1, int x){

	int day = d1.dayofyear();
	int year = d1.year();
  int month = d1.month();
	day = day + x;

	if (day <= 365 + leapyear(year)) {
		return (SimDate(day, year));
	}

	if (month < 3) {
		while ( day > 366 ) {
			if ( leapyear(year) ) {
				day = day - 366;
			} else {
				day = day - 365;
			}
			year++;
		}
	}	else { // month >= 3
		while ( day > 366 ) {
			if ( leapyear(year + 1) ) {
				day = day - 366;
			} else {
				day = day - 365;
			}
			year++;
		}
	}

	if (day == 366 && ! leapyear(year)) {
		year++;
		day = 1;
	}

	return  SimDate(day, year);
}



SimDate operator +(int x, SimDate &d1) {
	return ( d1 + x);
}



SimDate operator -(SimDate &d1, int x){

	int day = d1.dayofyear();
	int year = d1.year();
	day = day - x;

	while ( day < 1 ) {
		year--;	
		if ( leapyear(year) ) {
			day = day + 366;
		} else {
			day = day + 365;
		}
	}

	return  SimDate(day, year);
}




void SimDate::operator =(const SimDate &d){
	this -> vday = d.day();
	this -> vyear = d.year();
	this -> vmonth = d.month();
}
