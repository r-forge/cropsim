//#include "SimDate.h"
#include "LINTUL.h"

struct Lintul2Control {
  int start, emergence;
}; 


struct Lintul2Soil {
	Lintul2Soil(){ EXPLOR=0; PEVAP=0; EVAP=0; RUNOFF=0; DRAIN=0; IRRIG=0; RWA=0; WA=0; WC=0; };
// parameters
	double  WCi, WCAD, WCWP, WCFC, WCWET, WCST, DRATE, IRRIGF;
// variables 
	double EXPLOR, PEVAP, EVAP, RUNOFF, DRAIN, IRRIG;
// rates 
	double RWA;
// states
	double WA, WC;
}; 


struct Lintul2Crop {
// LINTUL1
// parameters
	double WLVi, LAIi, LAIcr, SLA, Tbase, RGRL, Tsum1, Tsum2, RDRSHM, RUE, K;
	//  Partitioning tables for leaves (LV), stems (ST), storage organs (SO) and roots (RT):
	std::vector<double> RDRT, FLVTB, FSTTB, FSOTB, FRTTB;
// RATES
	double rLAI, RWLVG, DLV, RWST, RWSO, RWRT;
// STATES  
	double LAI, WLVD, WST, WSO, WRT, WLVG, WLV;

// VARIABLES  
    bool emerged, emergday, alive;
	double GLV;
	double ROOTDi, TRANCO, ROOTDM, RRDMAX;
	double PTRAN, TRAN, TRANRF;
// rates?
	double RROOTD; 
// states?   
	double ROOTD;
};



struct Lintul2Model {

	void model_run();

	struct Lintul2Crop crop;
	struct Lintul2Soil soil;
	struct Lintul2Control control;
	struct LintulWeather wth;
	
	std::vector<std::vector<double> > out;
	std::vector<std::string> out_names;
	
	double Tavg, Teff, Tsum, RainIntercepted;
	int time, step, emergence, maxdur;

	Lintul2Model(Lintul2Crop c, Lintul2Soil s, Lintul2Control t, LintulWeather w) : crop(c), soil(s), control(t), wth(w) { };
	
	void weather_step();
	void crop_initialize();
	void crop_rates();
	void crop_states();
	void soil_initialize();
	void soil_rates();
	void soil_states();
	void model_initialize();	
	void model_output(int i);
};

