#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"
#include "LINTUL2.h"
#include "R_interface_util.h"



// [[Rcpp::export(name = ".lintul2")]]
NumericMatrix lintul2(List crop, DataFrame weather, List soil, List control) {
 
// crop parameters
	struct Lintul2Crop crp;
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
       
	crp.TRANCO = doubleFromList(crop, "TRANCO");
	crp.ROOTDi = doubleFromList(crop, "ROOTDi");
	crp.ROOTDM = doubleFromList(crop, "ROOTDM");
	crp.RRDMAX = doubleFromList(crop, "RRDMAX");
	  
	struct Lintul2Weather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");	
	wth.prec = doubleFromDF(weather, "prec");	
	wth.vapr = doubleFromDF(weather, "vapr");
	wth.wind = doubleFromDF(weather, "wind");	
	DateVector wdate = dateFromDF(weather, "SimDate");
	wth.startdate = SimDate(wdate[0].getDay(), wdate[0].getMonth(), wdate[0].getYear());


	struct Lintul2Soil sol;
	sol.WCi = doubleFromList(soil, "WCi");
	sol.WCAD = doubleFromList(soil, "WCAD");
	sol.WCWP = doubleFromList(soil, "WCWP");
	sol.WCFC = doubleFromList(soil, "WCFC");
	sol.WCWET = doubleFromList(soil, "WCWET");
	sol.WCST = doubleFromList(soil, "WCST");
	sol.DRATE = doubleFromList(soil, "DRATE");
	sol.IRRIGF = doubleFromList(soil, "IRRIGF");
	
	
	DateVector start = datesFromList(control, "start"); 
	DateVector emergence = datesFromList(control, "emergence"); 

	int nsim = start.size();
	int nem = emergence.size();
	if (nem != nsim) {
		stop("start does not have the same length as emergence");
	}
	
	struct Lintul2Control ctr;
	
	//ctr.MaxDur = intFromList(control, "MaxDur");
//	ctr.long_output = boolFromList(control, "long_output"); 

//  Rcpp::Rcout << ctr.long_output << std::endl;

	int nwth = wth.tmin.size();
	
	//for (int s=0; s < nsim; s++) {
	int s = 0;
	if (emergence[s] < wdate[0]) {
		stop("emergence requested before the beginning of the weather data");
	} else if (emergence[s] > wdate[nwth-1]) {
		stop("emergence requested after the end of the weather data");
	} else if (emergence[s] < start[s]) {
		stop("emergence requested before the start of simulation");	
	}
		

		
	ctr.emergence = { int(emergence[s] - wdate[0]) };
	ctr.start = { int(start[s] - wdate[0]) };
	
	
	Lintul2Model m(crp, sol, ctr, wth);
	
	m.model_run();

	int nr = m.out.size();
	int nc = m.out[0].size();
	NumericMatrix mat(nr, nc);
	for (int i = 0; i < nr; i++) {
		for (int j = 0; j < nc; j++) {
			mat(i, j) = m.out[i][j];  
		}
	}
	colnames(mat) = CharacterVector::create("step", "Tsum", "LAI", "WLV", "WST", "WRT", "WSO", "EVAP", "TRAN", "TRANRF", "WA", "WC",  "RWA", "PREC");
	return(mat);
}
