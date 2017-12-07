#include <Rcpp.h>
#include "LINTUL1.h"

using namespace Rcpp;


RCPP_EXPOSED_CLASS(Lintul1Crop)
RCPP_EXPOSED_CLASS(Lintul1Control)
RCPP_EXPOSED_CLASS(Lintul1Weather)
RCPP_EXPOSED_CLASS(Lintul1Model)
RCPP_EXPOSED_CLASS(Lintul1Output)
RCPP_EXPOSED_CLASS(SimDate)
	

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
		.field("maxstep", &Lintul1Control::maxstep) 
	;
	
    class_<Lintul1Weather>("Lintul1Weather")
		.field("longitude", &Lintul1Weather::longitude) 
		.field("latitude", &Lintul1Weather::latitude) 
		.field("elevation", &Lintul1Weather::elevation) 
		.field("CO2", &Lintul1Weather::CO2) 
		//.field("date", &Lintul1Weather::date) 
		.field("srad", &Lintul1Weather::srad) 
		.field("tmin", &Lintul1Weather::tmin) 
		.field("tmax", &Lintul1Weather::tmax) 
	;
	
    class_<Lintul1Model>("Lintul1Model")
	    //.constructor<Lintul1Crop, Lintul1Control, Lintul1Weather>()
		.constructor()
		.method("run", &Lintul1Model::model_run, "run the model")		
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

	


