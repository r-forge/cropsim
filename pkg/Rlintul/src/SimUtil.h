#include <algorithm>


unsigned doy_from_days(long z);

double clamp(double min, double max, double v);
double approx(std::vector<double> xy, double x);
double approx(std::vector<std::vector<double> > xy, double x);
double LINT(std::vector<std::vector<double> > xy, double x);

std::vector<std::vector<double> > matrix(int nrow, int ncol);

double INSW(double x, double y1, double y2);
int REAAND(double x1, double x2);
double NOTNUL(double x);

template <class T> T minvalue(std::vector<T> v) {
  return *std::min_element(v.begin(),v.end());  
}

template <class T> T maxvalue(std::vector<T> v) {
  return *std::max_element(v.begin(),v.end());  
}
