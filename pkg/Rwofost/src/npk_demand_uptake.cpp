/*
# Copyright (c) 2004-2015 Alterra, Wageningen-UR
# Allard de Wit and Iwan Supit (allard.dewit@wur.nl), July 2015
# Approach based on LINTUL N/P/K made by Joost Wolf


Calculates the crop N/P/K demand and its uptake from the soil.

    Crop N/P/K demand is calculated as the difference between the
    actual N/P/K concentration (kg N/P/K per kg biomass) in the
    vegetative plant organs (leaves, stems and roots) and the maximum
    N/P/K concentration for each organ. N/P/K uptake is then estimated
    as the minimum of supply from the soil and demand from the crop.

    Nitrogen fixation (leguminous plants) is calculated by assuming that a
    fixed fraction of the daily N demand is supplied by nitrogen fixation.
    The remaining part has to be supplied by the soil.

    The N/P/K demand of the storage organs is calculated in a somewhat
    different way because it is assumed that the demand from the storage
    organs is fulfilled by translocation of N/P/K from the leaves, stems
    and roots. So Therefore the uptake of the storage organs is calculated
    as the minimum of the translocatable N/P/K (supply) and the demand from
    the storage organs. Moreover, there is time coefficient for translocation
    which takes into account that there is a delay in the availability of
    translocatable N/P/K

    **Simulation parameters**

    ============  ============================================= =======  ======================
     Name          Description                                   Type     Unit
    ============  ============================================= =======  ======================
    NMAXLV_TB      Maximum N concentration in leaves as          TCr     kg N kg-1 dry biomass
                   function of DVS
    PMAXLV_TB      As for P                                      TCr     kg P kg-1 dry biomass
    KMAXLV_TB      As for K                                      TCr     kg K kg-1 dry biomass

    NMAXRT_FR      Maximum N concentration in roots as fraction  SCr     -
                   of maximum N concentration in leaves
    PMAXRT_FR      As for P                                      SCr     -
    KMAXRT_FR      As for K                                      SCr     -

    NMAXST_FR      Maximum N concentration in stems as fraction  SCr     -
                   of maximum N concentration in leaves
    PMAXST_FR      As for P                                      SCr     -
    KMAXST_FR      As for K                                      SCr     -

    NMAXSO         Maximum N concentration in storage organs     SCr     kg N kg-1 dry biomass
    PMAXSO         As for P                                      SCr     kg P kg-1 dry biomass
    KMAXSO         As for K                                      SCr     kg K kg-1 dry biomass

    NCRIT_FR       Critical N concentration as fraction of       SCr     -
                   maximum N concentration for vegetative
                   plant organs as a whole (leaves + stems)
    PCRIT_FR       As for P                                      SCr     -
    KCRIT_FR       As for K                                      SCr     -

    TCNT           Time coefficient for N translation to         SCr     days
                   storage organs
    TCPT           As for P                                      SCr     days
    TCKT           As for K                                      SCr     days

    NFIX_FR        fraction of crop nitrogen uptake by           SCr     kg N kg-1 dry biomass
                   biological fixation
    DVSNPK_STOP    Development stage after which no nutrients    SCr     -
                   are taken up from the soil by the crop.
    ============  ============================================= ======= =======================

    **State variables**

    =======  ================================================= ==== ============
     Name     Description                                      Pbl      Unit
    =======  ================================================= ==== ============
    NDEMLV     N Demand in living leaves                         N   |kg N ha-1|
    NDEMST     N Demand in living stems                          N   |kg N ha-1|
    NDEMRT     N Demand in living roots                          N   |kg N ha-1|
    NDEMSO     N Demand in storage organs                        N   |kg N ha-1|

    PDEMLV     P Demand in living leaves                         N   |kg P ha-1|
    PDEMST     P Demand in living stems                          N   |kg P ha-1|
    PDEMRT     P Demand in living roots                          N   |kg P ha-1|
    PDEMSO     P Demand in storage organs                        N   |kg P ha-1|

    KDEMLV     K Demand in living leaves                         N   |kg K ha-1|
    KDEMST     K Demand in living stems                          N   |kg K ha-1|
    KDEMRT     K Demand in living roots                          N   |kg K ha-1|
    KDEMSO     K Demand in storage organs                        N   |kg K ha-1|
    =======  ================================================= ==== ============


    **Rate variables**

    =======  ================================================= ==== ================
     Name     Description                                      Pbl      Unit
    =======  ================================================= ==== ================
    RNULV     Rate of N uptake in leaves                         Y   |kg N ha-1 d-1|
    RNUST     Rate of N uptake in stems                          Y   |kg N ha-1 d-1|
    RNURT     Rate of N uptake in roots                          Y   |kg N ha-1 d-1|
    RNUSO     Rate of N uptake in storage organs                 Y   |kg N ha-1 d-1|

    RPULV     Rate of P uptake in leaves                         Y   |kg P ha-1 d-1|
    RPUST     Rate of P uptake in stems                          Y   |kg P ha-1 d-1|
    RPURT     Rate of P uptake in roots                          Y   |kg P ha-1 d-1|
    RPUSO     Rate of P uptake in storage organs                 Y   |kg P ha-1 d-1|

    RKULV     Rate of K uptake in leaves                         Y   |kg K ha-1 d-1|
    RKUST     Rate of K uptake in stems                          Y   |kg K ha-1 d-1|
    RKURT     Rate of K uptake in roots                          Y   |kg K ha-1 d-1|
    RKUSO     Rate of K uptake in storage organs                 Y   |kg K ha-1 d-1|

    RNUPTAKE  Total rate of N uptake                             Y   |kg N ha-1 d-1|
    RPUPTAKE  Total rate of P uptake                             Y   |kg P ha-1 d-1|
    RKUPTAKE  Total rate of K uptake                             Y   |kg K ha-1 d-1|
    RNFIX     Rate of N fixation                                 Y   |kg N ha-1 d-1|
    =======  ================================================= ==== ================

    **Signals send or handled**

    None

    **External dependencies**

    ================  =================================== ====================  ===========
     Name              Description                         Provided by            Unit
    ================  =================================== ====================  ===========
    DVS               Crop development stage              DVS_Phenology              -
    TRA               Crop transpiration                  Evapotranspiration     |cm d-1|
    TRAMX             Potential crop transpiration        Evapotranspiration     |cm d-1|
    NAVAIL            Total available N from soil         NPK_Soil_Dynamics      |kg ha-1|
    PAVAIL            Total available P from soil         NPK_Soil_Dynamics      |kg ha-1|
    KAVAIL            Total available K from soil         NPK_Soil_Dynamics      |kg ha-1|
    NTRANSLOCATABLE   Translocatable amount of N from     NPK_Translocation      |kg ha-1|
                      stems, Leaves and roots
    PTRANSLOCATABLE   As for P                            NPK_Translocation      |kg ha-1|
    KTRANSLOCATABLE   As for K                            NPK_Translocation      |kg ha-1|
    ================  =================================== ====================  ===========
*/

