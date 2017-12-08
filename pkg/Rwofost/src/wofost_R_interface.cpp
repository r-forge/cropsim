/*
Authors: Robert Hijmans and Huang Fang
Date: June 2016

License: GNU General Public License (GNU GPL) v. 2
*/


#include <Rcpp.h>
using namespace Rcpp;
using namespace std;
#include <vector>
#include "wofostUtil.h"
#include "wofost.h"
#include "R_interface_util.h"
#include <iostream>

// [[Rcpp::export]]
NumericMatrix wofost(List crop, DataFrame weather, List soil, List control) {


// control parameters
	struct WofostControl cntr;
	struct WofostCrop crp;

	DateVector start = datesFromList(control, "modelstart");
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
		DateVector npkdate = datesFromList(control, "NPKdates");
	  cntr.NPKdates.resize(npkdate.size());
	  for (int i = 0; i < npkdate.size(); i++) {
		  cntr.NPKdates[i] = date(npkdate[i].getYear(), npkdate[i].getMonth(),  npkdate[i].getDay());
	  }
		cntr.N_amount = vecFromList(control, "N");
		cntr.P_amount = vecFromList(control, "P");
		cntr.K_amount = vecFromList(control, "K");

		crp.par.TCNT = doubleFromList(crop, "TCNT");
		crp.par.TCPT = doubleFromList(crop, "TCPT");
		crp.par.TCKT = doubleFromList(crop, "TCKT");
		crp.par.DVSNPK_STOP = doubleFromList(crop, "DVSNPK_STOP");
		crp.par.NFIX_FR = doubleFromList(crop, "NFIX_FR");
		crp.par.NPART = doubleFromList(crop, "NPART");
		crp.par.RMR = doubleFromList(crop, "RMR");
		crp.par.RML = doubleFromList(crop, "RML");
		crp.par.RMS = doubleFromList(crop, "RMS");
		crp.par.RMO = doubleFromList(crop, "RMO");
		crp.par.Q10 = doubleFromList(crop, "Q10");
		crp.par.NMAXSO = doubleFromList(crop, "NMAXSO");
		crp.par.PMAXSO = doubleFromList(crop, "PMAXSO");
		crp.par.KMAXSO = doubleFromList(crop, "KMAXSO");
		crp.par.NMAXRT_FR = doubleFromList(crop, "NMAXRT_FR");
		crp.par.PMAXRT_FR = doubleFromList(crop, "PMAXRT_FR");
		crp.par.KMAXRT_FR = doubleFromList(crop, "KMAXRT_FR");
		crp.par.NMAXST_FR = doubleFromList(crop, "NMAXST_FR");
		crp.par.PMAXST_FR = doubleFromList(crop, "PMAXST_FR");
		crp.par.KMAXST_FR = doubleFromList(crop, "KMAXST_FR");
		crp.par.NRESIDLV = doubleFromList(crop, "NRESIDLV");
		crp.par.NRESIDST = doubleFromList(crop, "NRESIDST");
		crp.par.NRESIDRT = doubleFromList(crop, "NRESIDRT");
		crp.par.PRESIDLV = doubleFromList(crop, "PRESIDLV");
		crp.par.PRESIDST = doubleFromList(crop, "PRESIDST");
		crp.par.PRESIDRT = doubleFromList(crop, "PRESIDRT");
		crp.par.KRESIDLV = doubleFromList(crop, "KRESIDLV");
		crp.par.KRESIDST = doubleFromList(crop, "KRESIDST");
		crp.par.KRESIDRT = doubleFromList(crop, "KRESIDRT");
		crp.par.NCRIT_FR = doubleFromList(crop, "NCRIT_FR");
		crp.par.PCRIT_FR = doubleFromList(crop, "PCRIT_FR");
		crp.par.KCRIT_FR = doubleFromList(crop, "KCRIT_FR");
		crp.par.NLUE_NPK = doubleFromList(crop, "NLUE_NPK");
		crp.par.NPK_TRANSLRT_FR = doubleFromList(crop, "NPK_TRANSLRT_FR");
		crp.par.RFSETB = TBFromList(crop, "RFSETB");
		crp.par.NMAXLV_TB = TBFromList(crop, "NMAXLV_TB");
		crp.par.PMAXLV_TB = TBFromList(crop, "PMAXLV_TB");
		crp.par.KMAXLV_TB = TBFromList(crop, "KMAXLV_TB");

  }




	crp.TBASEM = doubleFromList(crop, "TBASEM");
	crp.TEFFMX = doubleFromList(crop, "TEFFMX");
	crp.TSUMEM = doubleFromList(crop, "TSUMEM");
	crp.IDSL = intFromList(crop, "IDSL");
	crp.DLO = doubleFromList(crop, "DLO");
	crp.DLC = doubleFromList(crop, "DLC");
	crp.TSUM1 = doubleFromList(crop, "TSUM1");
	crp.TSUM2 = doubleFromList(crop, "TSUM2");
	crp.DTSMTB = TBFromList(crop, "DTSMTB");

	crp.DVSI = doubleFromList(crop, "DVSI");
	crp.DVSEND = doubleFromList(crop, "DVSEND");
	crp.TDWI = doubleFromList(crop, "TDWI");
	crp.LAIEM = doubleFromList(crop, "LAIEM");
	crp.RGRLAI = doubleFromList(crop, "RGRLAI");
	crp.SLATB = TBFromList(crop, "SLATB");
	crp.SPA = doubleFromList(crop, "SPA");
	crp.SSATB = TBFromList(crop, "SSATB");
	crp.SPAN = doubleFromList(crop, "SPAN");
	crp.TBASE = doubleFromList(crop, "TBASE");
	crp.CVL = doubleFromList(crop, "CVL");
	crp.CVO = doubleFromList(crop, "CVO");
	crp.CVR = doubleFromList(crop, "CVR");
	crp.CVS = doubleFromList(crop, "CVS");
	crp.Q10 = doubleFromList(crop, "Q10");
	crp.RML = doubleFromList(crop, "RML");
	crp.RMO = doubleFromList(crop, "RMO");
	crp.RMR = doubleFromList(crop, "RMR");
	crp.RMS = doubleFromList(crop, "RMS");
	crp.RFSETB = TBFromList(crop, "RFSETB");
	crp.FRTB = TBFromList(crop, "FRTB");
	crp.FLTB = TBFromList(crop, "FLTB");
	crp.FSTB = TBFromList(crop, "FSTB");
	crp.FOTB = TBFromList(crop, "FOTB");
	crp.PERDL = doubleFromList(crop, "PERDL");
	crp.RDRRTB = TBFromList(crop, "RDRRTB");
	crp.RDRSTB = TBFromList(crop, "RDRSTB");
	crp.CFET = doubleFromList(crop, "CFET");
	crp.DEPNR = doubleFromList(crop, "DEPNR");
	crp.RDI = doubleFromList(crop, "RDI");
	crp.RRI = doubleFromList(crop, "RRI");
	crp.RDMCR = doubleFromList(crop, "RDMCR");

	crp.IAIRDU = intFromList(crop, "IAIRDU");

	crp.KDifTB = TBFromList(crop, "KDIFTB");
	crp.EFFTB = TBFromList(crop, "EFFTB");
	crp.AMAXTB = TBFromList(crop, "AMAXTB");
	crp.TMPFTB = TBFromList(crop, "TMPFTB");
	crp.TMNFTB = TBFromList(crop, "TMNFTB");

	crp.CO2AMAXTB = TBFromList(crop, "CO2AMAXTB");
	crp.CO2EFFTB = TBFromList(crop, "CO2EFFTB");
	crp.CO2TRATB = TBFromList(crop, "CO2TRATB");


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
		sol.par.N_recovery = vecFromList(control, "Nrecovery");
		sol.par.P_recovery = vecFromList(control, "Precovery");
		sol.par.K_recovery = vecFromList(control, "Krecovery");
		sol.par.BG_N_SUPPLY = doubleFromList(soil, "BG_N_SUPPLY");
		sol.par.BG_P_SUPPLY = doubleFromList(soil, "BG_P_SUPPLY");
		sol.par.BG_K_SUPPLY = doubleFromList(soil, "BG_K_SUPPLY");
		sol.par.NSOILBASE = doubleFromList(soil, "NSOILBASE");
		sol.par.PSOILBASE = doubleFromList(soil, "PSOILBASE");
		sol.par.KSOILBASE = doubleFromList(soil, "KSOILBASE");
		sol.par.NSOILBASE_FR = doubleFromList(soil, "NSOILBASE_FR");
		sol.par.PSOILBASE_FR = doubleFromList(soil, "PSOILBASE_FR");
		sol.par.KSOILBASE_FR = doubleFromList(soil, "KSOILBASE_FR");

	}


