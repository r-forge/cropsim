using namespace std;
#include <vector>
#include <algorithm>
#include <cmath>
#include "SimUtil.h"
#include "LINTUL0.h"


void Lintul0Model::model_output(int i){
	out[i][0] = step;
	out[i][1] = Tsum;
	out[i][2] = crop.GC;
	out[i][3] = crop.W;
	out[i][4] = crop.WSO;
}


void Lintul0Model::weather_step() {
	Tavg = (wth.tmin[time] + wth.tmax[time] ) / 2;
	Teff = std::max(0.0, Tavg - crop.Tbase);
}


void Lintul0Model::crop_initialize() {
	crop.GC = 0;
	crop.W = 0;
	crop.WSO = 0;
	crop.MGCL = 1;
	crop.alive = true;
}



void Lintul0Model::model_initialize(int run) {
	Tsum = 0;
	step = 0;
	crop_initialize();
	time = control.emergence[run];	
}



void Lintul0Model::crop_rates() {

    double FIntRadExp = (crop.F0 * crop.maxGC) / (crop.F0 + (crop.maxGC - crop.F0) * exp(-crop.R0 * Tsum));
	double FIntRadSen = 0.5 - (Tsum - crop.TT50) / crop.d50;
	double HI, GCL;
	
	crop.FIntRad = std::min(FIntRadExp, FIntRadSen);
	crop.FIntRad = std::min(1., std::max(0., crop.FIntRad));	
	
	// cold damage
    if (wth.tmin[time] >= crop.coldtmp1) {
		GCL = 1;
	} else if (wth.tmin[time] <= crop.coldtmp2) {
		GCL = 0;
	} else {
		GCL = 1-((wth.tmin[time]-crop.coldtmp1)/(crop.coldtmp2-crop.coldtmp1));
    }
	if (wth.tmin[time] <= crop.coldtmp3) {
		crop.alive = false;
	}
    if (GCL < crop.MGCL) {
		crop.MGCL = GCL;
	}
    
	
	crop.FIntRad = crop.FIntRad * crop.MGCL;
	
	
    if (Tsum < crop.TTst1) {
		HI = 0;
	} else if (Tsum < crop.TTst2) {
		HI = (Tsum - crop.TTst1) / (crop.TTst2 - crop.TTst1);
    } else {
		HI = 1;
	}
	// heat effect 
	if (Tavg > crop.cthi2) {
		HI = 0; 
	} else if (Tavg > crop.cthi1) {
		HI = HI * (1-(Tavg - crop.cthi1)/(crop.cthi2 - crop.cthi1));
	}

	double PAR = 0.5 * wth.srad[time];
   	crop.Wr = crop.GC * PAR * crop.RUE;
	crop.WSOr = crop.Wr * HI;
	
	if (Tsum > crop.TT50) {
		crop.alive = false;
	}	
}

	

void Lintul0Model::crop_states() {
  
	crop.GC = crop.FIntRad;
	crop.W  = crop.W + crop.Wr;
	crop.WSO  = crop.WSO + crop.WSOr;
	
	Tsum = Tsum + Teff;  
}

	
	
void Lintul0Model::model_run() {
  
	int nruns = control.emergence.size();
	int maxstep = 250;

	out = matrix(maxstep, 5);

	for (int run=0; run < nruns; run++) {

		model_initialize(run); 
	
			
		while ((crop.alive) & (step < maxstep)) {  
			weather_step();
			crop_rates();
			model_output(step);
			crop_states();
			time++;
			step++;		
		}
	}
}

