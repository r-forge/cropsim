#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include "R_interface_util.h"
#include "LINTUL1.h"

/*
void setWeather(Lintul1Model* m, DataFrame w) {
	Lintul1Weather wth;
	wth.tmin = doubleFromDF(w, "tmin");
	wth.tmax = doubleFromDF(w, "tmax");
	wth.srad = doubleFromDF(w, "srad");	
	DateVector wdate = dateFromDF(w, "date");
	wth.date.resize(wdate.size());
	for (int i = 0; i < wdate.size(); i++) {
		wth.date[i] = SimDate(wdate[i].getYear(), wdate[i].getMonth(),  wdate[i].getDay());
	}
//	wth.longitude = location[0]; 
//	wth.latitude  = location[1];
//	wth.elevation = location[2];
	m->wth = wth;
}
*/

RCPP_EXPOSED_CLASS(LintulWeather)

RCPP_EXPOSED_CLASS(Lintul1Crop)
RCPP_EXPOSED_CLASS(Lintul1Control)
RCPP_EXPOSED_CLASS(Lintul1Model)
RCPP_EXPOSED_CLASS(Lintul1Output)
	

RCPP_MODULE(LINTUL){
    using namespace Rcpp;

    class_<Lintul1Crop>("Lintul1Crop")
		.field("LAIi", &Lintul1Crop::LAIi) 
		.field("SLA", &Lintul1Crop::SLA) 
		.field("Tbase", &Lintul1Crop::Tbase) 
		.field("RGRL", &Lintul1Crop::RGRL) 
		.field("Tsum1", &Lintul1Crop::Tsum1) 
		.field("Tsum2", &Lintul1Crop::Tsum2) 
		.field("LAIcr", &Lintul1Crop::LAIcr) 
		.field("RDRSHM", &Lintul1Crop::RDRSHM) 
		.field("RUE", &Lintul1Crop::RUE) 
		.field("K", &Lintul1Crop::K) 
		.field("RDRT", &Lintul1Crop::RDRT)   
		.field("FRTTB", &Lintul1Crop::FRTTB)  
		.field("FLVTB", &Lintul1Crop::FLVTB)  
		.field("FSTTB", &Lintul1Crop::FSTTB)  
		.field("FSOTB", &Lintul1Crop::FSOTB)  
	;
	
    class_<Lintul1Control>("Lintul1Control")
		.field("emergence", &Lintul1Control::emergence) 
		.field("maxdur", &Lintul1Control::maxdur) 
	;
	
    class_<LintulWeather>("Lintul1Weather")
//		.field("longitude", &Lintul1Weather::longitude) 
//		.field("latitude", &Lintul1Weather::latitude) 
//		.field("elevation", &Lintul1Weather::elevation) 
		.field("CO2",  &LintulWeather::CO2) 
		.field("date", &LintulWeather::date) 
		.field("srad", &LintulWeather::srad) 
		.field("tmin", &LintulWeather::tmin) 
		.field("tmax", &LintulWeather::tmax) 
	;
	
    class_<Lintul1Model>("Lintul1Model")
	    //.constructor<Lintul1Crop, Lintul1Control, LintulWeather>()
		.constructor()
		.method("run", &Lintul1Model::model_run, "run the model")		
		//.method("setWeather", &setWeather, "set the weather") 

		.field("crop", &Lintul1Model::crop, "crop")
		.field("control", &Lintul1Model::control, "crop")
		.field("out", &Lintul1Model::out, "crop")
		.field("weather", &Lintul1Model::wth, "weather")
	;			

    class_<Lintul1Output>("Lintul1Output")
		.field_readonly("step", &Lintul1Output::step)
		.field_readonly("TSUM", &Lintul1Output::TSUM)
		.field_readonly("DLV", &Lintul1Output::DLV)
		.field_readonly("LAI", &Lintul1Output::LAI)
		.field_readonly("WLV", &Lintul1Output::WLV)
		.field_readonly("WLVD", &Lintul1Output::WLVD)
		.field_readonly("WLVG", &Lintul1Output::WLVG)
		.field_readonly("WST", &Lintul1Output::WST)
		.field_readonly("WRT", &Lintul1Output::WRT)
		.field_readonly("WSO", &Lintul1Output::WSO)
	;
	
};

	


