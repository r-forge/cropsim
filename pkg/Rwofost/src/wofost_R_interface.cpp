/*
Authors: Robert Hijmans and Huang Fang
Date: June 2016

License: GNU General Public License (GNU GPL) v. 2
*/


#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "SimUtil.h"
#include "wofost.h"
#include "R_interface_util.h"
//#include <iostream>

// [[Rcpp::export]]
NumericMatrix wofost(List crop, DataFrame weather, List soil, List control) {


// control parameters
	struct WofostControl cntr;
	struct WofostCrop crp;

	std::vector<long> startvec = longFromList(control, "modelstart");
	long start = startvec[0];
	cntr.cropstart = intFromList(control, "cropstart");
	cntr.long_output = boolFromList(control, "long_output");

	cntr.IWB = intFromList(control, "IPRODL"); // translate IPRDL to IWB
	cntr.IOXWL = intFromList(control, "IOXWL");

	cntr.ISTCHO = intFromList(control, "ISTCHO");
	cntr.IDESOW = intFromList(control, "IDESOW");
	cntr.IDLSOW = intFromList(control, "IDLSOW");

	cntr.IENCHO = intFromList(control, "IENCHO");
	cntr.IDAYEN = intFromList(control, "IDAYEN");
	cntr.IDURMX = intFromList(control, "IDURMX");
	//npk
	cntr.npk_model = OptionalintFromList(control, "npk_model");
	if(cntr.npk_model){
		cntr.NPKdates = longFromList(control, "NPKdates");
		cntr.N_amount = vecFromList(control, "N");
		cntr.P_amount = vecFromList(control, "P");
		cntr.K_amount = vecFromList(control, "K");

		crp.pn.TCNT = doubleFromList(crop, "TCNT");
		crp.pn.TCPT = doubleFromList(crop, "TCPT");
		crp.pn.TCKT = doubleFromList(crop, "TCKT");
		crp.pn.DVSNPK_STOP = doubleFromList(crop, "DVSNPK_STOP");
		crp.pn.NFIX_FR = doubleFromList(crop, "NFIX_FR");
		crp.pn.NPART = doubleFromList(crop, "NPART");
		crp.pn.NMAXSO = doubleFromList(crop, "NMAXSO");
		crp.pn.PMAXSO = doubleFromList(crop, "PMAXSO");
		crp.pn.KMAXSO = doubleFromList(crop, "KMAXSO");
		crp.pn.NMAXRT_FR = doubleFromList(crop, "NMAXRT_FR");
		crp.pn.PMAXRT_FR = doubleFromList(crop, "PMAXRT_FR");
		crp.pn.KMAXRT_FR = doubleFromList(crop, "KMAXRT_FR");
		crp.pn.NMAXST_FR = doubleFromList(crop, "NMAXST_FR");
		crp.pn.PMAXST_FR = doubleFromList(crop, "PMAXST_FR");
		crp.pn.KMAXST_FR = doubleFromList(crop, "KMAXST_FR");
		crp.pn.NRESIDLV = doubleFromList(crop, "NRESIDLV");
		crp.pn.NRESIDST = doubleFromList(crop, "NRESIDST");
		crp.pn.NRESIDRT = doubleFromList(crop, "NRESIDRT");
		crp.pn.PRESIDLV = doubleFromList(crop, "PRESIDLV");
		crp.pn.PRESIDST = doubleFromList(crop, "PRESIDST");
		crp.pn.PRESIDRT = doubleFromList(crop, "PRESIDRT");
		crp.pn.KRESIDLV = doubleFromList(crop, "KRESIDLV");
		crp.pn.KRESIDST = doubleFromList(crop, "KRESIDST");
		crp.pn.KRESIDRT = doubleFromList(crop, "KRESIDRT");
		crp.pn.NCRIT_FR = doubleFromList(crop, "NCRIT_FR");
		crp.pn.PCRIT_FR = doubleFromList(crop, "PCRIT_FR");
		crp.pn.KCRIT_FR = doubleFromList(crop, "KCRIT_FR");
		crp.pn.NLUE_NPK = doubleFromList(crop, "NLUE_NPK");
		crp.pn.NPK_TRANSLRT_FR = doubleFromList(crop, "NPK_TRANSLRT_FR");
		crp.pn.NMAXLV_TB = TBFromList(crop, "NMAXLV_TB");
		crp.pn.PMAXLV_TB = TBFromList(crop, "PMAXLV_TB");
		crp.pn.KMAXLV_TB = TBFromList(crop, "KMAXLV_TB");

  }




	crp.p.TBASEM = doubleFromList(crop, "TBASEM");
	crp.p.TEFFMX = doubleFromList(crop, "TEFFMX");
	crp.p.TSUMEM = doubleFromList(crop, "TSUMEM");
	crp.p.IDSL = intFromList(crop, "IDSL");
	crp.p.DLO = doubleFromList(crop, "DLO");
	crp.p.DLC = doubleFromList(crop, "DLC");
	crp.p.TSUM1 = doubleFromList(crop, "TSUM1");
	crp.p.TSUM2 = doubleFromList(crop, "TSUM2");
	crp.p.DTSMTB = TBFromList(crop, "DTSMTB");

	crp.p.DVSI = doubleFromList(crop, "DVSI");
	crp.p.DVSEND = doubleFromList(crop, "DVSEND");
	crp.p.TDWI = doubleFromList(crop, "TDWI");
	crp.p.LAIEM = doubleFromList(crop, "LAIEM");
	crp.p.RGRLAI = doubleFromList(crop, "RGRLAI");
	crp.p.SLATB = TBFromList(crop, "SLATB");
	crp.p.SPA = doubleFromList(crop, "SPA");
	crp.p.SSATB = TBFromList(crop, "SSATB");
	crp.p.SPAN = doubleFromList(crop, "SPAN");
	crp.p.TBASE = doubleFromList(crop, "TBASE");
	crp.p.CVL = doubleFromList(crop, "CVL");
	crp.p.CVO = doubleFromList(crop, "CVO");
	crp.p.CVR = doubleFromList(crop, "CVR");
	crp.p.CVS = doubleFromList(crop, "CVS");
	crp.p.Q10 = doubleFromList(crop, "Q10");
	crp.p.RML = doubleFromList(crop, "RML");
	crp.p.RMO = doubleFromList(crop, "RMO");
	crp.p.RMR = doubleFromList(crop, "RMR");
	crp.p.RMS = doubleFromList(crop, "RMS");
	crp.p.RFSETB = TBFromList(crop, "RFSETB");
	crp.p.FRTB = TBFromList(crop, "FRTB");
	crp.p.FLTB = TBFromList(crop, "FLTB");
	crp.p.FSTB = TBFromList(crop, "FSTB");
	crp.p.FOTB = TBFromList(crop, "FOTB");
	crp.p.PERDL = doubleFromList(crop, "PERDL");
	crp.p.RDRRTB = TBFromList(crop, "RDRRTB");
	crp.p.RDRSTB = TBFromList(crop, "RDRSTB");
	crp.p.CFET = doubleFromList(crop, "CFET");
	crp.p.DEPNR = doubleFromList(crop, "DEPNR");
	crp.p.RDI = doubleFromList(crop, "RDI");
	crp.p.RRI = doubleFromList(crop, "RRI");
	crp.p.RDMCR = doubleFromList(crop, "RDMCR");

	crp.p.IAIRDU = intFromList(crop, "IAIRDU");

	crp.p.KDifTB = TBFromList(crop, "KDIFTB");
	crp.p.EFFTB = TBFromList(crop, "EFFTB");
	crp.p.AMAXTB = TBFromList(crop, "AMAXTB");
	crp.p.TMPFTB = TBFromList(crop, "TMPFTB");
	crp.p.TMNFTB = TBFromList(crop, "TMNFTB");

	crp.p.CO2AMAXTB = TBFromList(crop, "CO2AMAXTB");
	crp.p.CO2EFFTB = TBFromList(crop, "CO2EFFTB");
	crp.p.CO2TRATB = TBFromList(crop, "CO2TRATB");


// soil parameters
	struct WofostSoil sol;

	if (cntr.IOXWL != 0) {
		sol.SMTAB = TBFromList(soil, "SMTAB");
	} else { // should be no need to read it; need to check if true
		sol.SMTAB = TBFromList(soil, "SMTAB");
	}
	sol.SMW = doubleFromList(soil, "SMW");
	sol.SMFCF = doubleFromList(soil, "SMFCF");
	sol.SM0 = doubleFromList(soil, "SM0");
	sol.CRAIRC = doubleFromList(soil, "CRAIRC");
	sol.CONTAB = TBFromList(soil, "CONTAB");
	sol.K0 = doubleFromList(soil, "K0");
	sol.SOPE = doubleFromList(soil, "SOPE");
	sol.KSUB = doubleFromList(soil, "KSUB");
	sol.SPADS = doubleFromList(soil, "SPADS");
	sol.SPASS = doubleFromList(soil, "SPASS");
	sol.SPODS = doubleFromList(soil, "SPODS");
	sol.SPOSS = doubleFromList(soil, "SPOSS");
	sol.DEFLIM = doubleFromList(soil, "DEFLIM");


	//soil variables that used to be in the control object
	sol.IZT = intFromList(soil, "IZT");  // groundwater present
	sol.ifUNRN = intFromList(soil, "IFUNRN");
	sol.WAV = doubleFromList(soil, "WAV");
	sol.ZTI = doubleFromList(soil, "ZTI");
	sol.DD = doubleFromList(soil, "DD");
	crp.RDMSOL = doubleFromList(soil, "RDMSOL");

	sol.IDRAIN = intFromList(soil, "IDRAIN"); // presence of drains
	sol.NOTINF = intFromList(soil, "NOTINF"); // fraction not inflitrating rainfall
	sol.SSMAX = doubleFromList(soil, "SSMAX"); // max surface storage
	sol.SMLIM = doubleFromList(soil, "SMLIM");
	sol.SSI = doubleFromList(soil, "SSI");

	if(cntr.npk_model){
		sol.pn.N_recovery = vecFromList(control, "Nrecovery");
		sol.pn.P_recovery = vecFromList(control, "Precovery");
		sol.pn.K_recovery = vecFromList(control, "Krecovery");
		sol.pn.BG_N_SUPPLY = doubleFromList(soil, "BG_N_SUPPLY");
		sol.pn.BG_P_SUPPLY = doubleFromList(soil, "BG_P_SUPPLY");
		sol.pn.BG_K_SUPPLY = doubleFromList(soil, "BG_K_SUPPLY");
		sol.pn.NSOILBASE = doubleFromList(soil, "NSOILBASE");
		sol.pn.PSOILBASE = doubleFromList(soil, "PSOILBASE");
		sol.pn.KSOILBASE = doubleFromList(soil, "KSOILBASE");
		sol.pn.NSOILBASE_FR = doubleFromList(soil, "NSOILBASE_FR");
		sol.pn.PSOILBASE_FR = doubleFromList(soil, "PSOILBASE_FR");
		sol.pn.KSOILBASE_FR = doubleFromList(soil, "KSOILBASE_FR");

	}


// weather
	DailyWeather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");
	wth.prec = doubleFromDF(weather, "prec");
	wth.vapr = doubleFromDF(weather, "vapr");
	wth.wind = doubleFromDF(weather, "wind");
	wth.date = longFromDF(weather, "date");
//	DateVector wdate = dateFromDF(weather, "date");
//	wth.date.resize(wdate.size());
//	for (int i = 0; i < wdate.size(); i++) {
//		wth.date[i] = date(wdate[i].getYear(), wdate[i].getMonth(),  wdate[i].getDay());
//	}

	wth.latitude = doubleFromList(control, "latitude");
	wth.elevation = doubleFromList(control, "elevation");
	wth.AngstromA = doubleFromList(control, "ANGSTA");
	wth.AngstromB = doubleFromList(control, "ANGSTB");
	wth.CO2 = doubleFromList(control, "CO2");


	//stop( "complete reading data" );

//		Rcout << "start " << start[s].getYear() << " " << start[s].getYearday() << endl;
//		Rcout << "weather " << wdate[0].getYear() << " " << wdate[0].getYearday() << endl;

/*		if (start[s] < wdate[0]) {
			stop("start requested before the beginning of the weather data");
		} else if (start[s] > wdate[nwth-1]) {
			stop("start requested after the end of the weather data");
		}
*/
		// absolute to relative time
//		Rcout << "offset: " << int(start[s] - wdate[0]) << endl;

	cntr.modelstart = start - wth.date[0];
	

	WofostModel m;
	m.crop = crp;
	m.soil = sol;
	m.control = cntr;
	m.wth = wth;

	// cout << "reading data complete" << endl;
	// throw "error";
	// exit(0);

	m.model_run();

// handle messages
	// std::vector<std::string>  messages;
	// bool fatalError;

//	NumericMatrix mat(2, 2);
//	return(mat);

	if (m.fatalError) {
		int size = m.messages.size();
		for (int i = 0; i < size; i++) {
			Rcout << m.messages[i] << endl;
		}
	}

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
	return(mat);


}
