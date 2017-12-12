/*
Author Robert Hijmans
Date: May 2016
License: GNU General Public License (GNU GPL) v. 2 
*/

#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include "R_interface_util.h"
#include "WOFOST.h"


void setWeather(WofostModel* m, NumericVector date, NumericVector tmin, NumericVector tmax, NumericVector srad, NumericVector prec, NumericVector wind, NumericVector vapr, double latitude) {
	DailyWeather wth;
	wth.tmin = Rcpp::as<std::vector<double>>(tmin);
	wth.tmax = Rcpp::as<std::vector<double>>(tmax);
	wth.srad = Rcpp::as<std::vector<double>>(srad);
	wth.wind = Rcpp::as<std::vector<double>>(wind);
	wth.vapr = Rcpp::as<std::vector<double>>(vapr);
	wth.prec = Rcpp::as<std::vector<double>>(prec);
	wth.date = Rcpp::as<std::vector<long>>(date);
	wth.latitude  = latitude;
//	wth.elevation = location[2];
	m->wth = wth;
}




RCPP_EXPOSED_CLASS(DailyWeather)

RCPP_EXPOSED_CLASS(WofostCrop)
RCPP_EXPOSED_CLASS(WofostCropParameters);

RCPP_EXPOSED_CLASS(WofostSoil)
RCPP_EXPOSED_CLASS(WofostSoilParameters);

RCPP_EXPOSED_CLASS(WofostControl)
RCPP_EXPOSED_CLASS(WofostModel)
RCPP_EXPOSED_CLASS(WofostOutput)


RCPP_MODULE(wofost){
    using namespace Rcpp;

    class_<WofostControl>("WofostControl")
		.field("modelstart", &WofostControl::modelstart) 
	;

    class_<DailyWeather>("DailyWeather")
		.field("latitude", &DailyWeather::latitude) 
		.field("CO2",  &DailyWeather::CO2) 
		.field("date", &DailyWeather::date) 
		.field("srad", &DailyWeather::srad) 
		.field("tmin", &DailyWeather::tmin) 
		.field("tmax", &DailyWeather::tmax) 
		.field("prec", &DailyWeather::prec) 
		.field("wind", &DailyWeather::wind) 
		.field("vapr", &DailyWeather::vapr) 
	;
	
    class_<WofostCropParameters>("WofostCropParameters")
		.field("par", &WofostCropParameters::TCNT)
	;


    class_<WofostSoilParameters>("WofostSoilParameters")
		.field("BG_N_SUPPLY", &WofostSoilParameters::BG_N_SUPPLY)
	;

	
	
    class_<WofostCrop>("WofostCrop")
		.field("par", &WofostCrop::par, "crop parameters")
	;
	
    class_<WofostSoil>("WofostSoil")
		.field("par", &WofostSoil::par, "soil parameters")
	;
	
    class_<WofostModel>("WofostModel")
		.constructor()
		.method("run", &WofostModel::model_run, "run the model")		
		.method("setWeather", &setWeather)
		.field("crop", &WofostModel::crop, "crop")
		.field("soil", &WofostModel::soil, "soil")
		.field("control", &WofostModel::control, "control")
		.field("out", &WofostModel::out, "out")
		.field("weather", &WofostModel::wth, "weather")
		
	;			

 /*   class_<WofostOutput>("WofostOutput")
		.field_readonly("LAI", &WofostOutput::LAI)
		.field_readonly("WLV", &WofostOutput::WLV)
		.field_readonly("WST", &WofostOutput::WST)
		.field_readonly("WRT", &WofostOutput::WRT)
		.field_readonly("WSO", &WofostOutput::WSO)
	;
*/	
};

	


