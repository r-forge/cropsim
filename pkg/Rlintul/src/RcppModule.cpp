#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include "R_interface_util.h"
#include "LINTUL1.h"


RCPP_EXPOSED_CLASS(LintulWeather)
RCPP_EXPOSED_CLASS(LintulControl)

RCPP_EXPOSED_CLASS(Lintul1Crop)
RCPP_EXPOSED_CLASS(Lintul1Model)
RCPP_EXPOSED_CLASS(Lintul1Output)

RCPP_EXPOSED_CLASS(Lintul2Crop)
RCPP_EXPOSED_CLASS(Lintul2Model)
RCPP_EXPOSED_CLASS(Lintul2Output)


RCPP_MODULE(LINTUL2){
    using namespace Rcpp;

    class_<LintulControl>("LintulControl")
		.field("emergence", &LintulControl::emergence) 
		.field("maxdur", &LintulControl::maxdur) 
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
}

	

RCPP_MODULE(LINTUL1){
    using namespace Rcpp;

    class_<LintulControl>("LintulControl")
		.field("emergence", &LintulControl::emergence) 
		.field("maxdur", &LintulControl::maxdur) 
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

		
    class_<Lintul1Model>("Lintul1Model")
	    //.constructor<Lintul1Crop, LintulControl, LintulWeather>()
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

	


