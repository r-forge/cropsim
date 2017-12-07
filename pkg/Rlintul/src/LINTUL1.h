#include "SimDate.h"

struct Lintul1Output {
	std::vector<int> step;
	std::vector<double> TSUM, DLV, LAI, WLVD, WLV, WLVG, WST, WRT, WSO; 
};


struct Lintul1Control {
	int emergence;
	int maxstep = 365;
};

struct Lintul1Crop {
// LINTUL1
	Lintul1Crop(){
		LAIi = 0.012;
		SLA = 0.022;
		Tbase = 0;
		RGRL  = 0.009;
		Tsum1 = 1110;
		Tsum2 = 2180;
		LAIcr = 4;
		RDRSHM = 0.03;
		RUE = 3.0;
		K = 0.6;
	}

// PARAMETERS
	double LAIi, LAIcr, SLA, Tbase, RGRL, Tsum1, Tsum2, RDRSHM, RUE, K;
//  Partitioning tables for leaves (LV), stems (ST), storage organs (SO) and roots (RT):
	std::vector<double> RDRT, FLVTB, FSTTB, FSOTB, FRTTB;

// VARIABLES
    bool emerged, emergday, alive;
	double WLVi, GLV;
	
// RATES
	double rLAI, RWLVG, DLV, RWST, RWSO, RWRT;
	
// STATES
	double TSUM, LAI, WLVD, WST, WSO, WRT, WLVG, WLV;

//	void setRDRT(std::vector<double> x);
//	void setFRTTB(std::vector<double> x);
//	void setFLVTB(std::vector<double> x);
//	void setFSTTB(std::vector<double> x);
//	void setFSOTB(std::vector<double> x);
};


struct Lintul1Weather {
	double longitude, latitude, elevation, CO2, DAYLP;
	std::vector<SimDate> date;
	std::vector<double> srad, tmin, tmax;
};


struct Lintul1Model {
	//Lintul1Model(Lintul1Crop c, Lintul1Control t, Lintul1Weather w) : crop(c), control(t), wth(w) { };

	struct Lintul1Crop crop;
	struct Lintul1Control control;
	struct Lintul1Weather wth;
	struct Lintul1Output out;
	
//	std::vector<std::vector<double> > out;
//	std::vector<std::string> out_names;

	double Tavg, Teff;
	int time, step, maxdur;
	int maxstep = 365;

	void weather_step();

	void crop_initialize();
	void crop_rates();
	void crop_states();

	void model_initialize();
	void model_run();
	void model_output();
};