using namespace std;

#include <math.h>
#include <vector>
#include "wofost.h"
#include "wofostUtil.h"
#include <string.h>


/* initiatlize

        NMAXLV_TB = AfgenTrait()  # maximum N concentration in leaves as function of dvs
        PMAXLV_TB = AfgenTrait()  # maximum P concentration in leaves as function of dvs
        KMAXLV_TB = AfgenTrait()  # maximum P concentration in leaves as function of dvs

        NMAXRT_FR = Float(-99.)  # maximum N concentration in roots as fraction of maximum N concentration in leaves
        PMAXRT_FR = Float(-99.)  # maximum P concentration in roots as fraction of maximum P concentration in leaves
        KMAXRT_FR = Float(-99.)  # maximum K concentration in roots as fraction of maximum K concentration in leaves

        NMAXST_FR = Float(-99.)  # maximum N concentration in stems as fraction of maximum N concentration in leaves
        PMAXST_FR = Float(-99.)  # maximum P concentration in stems as fraction of maximum P concentration in leaves
        KMAXST_FR = Float(-99.)  # maximum K concentration in stems as fraction of maximum K concentration in leaves

        NMAXSO = Float(-99.)  # maximum P concentration in storage organs [kg N kg-1 dry biomass]
        PMAXSO = Float(-99.)  # maximum P concentration in storage organs [kg P kg-1 dry biomass]
        KMAXSO = Float(-99.)  # maximum K concentration in storage organs [kg K kg-1 dry biomass]

        TCNT = Float(-99.)  # time coefficient for N translocation to storage organs [days]
        TCPT = Float(-99.)  # time coefficient for P translocation to storage organs [days]
        TCKT = Float(-99.)  # time coefficient for K translocation to storage organs [days]

        NFIX_FR = Float(-99.)  # fraction of crop nitrogen uptake by biological fixation
        DVSNPK_STOP = Float(-99.)  # development stage above which no crop N-P-K uptake does occur

    class StateVariables(StatesTemplate):
        NDEMLV = Float(-99.)
        NDEMST = Float(-99.)
        NDEMRT = Float(-99.)
        NDEMSO = Float(-99.)

        PDEMLV = Float(-99.)
        PDEMST = Float(-99.)
        PDEMRT = Float(-99.)
        PDEMSO = Float(-99.)

        KDEMLV = Float(-99.)
        KDEMST = Float(-99.)
        KDEMRT = Float(-99.)
        KDEMSO = Float(-99.)

    class RateVariables(RatesTemplate):
        RNULV = Float(-99.)  # N uptake rate [kg ha-1 d -1]
        RNUST = Float(-99.)
        RNURT = Float(-99.)
        RNUSO = Float(-99.)

        RPULV = Float(-99.)  # P uptake rate [kg ha-1 d -1]
        RPUST = Float(-99.)
        RPURT = Float(-99.)
        RPUSO = Float(-99.)

        RKULV = Float(-99.)  # N uptake rate [kg ha-1 d -1]
        RKUST = Float(-99.)
        RKURT = Float(-99.)
        RKUSO = Float(-99.)

        RNUPTAKE = Float(-99.)  # Total N uptake rate [kg ha-1 d -1]
        RPUPTAKE = Float(-99.)
        RKUPTAKE = Float(-99.)
        RNFIX = Float(-99.)


    def initialize(self, day, kiosk, parvalues):
        """
        :param day: start date of the simulation
        :param kiosk: variable kiosk of this PCSE instance
        :param parvalues: a ParameterProvider with parameter key/value pairs
        """

        self.params = self.Parameters(parvalues)
        self.kiosk = kiosk

        self.rates = self.RateVariables(kiosk,
            publish=["RNULV", "RNUST", "RNURT", "RNUSO",
                     "RPULV", "RPUST", "RPURT", "RPUSO",
                     "RKULV", "RKUST", "RKURT", "RKUSO",
                     "RNUPTAKE", "RPUPTAKE", "RKUPTAKE", "RNFIX"])

        self.states = self.StateVariables(kiosk,
            NDEMLV=0., NDEMST=0., NDEMRT=0., NDEMSO=0.,
            PDEMLV=0., PDEMST=0., PDEMRT=0., PDEMSO=0.,
            KDEMLV=0., KDEMST=0., KDEMRT=0., KDEMSO=0.)
}
*/
void WofostModel::npk_demand_uptake_initialize() {
  crop.var.NDEMLV = 0;
  crop.var.NDEMST = 0;
  crop.var.NDEMRT = 0;
  //crop.var.NDEMSO = 0;
  crop.var.PDEMLV = 0;
  crop.var.PDEMST = 0;
  crop.var.PDEMRT = 0;
  //crop.var.PDEMSO = 0;
  crop.var.KDEMLV = 0;
  crop.var.KDEMST = 0;
  crop.var.KDEMRT = 0;
  //crop.var.KDEMSO = 0;

}


