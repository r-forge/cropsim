/*
Auhtor: Amandeep Sidhu, 
partly based on code by __________
with contribution by Robert Hijmans

Date: July 2016

License: GNU General Public License (GNU GPL) v. 2 
*/


#include "date.h"
using namespace std;

const int month_array[12]={31,28,31,30,31,30,31,31,30,31,30,31};
const int month_arrayL[12]={31,29,31,30,31,30,31,31,30,31,30,31};


date::date(const int& d, const int& m, const int& y) {
	vday = d;
	vmonth = m;
	vyear = y;
};

//date::date(const string& s) {
// parse("2001-03-07")
	//vday = d;
	//vmonth = m;
	//vyear = y;
//};


///////////////////////////// inline definitions //////////
date::date(){
	vyear = 0;
	vmonth = 0;
	vday = 0;
};

int date::day() const { return vday ; };
int date::month() const { return vmonth ; };
int date::year() const { return vyear ; };



bool date::isLeapYear() const {
	bool leap = false;
	if (vyear % 4 == 0 && ((vyear % 400 == 0) || (vyear % 100 != 0 ))) {
		leap = true;
	}
	return(leap);
}

/*	if(vyear % 4 != 0 ) {
		testleap=false;
	} else if (vyear % 400 == 0)
		testleap = true;
	} else if (vyear % 100 != 0 )
		testleap = true;
	} else if (vyear % 400 == 0) {
		testleap = true;
	} else {
		testleap = false;
	}
*/


int date::dayofyear() const {

	bool leap = isLeapYear();
	//check for leapyear
	//calculate day of year accordingly
	int dayofyear = 0;

	if (leap) {
		for (int i=0; i < vmonth-1; i++) {
			dayofyear = dayofyear + month_arrayL[i];
		}

		dayofyear = dayofyear + vday;
	} else {
		for(int i=0; i < vmonth-1; i++) {
			dayofyear = dayofyear + month_array[i];

		}
		dayofyear = dayofyear+vday;

	}
	return (dayofyear);
};



void date::set_day (const int& day) { date::vday = day; };
void date::set_month(const int& month) { date::vmonth = month; };
void date::set_year (const int& year) { date::vyear = year; };


bool date::valid() const {
// need to still add leapyear conditions
	if (vyear < 0)
		return false;
	if (vmonth > 12 || vmonth < 1)
		return false;
	if (vday > 31 || vday < 1)
		return false;

	if (( vday == 31 && ( vmonth == 2 || vmonth == 4 || vmonth == 6 || vmonth == 9 || vmonth == 11)))
	 	return false;
	if (vday == 30  && vmonth == 2 )
		return false;
	if (vday == 29 && vmonth == 2) {
		if (! isLeapYear()) {
			return false;
		}
	}

	return true;
}



bool operator == (const date& d1,const date& d2){
// check for equality
	if( (d1.day()==d2.day()) && (d1.month()==d2.month()) && (d1.year()==d2.year())) {
		return true;
	};
	return false;

}

bool operator !=(const date& d1, const date& d2){
	return !(d1==d2);
}

inline date next_date(const date& d) {
	date ndat;
	if (!d.valid()) {
		return ndat;
	};

	ndat = date((d.day()+1),d.month(),d.year());

	if (ndat.valid())
		return ndat;

	ndat=date(1,(d.month()+1),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(1,1,(d.year()+1));
		return ndat;
};




inline date previous_date(const date& d){
	date ndat;
	if (!d.valid()) {
		return ndat;
		}; // return zero

	ndat = date((d.day()-1),d.month(),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(31,(d.month()-1),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(30,(d.month()-1),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(29,(d.month()-1),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(28,(d.month()-1),d.year());

	if (ndat.valid())
		return ndat;

	ndat = date(31,12,d.year()-1);
		return ndat;
};


date date::operator ++(int){ // postfix operator date d = *this;
	date d=*this;
	*this = next_date(d);
	return d;
}


date date::operator ++(){
	*this = next_date(*this);
	return *this;
}


date date::operator --(int){ // postfix operator date d = *this;
	date d=*this;
	*this = previous_date(d);
	return d;
}


date date::operator --(){
	*this = previous_date(*this);
	return *this;
}


ostream & operator << (ostream& os, const date& d){
	if (d.valid()) {
		os << " " << d.month() << "/" << d.day() << "/" << d.year() << " " ;

	} else {
		os << " invalid date ";
	};
	return os;
}
