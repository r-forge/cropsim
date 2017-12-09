#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"  //weather struct
#include "LINTUL0.h"
#include "R_interface_util.h"



// [[Rcpp::export]]
NumericMatrix lintul0(List crop, DataFrame weather, List control) {
  
// crop parameters
	Lintul0Crop crp;
	crp.F0 = doubleFromList(crop, "F0");  
	crp.maxGC = doubleFromList(crop, "maxGC");
	crp.R0 = doubleFromList(crop, "R0"); 
	crp.TT50  = doubleFromList(crop, "TT50");  
	crp.d50 = doubleFromList(crop, "d50");  
	crp.RUE = doubleFromList(crop, "RUE");  
	crp.TTst1 = doubleFromList(crop, "TTst1");  
	crp.TTst2 = doubleFromList(crop, "TTst2"); 
	crp.Tbase = doubleFromList(crop, "Tbase"); 
	crp.coldtmp1 = doubleFromList(crop, "coldtmp1"); 
	crp.coldtmp2 = doubleFromList(crop, "coldtmp2"); 
	crp.coldtmp3 = doubleFromList(crop, "coldtmp3"); 
	crp.cthi1 = doubleFromList(crop, "cthi1"); 
	crp.cthi2 = doubleFromList(crop, "cthi2"); 
       
	LintulWeather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");	
	DateVector wdate = dateFromDF(weather, "date");
//	wth.startdate = SimDate(wdate[0].getDay(), wdate[0].getMonth(), wdate[0].getYear());

	struct LintulControl ctr;
	ctr.emergence = intFromList(control, "emergence"); 
	ctr.maxdur = intFromList(control, "maxdur");

	//	ctr.long_output = boolFromList(control, "long_output"); 
	
		
/*	if (emergence[s] < wdate[0]) {
			stop("emergence requested before the beginning of the weather data");
		} else if (emergence[s] > wdate[nwth-1]) {
			stop("emergence requested after the end of the weather data");
		}
	
		ctr.emergence = { (int)(emergence[s] - wdate[0]) };
	}
*/

	Lintul0Model m;
	m.crop=crp;
	m.control= ctr;
	m.wth=wth;
	
 	m.model_run();
	
	size_t nr = m.out.step.size();
	NumericMatrix out(nr, 5) ;
	for( size_t i=1; i<nr; i++){
		out(i,0) = m.out.step[i];
		out(i,1) = m.out.TSUM[i];
		out(i,2) = m.out.GC[i];
		out(i,3) = m.out.W[i];
		out(i,4) = m.out.WSO[i];	
	}
	colnames(out) = CharacterVector::create("step", "Tsum", "GC", "W", "WSO");		
	
	return(out);
}