// weather
	struct Weather wth;
	wth.tmin = doubleFromDF(weather, "tmin");
	wth.tmax = doubleFromDF(weather, "tmax");
	wth.srad = doubleFromDF(weather, "srad");
	wth.prec = doubleFromDF(weather, "prec");
	wth.vapr = doubleFromDF(weather, "vapr");
	wth.wind = doubleFromDF(weather, "wind");
	DateVector wdate = dateFromDF(weather, "date");
	wth.simdate.resize(wdate.size());
	for (int i = 0; i < wdate.size(); i++) {
		wth.simdate[i] = date(wdate[i].getYear(), wdate[i].getMonth(),  wdate[i].getDay());
	}

	wth.latitude = doubleFromList(control, "latitude");
	wth.elevation = doubleFromList(control, "elevation");
	wth.ANGSTA = doubleFromList(control, "ANGSTA");
	wth.ANGSTB = doubleFromList(control, "ANGSTB");
	wth.CO2 = doubleFromList(control, "CO2");


	//stop( "complete reading data" );

	int nsim = start.size();
//	if (nsim > 1) {	cntr.long_output = false;}

	int nwth = wth.tmin.size();

	for (int s=0; s < nsim; s++) {

//		Rcout << "start " << start[s].getYear() << " " << start[s].getYearday() << endl;
//		Rcout << "weather " << wdate[0].getYear() << " " << wdate[0].getYearday() << endl;

		if (start[s] < wdate[0]) {
			stop("start requested before the beginning of the weather data");
		} else if (start[s] > wdate[nwth-1]) {
			stop("start requested after the end of the weather data");
		}

		// absolute to relative time
//		Rcout << "offset: " << int(start[s] - wdate[0]) << endl;

		cntr.modelstart.push_back(int(start[s] - wdate[0]));
	}

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
