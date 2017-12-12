/*
Authors: Robert Hijmans and Huang Fang
Date July 2016

License: GNU General Public License (GNU GPL) v. 2
*/

#include <vector>
#include <string>
//#include "date.h"
#include "SimUtil.h"

using namespace std;

double TOTASS(double DAYL, double AMAX, double EFF, double LAI, double KDif, double AVRAD, double SINLD, double COSLD, double DSINBE, double DifPP);
double ASSIM(double AMAX, double EFF, double LAI, double KDif, double SINB, double PARDIR, double PARDif);
double SUBSOL (double PF, double D, std::vector<double> CONTAB);// flow is output
double SWEAF(double ET0, double CGNR);
std::vector<double> PENMAN (int DOY, double LAT, double ELEV, double ANGSTA, double ANGSTB, double TMIN, double TMAX, double AVRAD, double VAP, double WIND2, double ATMTR);


struct WofostControl {
	unsigned modelstart;
	unsigned cropstart; // sowing, emergence, ...;
	bool long_output;
	bool npk_model = false;  //if model is npk, default false

	unsigned IDESOW;
	int INYRG, ISTCHO, IDLSOW, IENCHO, IDAYEN, IDURMX;
	int IOXWL;   //IOX for water limited
	int	IWB; // water limited (1) or potential (0)

	std::vector<double> N_amount, P_amount, K_amount;
	std::vector<long> NPKdates;
};


struct WofostCrop {

	struct parameters {
		double TCNT, TCPT, TCKT;
		double DVSNPK_STOP, NFIX_FR, NPART;
		double RMR, RML, RMS, RMO;
		std::vector<double> RFSETB;
		double Q10;
		double NMAXSO, PMAXSO, KMAXSO;
		double NMAXRT_FR, PMAXRT_FR, KMAXRT_FR;
		double NMAXST_FR, PMAXST_FR, KMAXST_FR;
		std::vector<double> NMAXLV_TB, PMAXLV_TB, KMAXLV_TB;
		double NRESIDLV, NRESIDST, NRESIDRT, PRESIDLV, PRESIDST, PRESIDRT, KRESIDLV, KRESIDST, KRESIDRT;
		double NCRIT_FR, PCRIT_FR, KCRIT_FR;
		double NLUE_NPK, NPK_TRANSLRT_FR;
	};
	parameters par;

	struct rates {
       double RNUSO, RPUSO, RKUSO;
	   double RNUPTAKE, RPUPTAKE, RKUPTAKE;
	   double RNULV, RNUST, RNURT, RPULV, RPUST, RPURT, RKULV, RKUST, RKURT;
	   double RNLV, RNST, RNRT, RNSO, RPLV, RPST, RPRT, RPSO, RKLV, RKST, RKRT, RKSO;
	   double RNTLV, RNTST, RNTRT, RNTSO, RPTLV, RPTST, RPTRT, RPTSO, RKTLV, RKTST, RKTRT, RKTSO;
	   double RNLOSS, RPLOSS, RKLOSS;
	 double RNFIX;

	};
	rates rate;
	struct states {
		double ANLV, ANST, ANRT, ANSO;
		double APLV, APST, APRT, APSO;
		double AKLV, AKST, AKRT, AKSO;
		double ATNLV, ATNST, ATNRT;
		double ATPLV, ATPST, ATPRT;
		double ATKLV, ATKST, ATKRT;
	};
	states state;

	struct variables {
		double NNI, PNI, KNI, NPKI, NPKREF;
		double PMRES;
		double NTRANSLOCATABLE, PTRANSLOCATABLE, KTRANSLOCATABLE;
		double NDEMLV, NDEMST, NDEMRT, NDEMSO, PDEMLV, PDEMST, PDEMRT, PDEMSO, KDEMLV, KDEMST, KDEMRT, KDEMSO;
		double NUPTAKE_T, KUPTAKE_T, PUPTAKE_T, NFIX_T;
		double NLOSSES_T, KLOSSES_T, PLOSSES_T;

	};
	variables var;



// parameters
    int IAIRDU, IDSL;
	double DLO, DLC, TSUM1, TSUM2, DVSI, DVSEND, TDWI, RGRLAI, SPA, SPAN, TBASE, CVL, CVO, CVR, CVS, Q10, RML, RMO, RMR, RMS, PERDL, CFET, DEPNR, RDMCR, RRI, RDI, LAIEM;
	//emergence parameters
	double TBASEM, TEFFMX, TSUMEM;
	//tables
	std::vector<double> DTSMTB, AMAXTB, TMPFTB, KDifTB, EFFTB, TMNFTB, RFSETB, SLATB, FRTB, FLTB, FSTB, FOTB, RDRSTB, RDRRTB, SSATB;
	std::vector<double> CO2AMAXTB, CO2EFFTB, CO2TRATB;

