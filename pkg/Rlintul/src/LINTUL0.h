//#include "SimDate.h"
#include "LINTUL.h"

struct Lintul0Output {
	std::vector<unsigned> step;
	std::vector<double> TSUM, GC, W, WSO; 
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



struct Lintul0Model {

	LintulControl control;
	LintulWeather wth;
	Lintul0Crop crop;
	Lintul0Output out;
	
//	Lintul0Model(Lintul0Crop c, LintulControl t, LintulWeather w) : crop(c), control(t), wth(w) { };

	double Tavg, Teff, Tsum;
	int time;
	unsigned step;
	
	void weather_step();

	void model_initialize();	
	void output_initialize();
	void crop_initialize();
	void crop_rates();
	void crop_states();

	void model_run();
	void model_output();	
};



