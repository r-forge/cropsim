/*
Authors: Robert Hijmans and Huang Fang
Date: June 2016

License: GNU General Public License (GNU GPL) v. 2
*/

using namespace std;
#include <vector>
#include "wofost.h"
#include "wofostUtil.h"
#include <math.h>
#include <string.h>
#include <iostream>


void WofostModel::weather_step() {
	if (time >= wth.tmin.size()) {
		fatalError = true;
	} else {
		atm.TMIN = wth.tmin[time];
		atm.TMAX = wth.tmax[time];
		atm.TEMP  = (atm.TMIN + atm.TMAX) / 2.;
		atm.DTEMP = (atm.TMAX + atm.TEMP) / 2.;

		atm.AVRAD = wth.srad[time] * 1000;
		atm.WIND = wth.wind[time];
		atm.VAP = wth.vapr[time] * 10;
		atm.RAIN = wth.prec[time] / 10 ; // cm !

		DOY = wth.simdate[time].dayofyear();

		ASTRO();
		vector<double> penman = PENMAN(DOY, atm.latitude, atm.elevation, atm.ANGSTA, atm.ANGSTB, atm.TMIN, atm.TMAX, atm.AVRAD, atm.VAP, atm.WIND, atm.ATMTR);

		atm.E0 = penman[0];
		atm.ES0 = penman[1];
		atm.ET0 = penman[2];
	}
}


void WofostModel::model_output(int i){
    //out.push_back( { double(step), crop.TSUM, crop.DVS, crop.GASS, crop.LAI, crop.WLV, crop.WST, crop.WRT, crop.WSO,
		//	atm.E0, soil.SM, crop.TRA, soil.WLOW, soil.W, double(i)});

		out.push_back( {double(step), crop.TSUM, crop.DVS, crop.LAI, soil.state.KAVAIL, crop.var.KDEMLV, crop.LASUM, crop.SSA, crop.WST, crop.SPA, crop.WSO } );
}


void WofostModel::model_initialize() {

	if (control.ISTCHO == 0) { // model starts at emergence)
		ISTATE = 3;
	} else if (control.ISTCHO == 1) { // model starts at sowing
		ISTATE = 1;
	} else if (control.ISTCHO == 2) { // model starts prior to earliest possible sowing date
		ISTATE = 0;
		STDAY_initialize();
	}

	DELT = 1.;
//	ISTATE = 3;

	if (control.IWB == 0) {
		IOX = 0;
	} else {
		IOX = control.IOXWL;   //for water-limited
	}

  DOY = wth.simdate[time].dayofyear();

    crop.alive = true;
	fatalError = false;

	atm.latitude = wth.latitude;
	atm.elevation = wth.elevation;
	atm.ANGSTA = wth.ANGSTA;
	atm.ANGSTB = wth.ANGSTB;

	soil_initialize();
	if(control.npk_model){
		npk_soil_dynamics_initialize();
		npk_translocation_initialize();
		npk_demand_uptake_initialize();
	}

    crop.DVS = 0.;
    crop.WRT = 0.;
    crop.TADW = 0.;
    crop.WST = 0.;
    crop.WSO = 0.;
    crop.WLV = 0.;
    crop.LV[0] = 0.;
    crop.LASUM = 0.;
    crop.LAIEXP = 0.;
    crop.LAI = 0.;
    crop.RD = crop.RDI;
	crop.TSUM = 0;
	crop.TSUME = 0.;
	crop.DTSUME = 0.;
    crop.TRA = 0.;
	crop.GASS = 0.;

	// adjusting for CO2 effects
    double CO2AMAXadj = AFGEN(crop.CO2AMAXTB, wth.CO2);
    double CO2EFFadj = AFGEN(crop.CO2EFFTB, wth.CO2);
	double CO2TRAadj = AFGEN(crop.CO2TRATB, wth.CO2);
	int n = crop.AMAXTB.size();
	for(int i=1; i<n; i=i+2) {
		crop.AMAXTB[i] = crop.AMAXTB[i] * CO2AMAXadj;
		crop.CO2EFFTB[i] = crop.CO2EFFTB[i] * CO2EFFadj;
		crop.CO2TRATB[i] = crop.CO2TRATB[i] * CO2TRAadj;
	}
}



void WofostModel::model_run() {

	//out_names = {"step", "Tsum", "DVS", "GASS", "LAI", "WLV", "WST", "WRT", "WSO", "E0", "SM", "TRA", "WLOW", "W", "run"};
  out_names = {"step", "Tsum", "DVS", "LAI", "KAVAIL", "KDEMLV", "LASUM", "SSA", "WST", "SPA", "WSO"}; //, "KDEMRT", "KDEMSO", "KDEMST", "KNI", "KSOIL", "LAI", "SM", "TAGP", "TRA", "TWLV", "TWRT", "TWSO", "TWST"};
	int nruns = control.modelstart.size();

	for (int run=0; run < nruns; run++) {

		step = 1;
		npk_step = 0;
		time = control.modelstart[run];
		unsigned cropstart_step = step + control.cropstart;

		model_initialize();

// model can start long before crop and run the soil water balance
		bool crop_emerged = false;

		while (! crop_emerged) {

			weather_step();
			if(control.npk_model){
				npk_soil_dynamics_rates();
			} else{
				soil_rates();
			}
			soil.EVWMX = atm.E0;
			soil.EVSMX = atm.ES0;
			if (step >= cropstart_step) {
				if (ISTATE == 0 ) { 	// find day of sowing
					STDAY();
				} else if (ISTATE == 1) {	// find day of emergence
					crop.TSUME = crop.TSUME + crop.DTSUME * DELT;
					if (crop.TSUME >= crop.TSUMEM) {
						ISTATE = 3;
						crop_emerged = true;
					}
					crop.DTSUME = LIMIT(0., crop.TEFFMX - crop.TBASEM, atm.TEMP - crop.TBASEM);
				} else {
					crop_emerged = true;
				}
			}
			model_output(run); //?
			if(control.npk_model){
				npk_soil_dynamics_states();
			} else{
				soil_states();
			}

			if (fatalError) {
				break;
			}
			time++;
			step++;
		}
		crop.emergence = step;
		// remove one step/day as crop simulation should start
		// on the day of emergence, not the next day
		time--;
		step--;
		out.pop_back();

		unsigned maxdur;
		if (control.IENCHO == 1) {
			maxdur = cropstart_step + control.IDAYEN;
		} else if (control.IENCHO == 2) {
			maxdur = step + control.IDURMX;
		} else if (control.IENCHO == 3) {
			maxdur = min(cropstart_step + control.IDAYEN, step + control.IDURMX);
		} else {
			// throw error
			maxdur = step + 365;
		}

		crop_initialize();

		while ((crop.alive) && (step < maxdur)) {

			weather_step();

			crop_rates();

			if(control.npk_model){
				npk_soil_dynamics_rates();
			} else{
				soil_rates();
			}

			model_output(run);
			crop_states();
			if(control.npk_model){
				npk_soil_dynamics_states();
			} else{
				soil_states();
			}
			time++;
			step++;

			if (fatalError) {
				break;
			}

		}
		if (control.IENCHO == 1) {
		// should continue until maxdur if water balance if IENCHO is 1
			while (step < maxdur) {
				weather_step();
				soil_rates();
				// assuming that the crop has been harvested..
				// not checked with fortran
				soil.EVWMX = atm.E0;
				soil.EVSMX = atm.ES0;
				model_output(run);
				crop_states();
				soil_states();
				time++;
				step++;
			}
		}
	}
}
