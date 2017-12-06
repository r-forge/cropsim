/*
Auhtor: Amandeep Sidhu, 
partly based on code by __________
with contribution by Robert Hijmans

Date: July 2016

License: GNU General Public License (GNU GPL) v. 2 
*/


#include <iostream> 
using namespace std;


class date { 
protected:
	int vyear;
	int vmonth;
	int vday;

public:
	date();
	date(const int& d, const int& m, const int& y);

	bool valid(void) const;

	int day() const;
	int month() const;
	int year() const;
	int dayofyear() const;
	bool isLeapYear() const;

	void set_day (const int& day );
	void set_month (const int& month ); 
	void set_year (const int& year );

	date operator ++(); // prefix 
	date operator ++(int); // postfix 
	date operator --(); // prefix 
	date operator --(int); // postfix
};

bool operator == (const date&, const date&); // comparison operators bool operator != (const date&, const date&);
bool operator < (const date&, const date&);
bool operator > (const date&, const date&);
bool operator <= (const date&, const date&); 
bool operator >= (const date&, const date&);
ostream& operator << ( ostream& os, const date& d); // output operator 

