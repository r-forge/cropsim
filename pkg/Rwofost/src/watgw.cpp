/*Copyright 1988, 2013 Alterra, Wageningen-UR
Licensed under the EUPL, Version 1.1 or as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence")
You may not use this work except in compliance with the Licence.  You may obtain a copy of the Licence at: https://joinup.ec.europa.eu/software/page/eupl.
Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the Licence for the specific language governing permissions and limitations under the Licence.

In routine WATGW the simulation of the soil water balance is performed for soils influenced by the presence of groundwater. Two
situations are distinguished: with or without artificial drainage. The soil water balance is calculated for a cropped field in the
water-limited production situation. WATGW is called by WOFSIM.

Subroutine WATGW is derived from subroutine APPLE of WOFOST Version 4.1.

Author: C.A. van Diepen, February 1989, revised July 1990

The purpose of the calculations is to estimate the daily value of the
mean soil moisture content. The soil moisture content influences soil
moisture uptake and crop transpiration.

The water balance is driven by rainfall, possibly buffered as surface
storage, and evapotranspiration.
The processes considered are infiltration, soil water retention,
the steady state flow between the rootzone and the groundwater table
(upward flow is accounted for as capillary rise, downward flow as
percolation), and drainage rate. An irrigation term is included but not
used. The resulting groundwater depth, moisture and air contents in the
root zone are calculated.

The textural profile of the soil is conceived as homogeneous.
Three soil depth zones are distinguished: the rooted zone between
soil surface and actual rooting depth, the zone between rooting
depth and groundwater, and the zone below groundwater level to a
reference depth of XDEF=16000 cm, which is used as a formal system
boundary. Soil moisture between groundwater and root zone is assumed to
be in equilibrium with groundwater (in fact a contradiction with
capillary rise or percolation). A makeshift approach is applied when
the groundwater table rises into the rooted zone. Then two zones are
distinguished within the rooted zone, a saturated lower part and an
unsaturated upper part.
The extension of the root zone from initial rooting depth to maximum
rooting depth (crop dependent) is described in subroutine ROOTD.
The dynamic output is written to file by subroutine PRIWGW.
+-----------------------------------------------------------------+
| Date:         24 July 1997                                      |
| Author:       Tamme van der Wal                                 |
| Reason:       Adaptation of soil water balance calculations     |
|               Inclusions of methods of WOFOST4.4                |
| Modification: Addition of 2 new variables in site.dat           |
|               which need to be passed to WATFD and WATGW through|
|               WOFSIM. Variable SSI was already passed, variable |
|               SMLIM is added to parameter list                  |
+-----------------------------------------------------------------+


VARIABLE TYPE Description                                      Units   I/O
DELT    R*4  time step (= 1 day)                                d       I
IDRAIN  I*4  indicates presence (1) or absence (0) of drains            I
RD      R*4  rooting depth                                      cm      I
p.IAIRDU  I*4  indicates presence(1) or absence(0) of airducts            I
             in the roots. 1= can tolerate waterlogging
ifUNRN  I*4  flag indicating the way to calculate the                   I
             non-infiltrating fraction of rainfall:
             0. fraction is fixed at NOTINF
             1. fraction depends on NOTINF and on daily rainfall
             as given by NINFTB.
SSI     R*4  initial surface storage                            cm      I
SMLIM   R*4  max. initial soil moisture in topsoil              cm      I
SSMAX   R*4  maximum surface storage                            cm      I
ZTI     R*4  initial depth of groundwater table                 cm      I
DD      R*4  effective depth of drains (drainage base)          cm      I
NOTINF  R*4  if FUNRAI=0 non-infiltrating fraction of rainfall          I
             if FUNRAI=1 maximum non-infiltrating fraction
EVWMX   R*4  maximum evaporation rate from shaded water surface cm d-1  I
EVSMX   R*4  maximum evaporation rate from shaded soil surface  cm d-1  I
TRA     R*4  actual transpiration rate                          cm d-1  I
             Note: TRA is calculated in EVTRA called by CROPSI
SMW     R*4  soil moisture content at wilting point           cm3 cm-3  O
CRAIRC  R*4  critical air content                             cm3 cm-3  O
ZT      R*4  actual depth of groundwater table                   cm     O
SM      R*4  actual soil moisture content                     cm3 cm-3  O
RAIN    R*4  daily rainfall                                     cm d-1  I
SM0     R*4  soil porosity                                    cm3 cm-3  O
SMFCF   R*4  soil moisture content at field capacity          cm3 cm-3  O

*/


