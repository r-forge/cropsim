/*
Author Robert Hijmans
Date: May 2016

License: GNU General Public License (GNU GPL) v. 2 
*/

#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include <string>


/*template< typename T, size_t N >
std::vector<T> makeVector( const T (&data)[N] ) {
  return std::vector<T>(data, data+N);
}*/



std::vector<double> doubleFromDF(DataFrame d, const char* s) {
	CharacterVector nms = d.names();
	for (int i=0; i < nms.size(); i++) {
		if (nms[i] == s) {
			std::vector<double> v = d[i];
			return(v);
		}     
	}
    std::string ss = "Variable '" +  std::string(s) + "' not found";
    stop(ss);  
	// to avoid "warning: control reaches end of non-void function"
	std::vector<double> v(1);
	return( v );
}



DateVector dateFromDF(DataFrame d, const char* s) {
  
//	int nrow = d.nrows();
	CharacterVector nms = d.names();
	for (int i=0; i < nms.size(); i++) {
		if (nms[i] == s) {
			DateVector v = d[i];
			return(v);
		}     
	}
    std::string ss = "Variable '" +  std::string(s) + "' not found";
    stop(ss);
	// to avoid "warning: control reaches end of non-void function"
	DateVector v(1);
	return( v );
}

/*
Weather YMD(Weather w, std::vector<Date> d) {
    int nrow = d.size();
    w.year.resize(nrow);
    w.month.resize(nrow);
    w.day.resize(nrow);	
    w.doy.resize(nrow);	
    for (int i = 0; i < nrow; ++i) {
      w.year[i] = d[i].getYear();
      w.month[i] = d[i].getMonth();
      w.day[i] = d[i].getDay();
      w.doy[i] = d[i].getYearday();
    }    
	return(w);
} 
*/


std::vector<double> vecFromMat(NumericMatrix m, const char* s) {
  
 	CharacterVector nms = colnames(m);

	for (int j=0; j < nms.size(); j++) {
		if (nms[j] == s) {
			int nrow = m.nrow();
			std::vector<double> v(nrow);
			for (int i = 0; i < nrow; i++) {
				v[i] = m(i,j);
			} 
			return(v);
		}  
	}
	std::string ss = "Variable '" +  std::string(s) + "' not found";
	stop(ss);
	// to avoid "warning: control reaches end of non-void function"
	std::vector<double> v(1);
	return( v );
	
}


double doubleFromList(List lst, const char* s) {
	if (!lst.containsElementNamed(s) ) {
		std::string ss = "parameter '" +  std::string(s) + "' not found";
		stop(ss);
	}
// todo: check if this is a single number ?
	double v = lst[s];
	return(v);
}

int intFromList(List lst, const char* s) {
	if (!lst.containsElementNamed(s) ) {
		std::string ss = "parameter '" +  std::string(s) + "' not found";
		stop(ss);
	}
// todo: check if this is a single number ?
	int v = lst[s];
	return(v);
}


bool boolFromList(List lst, const char* s) {
	if (!lst.containsElementNamed(s) ) {
		std::string ss = "parameter '" +  std::string(s) + "' not found";
		stop(ss);
	}
// todo: check if this is a single number ?
	bool v = lst[s];
	return(v);
}


DateVector datesFromList(List lst, const char* s) {
  if (!lst.containsElementNamed(s)) {
    // todo: check if this is a single number
    std::string ss = "parameter '" +  std::string(s) + "' not found";
    stop(ss);
  } 
  DateVector v = lst[s];
  return(v);
}


std::vector<double> vecFromList(List lst, const char* s) {
	
	if (! lst.containsElementNamed(s)) {
		std::string ss = "parameter matrix '" +  std::string(s) + "' not found";
		stop(ss);
	}
	
// todo: check if this is a matrix
	NumericVector x = lst[s];
	std::vector<double> v(x.size());
	for (int i=0; i < x.size(); i++) {
		v[i] = x[i];
	}
	return(v);
}



std::vector<std::vector<double> > matFromList(List lst, const char* s) {
	
	if (! lst.containsElementNamed(s)) {
		std::string ss = "parameter matrix '" +  std::string(s) + "' not found";
		stop(ss);
	}
	
// todo: check if this is a matrix
	NumericMatrix x = lst[s];
	int nrow = x.nrow();
	std::vector<std::vector<double> > m(nrow, std::vector<double>(2));
	for (int i=0; i < nrow; i++) {
		m[i][0] = x(i,0);
		m[i][1] = x(i,1);
	}
	return(m);
}


std::vector<double> TBFromList(List lst, const char* s){
	if(! lst.containsElementNamed(s)){
		std::string ss = "parameter matrix '" +  std::string(s) + "' not found";
		stop(ss);
	}

	NumericMatrix x = lst[s];
	if(x.ncol() != 2){
		std::string ss2 = "ncol != 2";
		stop(ss2);
	}
	int nrow = x.nrow();
	std::vector<double> result;
	for(int i = 0; i < nrow; i++){
		result.push_back( x(i, 0) );
		result.push_back( x(i, 1) );
	}
	return result;
}