void WofostModel::npk_demand_uptake_rates() {


//NAVAIL = total mineral N from soil and fertiliser  [kg ha-1]
//PAVAIL = total mineral P from soil and fertiliser  [kg ha-1]
//KAVAIL = total mineral K from soil and fertiliser  [kg ha-1]

//NTRANSLOCATABLE = N supply to storage organs [kg ha-1]
//PTRANSLOCATABLE = P supply to storage organs [kg ha-1]
//KTRANSLOCATABLE = K supply to storage organs [kg ha-1]

//       total NPK demand of leaves, stems and roots
    double NDEMTO = crop.var.NDEMLV + crop.var.NDEMST + crop.var.NDEMRT;
    double PDEMTO = crop.var.PDEMLV + crop.var.PDEMST + crop.var.PDEMRT;
    double KDEMTO = crop.var.KDEMLV + crop.var.KDEMST + crop.var.KDEMRT;

//  NPK uptake rate in storage organs (kg N ha-1 d-1)
//  is the mimimum of supply and demand divided by the
//  time coefficient for N/P/K translocation
    crop.rate.RNUSO = min(crop.var.NDEMSO, crop.var.NTRANSLOCATABLE) / crop.par.TCNT;
    crop.rate.RPUSO = min(crop.var.PDEMSO, crop.var.PTRANSLOCATABLE) / crop.par.TCPT;
    crop.rate.RKUSO = min(crop.var.KDEMSO, crop.var.KTRANSLOCATABLE) / crop.par.TCKT;

//  No nutrients are absorbed after development stage DVSNPK_STOP or
//  when severe water shortage occurs i.e. TRANRF <= 0.01
    //TRANRF = TRA / TRAMX;
	  double NutrientLIMIT;
    if ((crop.DVS < crop.par.DVSNPK_STOP) & (crop.TRANRF > 0.01)) {
		  NutrientLIMIT = 1.0;
    } else {
		  NutrientLIMIT = 0.;
	  }

    // biological nitrogen fixation
    crop.rate.RNFIX = (max(0., crop.par.NFIX_FR * NDEMTO) * NutrientLIMIT);

    //std::cout << "NDEMTO: " << NDEMTO << " NAVAIL: " << soil.state.NAVAIL << std::endl;
    // NPK uptake rate from soil
    crop.rate.RNUPTAKE = (max(0., min(NDEMTO - crop.rate.RNFIX, soil.state.NAVAIL)) * NutrientLIMIT);
    crop.rate.RPUPTAKE = (max(0., min(PDEMTO, soil.state.PAVAIL)) * NutrientLIMIT);
    crop.rate.RKUPTAKE = (max(0., min(KDEMTO, soil.state.KAVAIL)) * NutrientLIMIT);

    // NPK uptake rate
    // if no demand then uptake rate = 0.
    if (NDEMTO == 0.) {
        crop.rate.RNULV = crop.rate.RNUST = crop.rate.RNURT = 0.;
    } else {
        crop.rate.RNULV = (crop.var.NDEMLV / NDEMTO) * (crop.rate.RNUPTAKE + crop.rate.RNFIX);
        crop.rate.RNUST = (crop.var.NDEMST / NDEMTO) * (crop.rate.RNUPTAKE + crop.rate.RNFIX);
        crop.rate.RNURT = (crop.var.NDEMRT / NDEMTO) * (crop.rate.RNUPTAKE + crop.rate.RNFIX);
	  }
    if (PDEMTO == 0.) {
        crop.rate.RPULV = crop.rate.RPUST = crop.rate.RPURT = 0.;
    } else {
        crop.rate.RPULV = (crop.var.PDEMLV / PDEMTO) * crop.rate.RPUPTAKE;
        crop.rate.RPUST = (crop.var.PDEMST / PDEMTO) * crop.rate.RPUPTAKE;
        crop.rate.RPURT = (crop.var.PDEMRT / PDEMTO) * crop.rate.RPUPTAKE;
	  }

    if (KDEMTO == 0.) {
          crop.rate.RKULV = crop.rate.RKUST = crop.rate.RKURT = 0.;
    } else {
        crop.rate.RKULV = (crop.var.KDEMLV / KDEMTO) * crop.rate.RKUPTAKE;
        crop.rate.RKUST = (crop.var.KDEMST / KDEMTO) * crop.rate.RKUPTAKE;
        crop.rate.RKURT = (crop.var.KDEMRT / KDEMTO) * crop.rate.RKUPTAKE;
	  }
}