#include "wofost.h"
#include "SimUtil.h"
#include <math.h>
#include <iostream>
using namespace std;

void WofostModel::WATGW_initialize() {
    //!!!      DATA XDEF/16000./
    double XDEF = 1000.;
    //     mathematical parameters
    double PGAU[3] = {0.1127016654, 0.5, 0.8872983346};
    double WGAU[3] = {0.2777778, 0.4444444, 0.2777778};
//     infiltration parameters WOFOST41
//      DATA NINFTB/0.0,0.00, 0.5,0.12, 1.0,0.29,
//                   2.0,0.71, 3.0,0.91, 7.0,1.00, 8*0./
//     infiltration parameters WOFOST_WRR
    soil.NINFTB = {0.0, 0.0, 0.5, 0.0, 1.5, 1.0, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.};
    
    soil.SMFCF = AFGEN(soil.SMTAB, log10(200.));
    soil.SMW = AFGEN(soil.SMTAB, log10(16000.));
    soil.SM0 = AFGEN(soil.SMTAB, -1.);
    
    soil.K0 = pow(10., AFGEN(soil.CONTAB, -1.));

    int ILSM = soil.SMTAB.size();
    soil.PFTAB.resize(ILSM);
    for(int i = 2; i <= ILSM; i = i + 2){
        soil.PFTAB[ILSM - i] = soil.SMTAB[i - 1];
        soil.PFTAB[ILSM + 1 - i] = soil.SMTAB[i - 2];
    }
    soil.RTDF = 0.;
    //        old rooting depth

    //------------------------------------------------------
//        soil air volume above watertable at equilibrium
//------------------------------------------------------
//        table SDEFTB is calculated, containing the cumulative amount of
//        air as a function of height above groundwater under equilibrium
//        conditions. the table is calculated for the following values of
//        height (= matric head) : 0,2,4,8,16,32,64,128,256,.....16384.
//        method is 3 point gaussian integration of SM on each interval.
//        Table DEFDTB is the inverse function of SDEFTB.


    crop.RDOLD = crop.RD;
    soil.MH0 = 0.;
    soil.MH1 = 2.;
    soil.SDEFTB.resize(30);
    soil.DEFDTB.resize(30);
    soil.SDEFTB[0] = 0.;
    soil.SDEFTB[1] = 0.;
    soil.DEFDTB[0] = 0.;
    soil.DEFDTB[1] = 0.;

    int i2 = 0;
    for(int i = 2; i <= 15; i++){
        i2 = 2*i;
        soil.SDEFTB[i2 - 2] = soil.MH1;
        soil.SDEFTB[i2 - 1] = soil.SDEFTB[i2 - 3];
        for(int j = 0; j < 3; j++){
            soil.SDEFTB[i2 - 1] = soil.SDEFTB[i2 - 1] + WGAU[j] * (soil.MH1 - soil.MH0) * (soil.SM0 - AFGEN(soil.SMTAB, log10(soil.MH0 + (soil.MH1 - soil.MH0)*PGAU[j])));
        }
        soil.DEFDTB[i2 - 2] = soil.SDEFTB[i2 - 1];
        soil.DEFDTB[i2 - 1] = soil.SDEFTB[i2 - 2];
        soil.MH0 = soil.MH1;
        soil.MH1 = 2 * soil.MH1;
    }
        //-----------------------------------------------------
//        initial state variables of the water balance
//-----------------------------------------------------
    soil.SS = soil.SSI;
    soil.ZT = LIMIT(0.1, XDEF, soil.ZTI);
    if(soil.IDRAIN == 1){
        soil.ZT = max(soil.ZT, soil.DD);
    }
    //        amount of air in soil below rooted zone
    soil.SUBAIR = AFGEN(soil.SDEFTB, soil.ZT - crop.RD);

    //        amount of moisture in soil below rooted zone
    soil.WZ = (XDEF - crop.RD) * soil.SM0 - soil.SUBAIR;
    soil.WZI = soil.WZ;
    //        equilibrium amount of soil moisture in rooted zone

    soil.WE = soil.SM0 * crop.RD + soil.SUBAIR - AFGEN(soil.SDEFTB, soil.ZT);
    //        equilibrium amount of moisture above drains up to the surface
    soil.WEDTOT = soil.SM0 * soil.DD - AFGEN(soil.SDEFTB, soil.DD);
//        initial moisture content in rooted zone
    if(soil.ZT < crop.RD + 100.){
        //           groundwater in or close to rootzone
        soil.W = soil.WE;
        //cout << "init W: " << soil.W << endl;
    } else{
        //           groundwater well below rootzone
        soil.W = soil.SMFCF * crop.RD;
    }
    //cout << "RD: " << crop.RD << endl;
    soil.SM = soil.W/crop.RD;
    soil.WI = soil.W;
    //        soil evaporation, days since last rain
    soil.DSLR = 1.;
    if(soil.SM <= AFGEN(soil.SMTAB, 3.0)){
        soil.DSLR = 5.;
    }
    //----------------------------------------------------------
    //        all summation variables are initially set at zero
    //----------------------------------------------------------
    soil.EVST = 0.;
    soil.EVWT = 0.;
    soil.TSR = 0.;
    soil.CRT = 0.;
    soil.PERCT = 0.;
    atm.RAINT = 0.;
    soil.WDRT = 0.;
    soil.TOTINF = 0.;
    soil.TOTIRR = 0.;
    soil.SUMSM = 0.;
    soil.DRAINT = 0.;
    //--------------------------------------------
    //        all rates are initially set at zero
    //--------------------------------------------
    soil.EVS = 0.;
    soil.EVW = 0.;
    atm.RAIN = 0.;
    soil.RIN = 0.;
    soil.RIRR = 0.;
    soil.DW = 0.;
    soil.PERC = 0.;
    soil.CR = 0.;
    soil.DMAX = 0.;
    soil.DZ = 0.;


}

