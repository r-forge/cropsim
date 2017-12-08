/*
C++ code by Huang Fang and Robert Hijmans
Date: July 2016

License: GNU General Public License (GNU GPL) v. 2

Based on FORTRAN code WOFOST version 7.1.7, release September 2013
Copyright 1988, 2013 Alterra, Wageningen-UR, Licensed under the EUPL, Version 1.1.

Author: C.A. van Diepen, April 1989


This routine calculates for a given crop cover the maximum evaporation rate from a shaded wet soil surface and from a shaded
water surface, and the maximum and actual crop transpiration rate.
*/


using namespace std;
#include <vector>
#include <math.h>
#include "wofost.h"
#include "wofostUtil.h"
#include <iostream>


void WofostModel::EVTRA() {

//int IWB, int IOX, int IAIRDU, double KDif, double CFET, double DEPNR,
//        double E0, double ES0, double ET0, double LAI, double SM, double SM0, double SMFCF, double SMW ,double CRAIRC){

    double DSOS = 0.;
    double KGLOB, RFOS=1.;
    //extinction coefficient for total global radiation
    KGLOB = 0.75 * crop.KDif;
    //crop specific correction on potential transpiration rate
    atm.ET0 = crop.CFET * atm.ET0;

    //maximum evaporation and transpiration rates
    double EKL = exp( -KGLOB * crop.LAI);
    soil.EVWMX = atm.E0 * EKL;
    soil.EVSMX = max(0., atm.ES0 * EKL);
    crop.TRAMX = max(0.0001, atm.ET0*(1. - EKL));

    //actual transpiration rate

    //double TRA, IDOS, IDWS;
    //double SWDEP, SMCR, RFWS, SMAIR, RFOSMX, RFOS;

    if (control.IWB == 0) {
        crop.TRA  = crop.TRAMX;
        //IDOS = 0;
        //IDWS = 0;
    } else {
        //calculation critical soil moisture content
        //call function SWEAF
        double SWDEP = SWEAF(atm.ET0, crop.DEPNR);
        //cout << "ET0: " << atm.ET0 << " DEPNR" << crop.DEPNR << endl;
        //cout << "SWDEP: " << SWDEP << endl;
        double SMCR = (1. - SWDEP) * (soil.SMFCF - soil.SMW) + soil.SMW;
        //reduction in transpiration in case of water shortage
        double RFWS = LIMIT(0.,1.,(soil.SM - soil.SMW)/(SMCR - soil.SMW));
        //cout << "RFWS: " << RFWS << " SM: " << soil.SM << " SMW: " << soil.SMW << endl;
        //reduction in transpiration in case of oxygen shortage
        //for non-rice crops, and possibly deficient land drainage
        if (crop.IAIRDU == 0 && IOX == 1){
            //critical soil moisture content for aeration
            double SMAIR = soil.SM0 - soil.CRAIRC;
            //count days since start oxygen shortage (up to 4 days)
            if (soil.SM >= SMAIR){
                DSOS = min((DSOS + 1.), 4.);
            } else {
                DSOS = 0.;
            }
            //maximum reduction reached after 4 days
            //call function LIMIT
            double RFOSMX = LIMIT(0.,1.,(soil.SM0 - soil.SM)/(soil.SM0 - SMAIR));
            if (crop.IAIRDU == 0){
                RFOS = LIMIT(0.,1.,((soil.SM0-0.05)-soil.SM)/0.05);
            } else {
	            RFOS = RFOSMX + (1. - DSOS/4.)*(1. - RFOSMX);
			}
        } //else if (crop.IAIRDU == 1 || IOX == 0) {
           // RFOS = 1.;
        //}
        crop.TRA = RFWS * RFOS * crop.TRAMX;
		crop.TRANRF = crop.TRA / crop.TRAMX;
    //std::cout << "TRANRF: " << crop.TRANRF << std::endl;
        //counting number of stress days
        //not sure
        //IDOS = 0;
        //IDWS = 0;
        //if (RFOS < 1.) {IDOS = 1;}
        //if (RFWS < 1.) {IDWS = 1;}
    }

//    vector<double> result = {EVWMX, EVSMX, TRAMX, TRA, IDOS, IDWS};
//    return result;
}
