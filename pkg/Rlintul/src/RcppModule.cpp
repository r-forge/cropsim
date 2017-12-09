/*
Author Robert Hijmans
Date: May 2016
License: GNU General Public License (GNU GPL) v. 2 
*/


#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include "R_interface_util.h"
#include "LINTUL1.h"
#include "LINTUL2.h"


RCPP_EXPOSED_CLASS(LintulWeather)
RCPP_EXPOSED_CLASS(LintulControl)

RCPP_EXPOSED_CLASS(Lintul1Crop)
RCPP_EXPOSED_CLASS(Lintul1Model)
RCPP_EXPOSED_CLASS(Lintul1Output)

RCPP_EXPOSED_CLASS(Lintul2Crop)
RCPP_EXPOSED_CLASS(Lintul2Soil)
RCPP_EXPOSED_CLASS(Lintul2Model)
RCPP_EXPOSED_CLASS(Lintul2Output)


RCPP_MODULE(LINTUL2){
    using namespace Rcpp;

    class_<LintulControl>("LintulControl")
		.field("start", &LintulControl::start) 
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
		.field("prec", &LintulWeather::prec) 
		.field("wind", &LintulWeather::wind) 
		.field("vapr", &LintulWeather::vapr) 
	;
	
    class_<Lintul2Crop>("Lintul2Crop")
		.field("LAIi",   &Lintul2Crop::LAIi) 
		.field("SLA",    &Lintul2Crop::SLA) 
		.field("Tbase",  &Lintul2Crop::Tbase) 
		.field("RGRL",   &Lintul2Crop::RGRL) 
		.field("Tsum1",  &Lintul2Crop::Tsum1) 
		.field("Tsum2",  &Lintul2Crop::Tsum2) 
		.field("LAIcr",  &Lintul2Crop::LAIcr) 
		.field("RDRSHM", &Lintul2Crop::RDRSHM) 
		.field("RUE",    &Lintul2Crop::RUE) 
		.field("K",      &Lintul2Crop::K) 
		.field("RDRT",   &Lintul2Crop::RDRT)   
		.field("FRTTB",  &Lintul2Crop::FRTTB)  
		.field("FLVTB",  &Lintul2Crop::FLVTB)  
		.field("FSTTB",  &Lintul2Crop::FSTTB)  
		.field("FSOTB",  &Lintul2Crop::FSOTB)  
		.field("ROOTDi", &Lintul2Crop::ROOTDi)  
		.field("ROOTDM", &Lintul2Crop::ROOTDM)  
		.field("RRDMAX", &Lintul2Crop::RRDMAX)  
		.field("TRANCO", &Lintul2Crop::TRANCO)  
	;

    class_<Lintul2Soil>("Lintul2Soil")
		.field("WCi", &Lintul2Soil::WCi)  
		.field("WCAD", &Lintul2Soil::WCAD)  
		.field("WCWP", &Lintul2Soil::WCWP)  
		.field("WCFC", &Lintul2Soil::WCFC)  
		.field("WCWET", &Lintul2Soil::WCWET)  
		.field("WCST", &Lintul2Soil::WCST)  
		.field("DRATE", &Lintul2Soil::DRATE)  
		.field("IRRIGF", &Lintul2Soil::IRRIGF)  
	;
		
    class_<Lintul2Model>("Lintul2Model")
		.constructor()
		.method("run", &Lintul2Model::model_run, "run the model")		
		.field("crop", &Lintul2Model::crop, "crop")
		.field("soil", &Lintul2Model::soil, "soil")
		.field("control", &Lintul2Model::control, "control")
		.field("out", &Lintul2Model::out, "out")
		.field("weather", &Lintul2Model::wth, "weather")
	;			

    class_<Lintul2Output>("Lintul2Output")
		.field_readonly("step", &Lintul2Output::step)
		.field_readonly("TSUM", &Lintul2Output::TSUM)
		.field_readonly("DLV", &Lintul2Output::DLV)
		.field_readonly("LAI", &Lintul2Output::LAI)
		.field_readonly("WLV", &Lintul2Output::WLV)
		.field_readonly("WLVD", &Lintul2Output::WLVD)
		.field_readonly("WLVG", &Lintul2Output::WLVG)
		.field_readonly("WST", &Lintul2Output::WST)
		.field_readonly("WRT", &Lintul2Output::WRT)
		.field_readonly("WSO", &Lintul2Output::WSO)
		.field_readonly("EVAP", &Lintul2Output::EVAP)
		.field_readonly("TRAN", &Lintul2Output::TRAN)
		.field_readonly("TRANRF", &Lintul2Output::TRANRF)
		.field_readonly("WA", &Lintul2Output::WA)
		.field_readonly("WC", &Lintul2Output::WC)
		.field_readonly("RWA", &Lintul2Output::RWA)
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
		.constructor()
		.method("run", &Lintul1Model::model_run, "run the model")		
		.field("crop", &Lintul1Model::crop, "crop")
		.field("control", &Lintul1Model::control, "control")
		.field("out", &Lintul1Model::out, "out")
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

	


