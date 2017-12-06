#include "date.h"

struct Lintul2Control {
  std::vector<int> start, emergence;
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
	std::vector<std::vector<double> > RDRT, FLVTB, FSTTB, FSOTB, FRTTB;
// variables 
    bool emerged, emergday, alive;
	double GLV;
// rates
	double rLAI, RWLVG, DLV, RWST, RWSO, RWRT;
// states  
	double LAI, WLVD, WST, WSO, WRT, WLVG, WLV;
  
  
// LINTUL2
// parameters
	double ROOTDi, TRANCO, ROOTDM, RRDMAX;
// variables
	double PTRAN, TRAN, TRANRF;
// rates
	double RROOTD; 
// states   
	double ROOTD;
};


struct Lintul2Weather {
	double longitude, latitude, elevation, CO2, DAYLP;
	date startdate;
	std::vector<double> srad, tmin, tmax, prec, wind, vapr;
};



struct Lintul2Model {

	void model_run();

	struct Lintul2Crop crop;
	struct Lintul2Soil soil;
	struct Lintul2Control control;
	struct Lintul2Weather wth;
	
	std::vector<std::vector<double> > out;
	std::vector<std::string> out_names;
	
	double Tavg, Teff, Tsum, RainIntercepted;
	int time, step, emergence, maxdur;

	
	Lintul2Model(Lintul2Crop c, Lintul2Soil s, Lintul2Control t, Lintul2Weather w) : crop(c), soil(s), control(t), wth(w) { };
	
	void weather_step();
	
	void crop_initialize();
	void crop_rates();
	void crop_states();

	void soil_initialize();
	void soil_rates();
	void soil_states();
	
	void model_initialize(int run);	
		
		
	void model_output(int i);
	
};

