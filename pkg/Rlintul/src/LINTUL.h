

struct LintulControl {
  long start, emergence;
  unsigned maxdur = 365;
}; 


struct LintulWeather {
	double longitude, latitude, elevation, DAYLP;
	double CO2 = 400;
	long startdate;
	std::vector<double> srad, tmin, tmax, prec, wind, vapr;
	std::vector<long> date;
};




