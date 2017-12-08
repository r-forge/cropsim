//#include "SimDate.h"

struct Lintul0Control {
  std::vector<int> emergence;
}; 


struct Lintul0Crop {
// Lintul0
	Lintul0Crop(){ 
		F0 = 0.01 ;
		maxGC = 0.8;
		R0 = 0.014;
		TT50  = 1500; 
		d50 = 600; 
		RUE = 2.9; 
		TTst1 = 400; 
		TTst2 = 600;
		Tbase = 2;
		coldtmp1= 0;
		coldtmp2= -2;
		coldtmp1= -4;
		cthi1 = 15;
		cthi2 = 30;
	}


// parameters
	double F0, maxGC, R0, TT50, d50, RUE, TTst1, TTst2, Tbase;
	double coldtmp1, coldtmp2, coldtmp3, cthi1, cthi2;
// variables 
    bool alive;
	double MGCL;
// rates
	double FIntRad, WSOr, Wr;
// states  
	double W, WSO, GC;
};



struct Lintul0Weather {
	double longitude, latitude, elevation, CO2, DAYLP;
	long startdate;
	std::vector<double> srad, tmin, tmax;
};


struct Lintul0Model {
	
	Lintul0Model(Lintul0Crop c, Lintul0Control t, Lintul0Weather w) : crop(c), control(t), wth(w) { };

	struct Lintul0Crop crop;
	struct Lintul0Control control;
	struct Lintul0Weather wth;
	
	std::vector<std::vector<double> > out;

	double Tavg, Teff, Tsum;
	int time, step, maxdur;
	
	void weather_step();
	
	void crop_initialize();
	void crop_rates();
	void crop_states();

	void model_initialize(int run);	

	void model_run();
	void model_output(int i);	
};



