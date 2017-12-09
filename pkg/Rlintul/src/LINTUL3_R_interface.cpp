#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"
#include "LINTUL3.h"
#include "R_interface_util.h"


// [[Rcpp::export(name = ".lintul3")]]
NumericMatrix lintul3(List crop, DataFrame weather, List soil, List control) {
 
// crop parameters
	struct Lintul3Crop crp;
      
	crp.IDSL = intFromList(crop, "IDSL"); 
	crp.TSUM1 = doubleFromList(crop, "TSUM1"); 
	crp.TSUM2 = doubleFromList(crop, "TSUM2"); 
	crp.DVSI = doubleFromList(crop, "DVSI"); 
	crp.DVSEND = doubleFromList(crop, "DVSEND"); 
	crp.TDWI = doubleFromList(crop, "TDWI"); 
	crp.RGRLAI = doubleFromList(crop, "RGRLAI"); 
	crp.SPA = doubleFromList(crop, "SPA"); 
	crp.DTSMTB = matFromList(crop, "DTSMTB");
	crp.SLATB = matFromList(crop, "SLATB");
	crp.SSATB = matFromList(crop, "SSATB");
	crp.TBASE = doubleFromList(crop, "TBASE"); 
	crp.KDIFTB = matFromList(crop, "KDIFTB");
	crp.RUETB = matFromList(crop, "RUETB");
	crp.TMPFTB = matFromList(crop, "TMPFTB");
	crp.KDIFTB = matFromList(crop, "KDIFTB");
	crp.RUETB = matFromList(crop, "RUETB");
	crp.TMPFTB = matFromList(crop, "TMPFTB");
	crp.TMNFTB = matFromList(crop, "TMNFTB");
	crp.COTB = matFromList(crop, "COTB");
	crp.FRTB = matFromList(crop, "FRTB");
	crp.FLTB = matFromList(crop, "FLTB");
	crp.FSTB = matFromList(crop, "FSTB");
	crp.FOTB = matFromList(crop, "FOTB");
	crp.RDRL = doubleFromList(crop, "RDRL"); 
	crp.RDRLTB = matFromList(crop, "RDRLTB");
	crp.RDRSHM = doubleFromList(crop, "RDRSHM"); 
	crp.RDRNS = doubleFromList(crop, "RDRNS"); 
	crp.RDRRTB = matFromList(crop, "RDRRTB");
	crp.RDRSTB = matFromList(crop, "RDRSTB");
	crp.CFET = doubleFromList(crop, "CFET");
	crp.DEPNR = doubleFromList(crop, "DEPNR");
	crp.RDSINT  = intFromList(crop, "IAIRDU");
	crp.RDI = doubleFromList(crop, "RDI");
	crp.RRI = doubleFromList(crop, "RRI");
	crp.RDMCR = doubleFromList(crop, "RDMCR");
	crp.DVSDR = doubleFromList(crop, "DVSDR");
	crp.DVSDLT = doubleFromList(crop, "DVSDLT");
	crp.DVSNLT = doubleFromList(crop, "DVSNLT");
	crp.DVSNT = doubleFromList(crop, "DVSNT");
	crp.TBASEM = doubleFromList(crop, "TBASEM");
	crp.TEFFMX = doubleFromList(crop, "TEFFMX");
	crp.TSUMEM = doubleFromList(crop, "TSUMEM");
	crp.FNTRT = doubleFromList(crop, "FNTRT");
	crp.FRNX = doubleFromList(crop, "FRNX");
	crp.FRPX = doubleFromList(crop, "FRPX");
	crp.FRKX = doubleFromList(crop, "FRKX");
	crp.LAICR = doubleFromList(crop, "LAICR");
	crp.LRNR = doubleFromList(crop, "LRNR");
	crp.LSNR = doubleFromList(crop, "LSNR");
	crp.LRPR = doubleFromList(crop, "LRPR");
	crp.LSPR = doubleFromList(crop, "LSPR");
	crp.LRKR = doubleFromList(crop, "LRKR");
	crp.LSKR = doubleFromList(crop, "LSKR");
	crp.NLAI = doubleFromList(crop, "NLAI");
	crp.NLUE = doubleFromList(crop, "NLUE");
	crp.NMAXSO = doubleFromList(crop, "NMAXSO");
	crp.PMAXSO = doubleFromList(crop, "PMAXSO");
	crp.KMAXSO = doubleFromList(crop, "KMAXSO");
	crp.NPART = doubleFromList(crop, "NPART");
	crp.NFIXF = doubleFromList(crop, "NFIXF");
	crp.NSLA = doubleFromList(crop, "NSLA");
	crp.RNFLV = doubleFromList(crop, "RNFLV");
	crp.RNFRT = doubleFromList(crop, "RNFRT");
	crp.RNFST = doubleFromList(crop, "RNFST");
	crp.TCNT = doubleFromList(crop, "TCNT"); 
	crp.NMXLV = matFromList(crop, "NMXLV");
	crp.RPFLV = doubleFromList(crop, "RPFLV");
	crp.RPFRT = doubleFromList(crop, "RPFRT");
	crp.RPFST = doubleFromList(crop, "RPFST");
	crp.TCPT = doubleFromList(crop, "TCPT"); 
	crp.PMXLV = matFromList(crop, "PMXLV");
	crp.RKFLV = doubleFromList(crop, "RKFLV");
	crp.RKFRT = doubleFromList(crop, "RKFRT");
	crp.RKFST = doubleFromList(crop, "RKFST");
	crp.TCKT = doubleFromList(crop, "TCKT"); 
	crp.KMXLV = matFromList(crop, "KMXLV");
	crp.PHOTTB = matFromList(crop, "PHOTTB");

    crp.RDI = doubleFromList(crop, "RDI");

	
	struct LintulWeather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");	
	wth.prec = doubleFromDF(weather, "prec");	
	wth.vapr = doubleFromDF(weather, "vapr");
	wth.wind = doubleFromDF(weather, "wind");	
	DateVector wdate = dateFromDF(weather, "date");	
//	wth.startdate = SimDate(wdate[0].getDay(), wdate[0].getMonth(), wdate[0].getYear());
	
	struct Lintul3Soil sol;
    sol.SMDRY =  doubleFromList(soil, "SMDRY");
    sol.SMW = doubleFromList(soil, "SMW");
    sol.SMFC = doubleFromList(soil, "SMFC");
    sol.SM0 = doubleFromList(soil, "SM0");
    sol.SMI = doubleFromList(soil, "SMI");
    sol.SMLOWI = doubleFromList(soil, "SMLOWI");
    sol.RDMSO = doubleFromList(soil, "RDMSO");
    sol.RUNFR = doubleFromList(soil, "RUNFR");
    sol.CFEV = doubleFromList(soil, "CFEV");
	sol.KSUB = doubleFromList(soil, "KSUB");
    sol.CRAIRC = doubleFromList(soil, "CRAIRC");

	struct Lintul3Control ctr;
//* actual irrigation data
    ctr.IRRTAB  = matFromList(control, "IRRTAB");
     //ctr.RDMCR = doubleFromList(control, "RDMCR");
    ctr.FERNTAB = matFromList(control, "FERNTAB");
    ctr.NRFTAB = matFromList(control, "NRFTAB");	  
    ctr.NMINS = doubleFromList(control, "NMINS");
	ctr.RTNMINS = doubleFromList(control, "RTNMINS");
    ctr.FERPTAB = matFromList(control, "FERPTAB"); 
    ctr.PRFTAB = matFromList(control, "PRFTAB");	  
	ctr.PMINS = doubleFromList(control, "PMINS");
	ctr.RTPMINS = doubleFromList(control, "RTPMINS");
    ctr.FERKTAB = matFromList(control, "FERKTAB"); 
    ctr.KRFTAB = matFromList(control, "KRFTAB");	  
	ctr.KMINS = doubleFromList(control, "KMINS");
	ctr.RTKMINS = doubleFromList(control, "RTKMINS");
	ctr.IOPT = intFromList(control, "IOPT");
	ctr.PL = boolFromList(control, "PL");
	ctr.IRRI = intFromList(control, "IRRI");
	
	 
	DateVector start = datesFromList(control, "start"); 
	DateVector emergence = datesFromList(control, "emergence"); 

	int nsim = start.size();
	int nem = emergence.size();
	if (nem != nsim) {
		stop("start does not have the same length as emergence");
	}

//	ctr.long_output = boolFromList(control, "long_output"); 


	int nwth = wth.tmin.size();
	
//	for (int s=0; s < nsim; s++) {
	int s = 0;
	
	if (emergence[s] < wdate[0]) {
		stop("emergence requested before the beginning of the weather data");
	} else if (emergence[s] > wdate[nwth-1]) {
		stop("emergence requested after the end of the weather data");
	} else if (emergence[s] < start[s]) {
		stop("emergence requested before the start of simulation");	
	}
		
	ctr.emergence = { (int)(emergence[s] - wdate[0]) };
	ctr.start = { (int)(start[s] - wdate[0]) };
	// temp hack
	Date sd = start[s];
//	wth.startdate = SimDate(sd.getDay(), sd.getMonth(), sd.getYear());
//	}
	Lintul3Model m(crp, sol, ctr, wth);
	
	m.model_run();

	int nr = m.out.size();
	int nc = m.out[0].size();
	NumericMatrix mat(nr, nc);
	for (int i = 0; i < nr; i++) {
		for (int j = 0; j < nc; j++) {
			mat(i, j) = m.out[i][j];  
		}
	}
	
	CharacterVector cnames(nc);
	for (int j = 0; j < nc; j++) {
		cnames[j] = m.out_names[j];
	}
	colnames(mat) = cnames;
	
//    NumericMatrix mat(2, 3);
	return(mat);
}


