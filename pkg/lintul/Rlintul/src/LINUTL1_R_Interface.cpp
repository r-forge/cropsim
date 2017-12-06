#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"  //weather struct
#include "R_interface_util.h"
#include "LINTUL1.h"

/*

NumericMatrix runLintul1(Lintul1Model m) {
 	m.model_run();
	int nr = m.out.size();
	int nc = m.out[0].size();
	NumericMatrix mat(nr, nc);
	for (int i = 0; i < nr; i++) {
		for (int j = 0; j < nc; j++) {
			mat(i, j) = m.out[i][j];  
		}
	}
	colnames(mat) = CharacterVector::create("step", "Tsum", "LAI", "WLV", "WST", "WRT", "WSO");		
	return(mat);
} 

std::vector<std::vector<double> > vecToMat(std::vector<double> v) {
	int nr = v.size() / 2;
	std::vector<std::vector<double> > m (nr, std::vector<double>(2));
	int j = 0;
	for (int i=0; i<nr; i++) {
		m[i][0] = v[j];
		m[i][1] = v[j+1];
		j = j + 2;		
	}
	return(m);
}   

void Lintul1Crop::setRDRT(std::vector<double> x) { RDRT = vecToMat(x); }
void Lintul1Crop::setFRTTB (std::vector<double> x) { FRTTB = vecToMat(x); }
void Lintul1Crop::setFLVTB (std::vector<double> x) { FLVTB = vecToMat(x); }
void Lintul1Crop::setFSTTB (std::vector<double> x) { FSTTB = vecToMat(x); }
void Lintul1Crop::setFSOTB (std::vector<double> x) { FSOTB = vecToMat(x); }


RCPP_EXPOSED_CLASS(Lintul1Crop)
RCPP_EXPOSED_CLASS(Lintul1Control)
RCPP_EXPOSED_CLASS(Weather)
RCPP_EXPOSED_CLASS(Lintul1Model)

RCPP_MODULE(Rintul1_Module){
    using namespace Rcpp ;

    class_<Lintul1Crop>("Lintul1Crop")
      .constructor()
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
      
      .method("setRDRT", &Lintul1Crop::setRDRT , "RDRT vector")
      .method("setFRTTB", &Lintul1Crop::setFRTTB , "FRTTB vector")
      .method("setFLVTB", &Lintul1Crop::setFLVTB , "FLVTB vector")
      .method("setFSTTB", &Lintul1Crop::setFSTTB , "FSTTB vector")
      .method("setFSOTB", &Lintul1Crop::setFSOTB , "FSOTB vector")

	;	

    class_<Lintul1Control>("Lintul1Control")
      .constructor()
      .field("emergence", &Lintul1Control::emergence, "emergence")
      .field("long_output", &Lintul1Control::long_output, "output type")
	;

    class_<Weather>("Weather")
      .constructor()
      .field("srad", &Weather::srad)
      .field("tmin", &Weather::tmin)
      .field("tmax", &Weather::tmax)
    ;

    class_<Lintul1Model>("Lintul1Model")
      .constructor<Lintul1Crop, Lintul1Control, Weather>()
      .method("run", &Lintul1Model::model_run , "run the model")
	  .field("out", &Lintul1Model::out)
	;
	
	function("runLintul1", &runLintul1);	
}

*/





// [[Rcpp::export]]
NumericMatrix lintul1(List crop, DataFrame weather, List control) {
  
// crop parameters
	Lintul1Crop crp;
	crp.LAIi = doubleFromList(crop, "LAIi"); 
	crp.SLA = doubleFromList(crop, "SLA"); 
	crp.Tbase = doubleFromList(crop, "Tbase"); 
	crp.RGRL  = doubleFromList(crop, "RGRL");  
	crp.Tsum1 = doubleFromList(crop, "Tsum1");  
	crp.Tsum2 = doubleFromList(crop, "Tsum2");  
	crp.LAIcr = doubleFromList(crop, "LAIcr");  
	crp.RDRSHM = doubleFromList(crop, "RDRSHM"); 
	crp.RUE = doubleFromList(crop, "RUE");  
	crp.K = doubleFromList(crop, "K"); 
	 
	crp.RDRT = matFromList(crop, "RDRT");
	crp.FRTTB = matFromList(crop, "FRTTB");
	crp.FLVTB = matFromList(crop, "FLVTB");
	crp.FSTTB = matFromList(crop, "FSTTB");
	crp.FSOTB = matFromList(crop, "FSOTB");
       
	Lintul1Weather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");	
	int nwth = weather.nrows();
	DateVector wdate = dateFromDF(weather, "date");
	wth.startdate = date(wdate[0].getDay(), wdate[0].getMonth(), wdate[0].getYear());
	
	DateVector emergence = datesFromList(control, "emergence"); 
	
	//ctr.MaxDur = intFromList(control, "MaxDur");
	struct Lintul1Control ctr;
//	ctr.long_output = boolFromList(control, "long_output"); 

//	int nsim = emergence.size();
	
//	for (int s=0; s < nsim; s++) {

	int s=0;		
	if (emergence[s] < wdate[0]) {
		stop("emergence requested before the beginning of the weather data");
	} else if (emergence[s] > wdate[nwth-1]) {
		stop("emergence requested after the end of the weather data");
	}
	
	ctr.emergence = { int(emergence[s] - wdate[0]) };


	Lintul1Model m(crp, ctr, wth);
	m.model_run();
	
	int r = m.out.size();
	int c = m.out[0].size();
	
	NumericMatrix mat(r, c);
	for (int i = 0; i < r; i++) {
		for (int j = 0; j < c; j++) {
			mat(i, j) = m.out[i][j];  
		}
	}
	
	colnames(mat) = CharacterVector::create("step", "Tsum", "LAI", "WLV", "WST", "WRT", "WSO");		
	return(mat);
}