	double PGASS;

// variables
	double TRA, TRANRF;
	double LASUM, KDif, SSA, TRAMX ;
	std::vector<double> SLA = vector<double>(366), LV = vector<double>(366), LVAGE = vector<double>(366), TMNSAV = vector<double>(7);
	double FR, FL, FS, FO;
	bool alive;
	int emergence;
	double ASRC;

// rates
	double GASS, GWST, GWSO;
	double DRST, DRLV, DRRT, DRSO; // dead rates
	double DVR; // developement rate
	double DTSUME, DTSUM, GWRT, GLAIEX, MRES;

// states
	double RD, RDOLD, GRLV;
	double DWRT, DWLV, DWST, DWSO;
	double DVS, LAI, LAIEXP;
	double WRT, WLV, WST, WSO;
	double TWRT, TWLV, TWST, TWSO, TAGP;
	double TSUM, TSUME;

//04/2017 npk
	double GASST, MREST, CTRAT, HI;

// ???
	int ILDTSM, ILVOLD, IDANTH, IDWS;
	double FYSDEL, SLAT, TADW, DSLV, TMINRA;
	double DMI, ADMI;

	//ROOTD
	double RDMSOL, RR; //RDMO,

};



struct WofostSoil {

	struct parameters {
		double BG_N_SUPPLY, BG_P_SUPPLY, BG_K_SUPPLY;
		std::vector<double> N_recovery, P_recovery, K_recovery;
		double NSOILBASE_FR, PSOILBASE_FR, KSOILBASE_FR;
		double NSOILBASE, PSOILBASE, KSOILBASE;
		double NSOILI, PSOILI, KSOILI;
	};
	parameters par;

	struct rates {
		double RNSOIL, RPSOIL, RKSOIL;
		double RNAVAIL, RPAVAIL, RKAVAIL;
	};
	rates rate;

	struct states {
		double NSOIL, PSOIL, KSOIL;
		double NAVAIL, PAVAIL, KAVAIL;
	};
	states state;




// parameters
	int IZT;
	int ifUNRN;
	int NOTINF; // fraction not inflitrating rainfall
	int IDRAIN; // presence of drains
	double RDM;
	double SM0, SMFCF, SMW;
	double SOPE, KSUB, CRAIRC, K0, SMLIM, SSI;
	double SSMAX; // max surface storage

	std::vector<double> SMTAB, CONTAB, PFTAB;

	// currently hard-coded
	std::vector<double> NINFTB;

// variables
	double EVWMX, EVSMX;
	double EVST, EVWT, TSR, WDRT, TOTINF, TOTIRR, SUMSM, PERCT, LOSST;


// rates
	double EVS, EVW;
	double RIN, RIRR, DW, PERC, LOSS, DWLOW;

// states

	double SM;
	double SS, WAV, W, WI, DSLR, WLOW, WLOWI, WWLOW;

	//???

	double RTDF, MH0, MH1, ZT, ZTI, DD, SUBAIR, WZ, WZI, WE, WEDTOT, CRT, DRAINT, CR, DMAX, DZ, PF;
	std::vector<double> SDEFTB, DEFDTB;

	//read in STDAY
	double SPADS, SPODS, SPASS, SPOSS, DEFLIM;
	// new variable in STDAY
	double SPAC, SPOC, WEXC, CAPRMX, SEEP, COSUT;
	int ILWPER, IDFWOR;

	std::vector<double> CAPRFU;

};


struct WofostAtmosphere {
	double latitude, elevation;
	double RAIN, RAINT, AVRAD, TEMP, DTEMP, TMIN, TMAX, E0, ES0, ET0, DAYL, DAYLP, WIND, VAP;
	double SINLD, COSLD, DTGA, DSINB, DSINBE, DifPP;
	double ANGSTA, ANGSTB, ATMTR;
};



struct WofostModel {

	unsigned step, time, DOY, npk_step;
	int IDHALT, ISTATE, IOX;
	double DELT;

	std::vector<std::string>  messages;
	bool fatalError;

	WofostSoil soil;
	WofostCrop crop;
	WofostControl control;

	WofostAtmosphere atm;
	DailyWeather wth;

	std::vector<std::vector<double> > out;
	std::vector<std::string> out_names;

	void weather_step();

	void crop_initialize();
	void crop_rates();
	void crop_states();

	//void npk_rates();
	//void npk_states();
	void npk_demand_uptake_initialize();
	void npk_demand_uptake_rates();
	void npk_demand_uptake_states();

  void npk_soil_dynamics_initialize();
  void npk_soil_dynamics_states();
  void npk_soil_dynamics_rates();

	void npk_crop_dynamics_initialize();
	void npk_crop_dynamics_rates();
	void npk_crop_dynamics_states();

  void npk_translocation_initialize();
	void npk_translocation_rates();
	void npk_translocation_states();

	void npk_stress();
	void npk_apply();

	void maintanance_respiration();

	void soil_initialize();
	void soil_rates();
	void soil_states();

	void WATFD_initialize();
	void WATFD_rates();
	void WATFD_states();

	void WATPP_initialize();
	void WATPP_rates();
	void WATPP_states();

	void WATGW_initialize();
	void WATGW_rates();
	void WATGW_states();

	void STDAY_initialize();
	void STDAY();

	void ROOTD_initialize();
	void ROOTD_rates();
	void ROOTD_states();

	void ASTRO();
	void EVTRA();

	void model_output();

	void model_initialize();
	void model_run();

	//04/2017 npk add
	//void npk_model_run();

	void test();

	//WofostModel(WofostCrop c, WofostSoil s, WofostControl t, Weather w) : crop(c), soil(s), control(t), wth(w) { };

};


//Undecide variables
//TSUM
//crop LAI initialization
//DAYLP and DAYL
//ITOLD in states
//NO RD in crop
