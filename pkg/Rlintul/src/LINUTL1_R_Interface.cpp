#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"  //weather struct
#include "R_interface_util.h"
#include "LINTUL1.h"

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


	Lintul1Model m;
	m.crop = crp;
	m.control = ctr;
	m.wth = wth;
	
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


