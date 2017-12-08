double doubleFromList(Rcpp::List lst, const char* s);
int intFromList(Rcpp::List lst, const char* s);
Rcpp::DateVector datesFromList(Rcpp::List lst, const char* s);
std::vector<std::vector<double> > matFromList(Rcpp::List lst, const char* s);
std::vector<double> vecFromMat(Rcpp::NumericMatrix m, const char* s);
std::vector<double> doubleFromDF(Rcpp::DataFrame d, const char* s);
Rcpp::DateVector dateFromDF(Rcpp::DataFrame d, const char* s);
bool boolFromList(Rcpp::List lst, const char* s);
std::vector<double> TBFromList(Rcpp::List lst, const char* s);
