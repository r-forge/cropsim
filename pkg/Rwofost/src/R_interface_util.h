double doubleFromList(List lst, const char* s);
int intFromList(List lst, const char* s);
int OptionalintFromList(List lst, const char* s);
DateVector datesFromList(List lst, const char* s);
std::vector<std::vector<double> > matFromList(List lst, const char* s);
std::vector<double> vecFromMat(NumericMatrix m, const char* s);
std::vector<double> doubleFromDF(DataFrame d, const char* s);
DateVector dateFromDF(DataFrame d, const char* s);
bool boolFromList(List lst, const char* s);

std::vector<double> TBFromList(List lst, const char* s);
std::vector<double> vecFromList(List lst, const char* s);
