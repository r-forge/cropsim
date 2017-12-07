/*
Auhtor: Amandeep Sidhu,
partly based on code by __________
with contribution by Robert Hijmans

Date: July 2016
License: GNU General Public License (GNU GPL) v. 2
*/

#ifndef SIMDATE_H
#define SIMDATE_H
#include <iostream>
using namespace std;

class SimDate {
  protected:
    int vyear;
    int vmonth;
    int vday;

  public:
    SimDate();
    SimDate(const int& year, const int& month, const int& day);
    SimDate(int doy, int year);
    SimDate(const string& s);

    bool valid(void) const;

    int day() const;
    int month() const;
    int year() const;
    int dayofyear();
    bool is_leap_year() const;

    void set_day (const int& day );
    void set_month (const int& month );
    void set_year (const int& year );

    SimDate operator ++(); // prefix
    SimDate operator ++(int); // postfix
    SimDate operator --(); // prefix
    SimDate operator --(int); // postfix
    void operator =( const SimDate&);
};

SimDate operator +(SimDate&, int);
SimDate operator +(int, SimDate&);
SimDate operator -(SimDate&, int);
bool operator == (const SimDate&, const SimDate&); // comparison operators
bool operator != (const SimDate&, const SimDate&);
bool operator < (const SimDate&, const SimDate&);
bool operator > (const SimDate&, const SimDate&);
bool operator <= (const SimDate&, const SimDate&);
bool operator >= (const SimDate&, const SimDate&);
ostream& operator << ( ostream& os, const SimDate& d); // output operator
int operator-( SimDate&, SimDate&);

#endif