void WofostModel::WATGW_rates() {
    //-----------------------------------------------------------------------
//        rates of the water balance
//-----------------------------------------------------------------------

//        actual transpiration rate
//        N.B.: transpiration rate is calculated in EVTRA called by CROPSI
//        actual evaporation rates ...

    soil.EVW = 0.;
    soil.EVS = 0.;
    //        ... from surface water if surface storage more than 1 cm, ...
    if(soil.SS > 1.){
        soil.EVW = soil.EVWMX;
        //           ... else from soil surface
    } else {
        //! in WOFOST 4.1 :   evs = evsmx * limit(0.,1.,(sm-smw/3.)/(sm0-smw/3.))
        if(soil.RIN >= 1.){
            soil.EVS = soil.EVSMX;
            soil.DSLR = 1.;
        } else{
            soil.DSLR = soil.DSLR + 1;
            double EVSMXT = soil.EVSMX * (sqrt(soil.DSLR) - sqrt(soil.DSLR - 1.));
            soil.EVS = min(soil.EVSMX, EVSMXT + soil.RIN);
        }
    }
    //        preliminary infiltration rate
    double RINPRE;
    if(soil.SS > 0.1){
        //           with surface storage, infiltration limited by SOPE
        //!!         Next line replaced TvdW 24-jul-97
        //!!            AVAIL  = SS+(RAIN+RIRR-EVW)*DELT
        double AVAIL = soil.SS + (atm.RAIN * (1. - soil.NOTINF) + soil.RIRR - soil.EVW) * DELT;
        RINPRE = min(soil.SOPE * DELT, AVAIL) / DELT;
    } else {
        if(soil.ifUNRN == 0) { 
			RINPRE = (1. - soil.NOTINF) * atm.RAIN + soil.RIRR + soil.SS/DELT; 
		} else { // if(soil.ifUNRN == 1){
            RINPRE = (1. - soil.NOTINF * AFGEN(soil.NINFTB, atm.RAIN)) * atm.RAIN + soil.RIRR + soil.SS/DELT;
        }
    }
    //        indicator for groundwater table within (-) or below (+) rootzone
    double ZTMRD = soil.ZT - crop.RD;
    //        capillary flow through the lower root zone boundary
    //        no capillary flow if groundwater table is within rooted zone
    soil.CR = 0.;
    soil.PERC = 0.;

    if(ZTMRD > 0.){
        //           groundwater table below rooted zone:
        //           equilibrium amount of soil moisture in rooted zone
        soil.WE = soil.SM0 * crop.RD + soil.SUBAIR - AFGEN(soil.SDEFTB, soil.ZT);
        //           soil suction
        soil.PF = AFGEN(soil.PFTAB, soil.SM);
        //           calculate capillary flow
        //call subsol;
        double FLOW = SUBSOL(soil.PF, ZTMRD, soil.CONTAB);
        //           flow is accounted for as capillary rise or percolation
        if(FLOW >= 0.){
            soil.CR = min(FLOW, max(soil.WE - soil.W, 0.) / DELT);
        }
        if(FLOW <= 0.){
            soil.PERC = -1. * max(FLOW, min(soil.WE - soil.W, 0.) / DELT);
        }
        //           hypothesis : for rice percolation is limited to K0/20
        if(crop.p.IAIRDU == 1){
            soil.PERC = min(soil.PERC, 0.05 * soil.K0);
        }
    }
    //        drainage rate
    if(soil.IDRAIN == 1 && soil.ZT < soil.DD){
        //           capacity of artificial drainage system
        double DR1 = 0.2 * soil.K0;
        double DR2;
        if(ZTMRD <= 0.){
            //              ground water above drains and within rootzone
            DR2 = max(0., soil.W + max(0., soil.DD - crop.RD) * soil.SM0 - soil.WEDTOT) / DELT;
            soil.DMAX = min(DR1, DR2);
        } else{
            //              groundwater above drains and below root zone ; available
            //              is the difference between equilibrium water above drains
            //              and equilibrium water above groundwater level (both until
            //              root zone).

            DR2 = (AFGEN(soil.SDEFTB, soil.DD - crop.RD) - soil.SUBAIR) / DELT;
            soil.DMAX = min(DR1, DR2);
        }

    } else{
        //           no drainage if drains are absent or if groundwater is below drains
        soil.DMAX = 0.;
    }
    //        change in the groundwater depth
    //        and adjustment of infiltration rate

    if(ZTMRD <= 0.) {
        double AIRC;
        // groundwater table within rootzone
        // air concentration above groundwater in cm3/cm3
        if (soil.ZT >= 0.1) {
            AIRC = (crop.RD * soil.SM0 - soil.W) / soil.ZT;
        } else {
			AIRC = 0; // RH ???
		}
        //           infiltration rate not to exceed available soil air volume
        soil.PERC = soil.DMAX;
        soil.RIN = min(RINPRE, AIRC * soil.ZT / DELT + crop.TRA + soil.EVS + soil.PERC);
        soil.DZ = (crop.TRA + soil.EVS + soil.PERC - soil.RIN) / AIRC;
        //           check if groundwater table stays within rooted zone
        if (soil.DZ * DELT > crop.RD - soil.ZT) {
            //              groundwater table will drop below rooted zone;
            //              in order to maintain a stable moisture content in the rooted
            //              zone during this transition, water is recovered from the subsoil.
            //              In the water balance of the rooted zone this amount of water is
            //              accounted for as CR (capillary rise).
            soil.CR = (soil.DZ * DELT - (crop.RD - soil.ZT)) * AIRC / DELT;
            //              new equilibrium groundwater depth, based on the soil water
            //              deficit
            soil.DZ = (AFGEN(soil.DEFDTB, soil.CR * DELT) + crop.RD - soil.ZT) / DELT;
        }
    }else{
        //           groundwater table below rootzone
        double DEF1 = soil.SUBAIR + (soil.DMAX + soil.CR + soil.PERC) * DELT;
        //           groundwater not to exceed RD in current time step
        if(DEF1 < 0.){
            soil.PERC = soil.PERC + DEF1/DELT;
        }
        soil.DZ = (AFGEN(soil.DEFDTB, DEF1) + crop.RD - soil.ZT) / DELT;
        //           infiltration rate not to exceed available soil air volume
        soil.RIN = min(RINPRE, (soil.SM0 - soil.SM - 0.0004) * crop.RD / DELT + crop.TRA + soil.EVS + soil.PERC - soil.CR);
    }
        //        rate of change in amount of moisture in the root zone
    soil.DW = crop.TRA - soil.EVS - soil.PERC + soil.CR + soil.RIN;
        //---------------
        //        output
        //---------------
        //        output to WOFOST.OUT of daily soil water variables
//        RAINT1 = RAINT;
//        EVW1   = EVW;
//        EVS1   = EVS;
//        SM1    = SM;
//        SS1    = SS;
//        ZT1    = ZT;
}


