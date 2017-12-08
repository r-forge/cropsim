#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"  //weather struct
#include "R_interface_util.h"
#include "LINTUL1.h"


// [[Rcpp::export(name = ".lintul1")]]
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
	 
	crp.RDRT = TBFromList(crop, "RDRT");
	crp.FRTTB = TBFromList(crop, "FRTTB");
	crp.FLVTB = TBFromList(crop, "FLVTB");
	crp.FSTTB = TBFromList(crop, "FSTTB");
	crp.FSOTB = TBFromList(crop, "FSOTB");
       
	Lintul1Weather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");	
	int nwth = weather.nrows();
	DateVector wdate = dateFromDF(weather, "date");
//	wth.startdate = SimDate(wdate[0].getDay(), wdate[0].getMonth(), wdate[0].getYear());
	
	DateVector emergence = datesFromList(control, "emergence"); 

	struct Lintul1Control ctr;
	ctr.maxdur = intFromList(control, "maxdur");
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
	
	std::vector<std::vector<double>> mat(7, vector<double>(0));
	
	size_t nr = m.out.step.size();
	NumericMatrix out(nr, 10) ;
	for( size_t i=1; i<nr; i++){
		out(i,0) = m.out.step[i];
		out(i,1) = m.out.TSUM[i];
		out(i,2) = m.out.DLV[i];
		out(i,3) = m.out.LAI[i];
		out(i,4) = m.out.WLVG[i];
		out(i,5) = m.out.WLVD[i];
		out(i,6) = m.out.WLV[i];
		out(i,7) = m.out.WST[i];
		out(i,8) = m.out.WRT[i];
		out(i,9) = m.out.WSO[i];	
	}
	colnames(out) = CharacterVector::create("step", "Tsum", "DLV", "LAI", "WLVG", "WLVD", "WLV", "WST", "WRT", "WSO");		
	return out;

	
}