void WofostModel::npk_demand_uptake_states() {

//       Maximum NPK concentrations in leaves [kg N kg-1 DM]
        double NMAXLV = AFGEN(crop.par.NMAXLV_TB, crop.DVS);
        double PMAXLV = AFGEN(crop.par.PMAXLV_TB, crop.DVS);
        double KMAXLV = AFGEN(crop.par.KMAXLV_TB, crop.DVS);
        //std::cout << "NMAXLV: " << NMAXLV << std::endl;

//       Maximum NPK concentrations in stems and roots [kg N kg-1 DM]
        double NMAXST = crop.par.NMAXST_FR * NMAXLV;
        double NMAXRT = crop.par.NMAXRT_FR * NMAXLV;
        double NMAXSO = crop.par.NMAXSO;

        double PMAXST = crop.par.PMAXST_FR * PMAXLV;
        double PMAXRT = crop.par.PMAXRT_FR * PMAXLV;
        double PMAXSO = crop.par.PMAXSO;

        double KMAXST = crop.par.KMAXST_FR * KMAXLV;
        double KMAXRT = crop.par.KMAXRT_FR * KMAXLV;
        double KMAXSO = crop.par.KMAXSO;

//       N demand [kg ha-1]

        crop.var.NDEMLV = max(NMAXLV * crop.WLV - crop.state.ANLV, 0.);
        //std::cout << "NDEMLV: " << crop.var.NDEMLV << " WLV: " << crop.WLV << " ANLV: " << crop.state.ANLV << std::endl;
		// maybe should be divided by one day, see equation 5 Shibu et al., 2010
        crop.var.NDEMST = max(NMAXST * crop.WST - crop.state.ANST, 0.);
        crop.var.NDEMRT = max(NMAXRT * crop.WRT - crop.state.ANRT, 0.);
        crop.var.NDEMSO = max(NMAXSO * crop.WSO - crop.state.ANSO, 0.);

//       P demand [kg ha-1]
        crop.var.PDEMLV = max(PMAXLV * crop.WLV - crop.state.APLV, 0.);
        crop.var.PDEMST = max(PMAXST * crop.WST - crop.state.APST, 0.);
        crop.var.PDEMRT = max(PMAXRT * crop.WRT - crop.state.APRT, 0.);
        crop.var.PDEMSO = max(PMAXSO * crop.WSO - crop.state.APSO, 0.);

//       K demand [kg ha-1]
        crop.var.KDEMLV = max(KMAXLV * crop.WLV - crop.state.AKLV, 0.);
        crop.var.KDEMST = max(KMAXST * crop.WST - crop.state.AKST, 0.);
        crop.var.KDEMRT = max(KMAXRT * crop.WRT - crop.state.AKRT, 0.);
        crop.var.KDEMSO = max(KMAXSO * crop.WSO - crop.state.AKSO, 0.);
}