void WofostModel::WATGW_states(){
//----------------------------------------------------------------------
//     dynamic calculations
//     integrals of the water balance:  summation and state variables
//----------------------------------------------------------------------

//        transpiration
    //        total evaporation from surface water layer and/or soil
    soil.EVWT = soil.EVWT + soil.EVW * DELT;
    soil.EVST = soil.EVST + soil.EVS * DELT;
    //        totals for rainfall, irrigation and infiltration
    atm.RAINT = atm.RAINT + atm.RAIN * DELT;
    soil.TOTINF = soil.TOTINF + soil.RIN * DELT;
    soil.TOTIRR = soil.TOTIRR + soil.RIRR * DELT;
    //        surface storage and runoff
    double SSPRE = soil.SS + (atm.RAIN + soil.RIRR - soil.EVW - soil.RIN) * DELT;
    soil.SS = min(SSPRE, soil.SSMAX);
    soil.TSR = soil.TSR + (SSPRE - soil.SS);
    //        amount of water in rooted zone
    soil.W = soil.W + soil.DW * DELT;

    //        total capillary rise or percolation
    soil.CRT = soil.CRT + soil.CR * DELT;
    soil.PERCT = soil.PERCT + soil.PERC * DELT;
    //        total drainage
    soil.DRAINT = soil.DRAINT + soil.DMAX * DELT;
    //        groundwater depth
    soil.ZT = soil.ZT + soil.DZ * DELT;
    //        amount of air and water below rooted zone
    soil.SUBAIR = AFGEN(soil.SDEFTB, soil.ZT - crop.RDOLD);
    double XDEF = 1000.;
    soil.WZ = (XDEF - crop.RDOLD) * soil.SM0 - soil.SUBAIR;

    //---------------------------------------------
    //        change of rootzone subsystem boundary
    //---------------------------------------------
    //        calculation of amount of soil moisture in new rootzone
    if(crop.RD - crop.RDOLD > 0.001){
        //           save old value SUBAIR, new values SUBAIR and WZ
        double SUBAI0 = soil.SUBAIR;
        soil.SUBAIR = AFGEN(soil.SDEFTB, soil.ZT - crop.RD);
        soil.WZ = (XDEF - crop.RD) * soil.SM0 - soil.SUBAIR;
        //           water added to rooted zone by root growth
        double WDR = soil.SM0 * (crop.RD - crop.RDOLD) - (SUBAI0 - soil.SUBAIR);
        //           total water addition to rootzone by root growth
        soil.WDRT = soil.WDRT + WDR;
        soil.W = soil.W + WDR;
    }
    //        mean soil moisture content in rooted zone
    soil.SM = soil.W / crop.RD;
    //        calculating mean soil moisture content over growing period
    soil.SUMSM = soil.SUMSM + soil.SM * DELT;
    //        save rooting depth
    crop.RDOLD = crop.RD;
    //------------------------------
    //        check on waterlogging
    //------------------------------
    //        finish conditions due to lasting lack of oxygen in root zone
    //        (non-rice crops only)
    if(crop.p.IAIRDU == 0 && soil.RTDF >= 10.){
        string m ("Crop failure due to waterlogging");
        messages.push_back(m);
        fatalError = true;
    } else{
        if(soil.ZT < 10.){
            soil.RTDF++;
        }
        if(soil.ZT >= 10.){
            soil.RTDF = 0.;
        }
    }

}










