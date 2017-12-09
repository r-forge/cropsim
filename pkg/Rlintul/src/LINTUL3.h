//#include "SimDate.h"
#include "LINTUL.h"
#include <string>


struct Lintul3Control {
	long start, emergence;
	unsigned maxdur;
	int IOPT;
	int IDPL, DAYPL;
	bool PL;
	std::vector<std::vector<double> > IRRTAB, FERNTAB, FERPTAB, PRFTAB, FERKTAB, KRFTAB, NRFTAB;
	int IRRI;
	double  RDMCR, NMINS, RTNMINS, PMINS, RTPMINS, KMINS, RTKMINS;
	double DIRROLD, DIRRO, DIRRN, DIRR, DIRR1;  
}; 


struct Lintul3Soil {
// states	
	int DSOS;
	double TDRAIN, TRAIN, TRUNOF, TIRR, TESOIL, TTRANS, WTOT, WTOTL, WTOTN, WTOTLN, WAVT, WAVTL, TWDR, SMACT, SMACTL;
    double DSLR, WAVTLI, WAVTI;
        
// rates
	double PERC1, PERC2, PERC3, RAIN0, RUNOF, RIRR, EVA, TRA, DWOT, DWOTL, DWAT, DWATL, WDR;
	
// ?	
	double RDM, WDRA, SMCR;
	double RKMINT,RNMINT, RPMINT;
	double NMINT, PMINT, KMINT;

	double RKMINS,  RNMINS, RPMINS;
	double PMINS, NMINS, KMINS;


	double NMINI, NMIN, PMINI, PMIN, KMINI, KMIN; 

// params ?	
	double SMDRY, SMW, SMFC, SM0, SMI, SMLOWI, RDMSO, RUNFR, CFEV, KSUB, CRAIRC;

}; 



struct Lintul3Crop {
	bool alive, IAIRDU, EMERG, FLOW;
	
	double CFET, DEPNR, DVSDLT, DVSDR, DVSEND, DVSI, DVSNLT, DVSNT, FNTRT, FRKX, FRNX, FRPX,  LAICR, LRKR, LRNR, LRPR, LSKR, LSNR, LSPR;
	double NFIXF, NLAI, NLUE, NPART, NSLA, RDI, RDMCR, RDRL, RDRNS, RDRSHM, RGRLAI, RKFLV, RKFRT, RKFST, RNFLV, RNFRT, RNFST, RPFLV; 
	double RPFRT, RPFST, RRI, SPA, TBASE, TBASEM, TCKT, TCNT, TCPT, TDWI, TEFFMX, TSUM1, TSUM2, TSUMEM;
	double TRA, TRANRF;
	int RDSINT, IDSL;
	std::vector<std::vector<double> >  COTB, DTSMTB, FLTB, FOTB, FRTB,  FSTB, KDIFTB, KMXLV, NMXLV; 
	std::vector<std::vector<double> >  PHOTTB, PMXLV, RDRLTB, RDRRTB, RDRSTB, RUETB, SLATB, SSATB, TMNFTB, TMPFTB;

	double PMAXSO, KMAXSO, NMAXSO;

//
	double FINTT, RR, RD;
	double NPKI;
	double GLAI, SLA;
	
	double NNI, KNI, PNI;
	double NPKREF,RUE;
// RNW
   double TSULP, TSUM, TSUML;


// ?
	double TDW, DVS, DVR, WRTI, WRT, TAGB, WLVGI, WLVG, LAII, LAI, RLAI;
	double WLVD, WSTI, WST, WSOI, WSO, WSTD, WRTD, RWLVG, RWST, RWRT, RWSO, DLV, DRST, DRRT, GRT;
	double DTSULP, DTSUM, DTSUML, DVRED, TPAR, TPARINT, PARINT, ATN, ATP, ATK, GTSUM;
	double NMAXLVI, NMAXSTI, NMAXRTI, ANLVI, ANSTI, ANRTI, ANLV, ANST, ANRT, ANSOI, ANSO, NLOSSL, NLOSSR, NLOSSS, NUPTT;
	double NFIXTT, PMAXLVI, PMAXSTI, PMAXRTI, APLVI, APSTI, APRTI, APLV, APST, APRT, APSOI, APSO, PLOSSL;
	double PLOSSR, PLOSSS, PLOSST, PUPTT, KMAXLVI, KMAXSTI, KMAXRTI, AKLVI, AKSTI, AKRTI, AKLV, AKST, AKRT, AKSOI, AKSO;
	double KLOSSL, KLOSSR, KLOSSS, KLOSST, KUPTT, CTRAN, CNNI, CPNI, CKNI, CNPKI;


	double KROOT, PROOT, NROOT, RKLDST, RKLDRT, RKLDLV, RPLDST, RPLDLV, RKLV, RKST, RKRT, RKSO, KLIVT, RNLDLV, RNLDRT, RNLDST, NLOSST, RPLDRT;
	double TAGBG, NUPTR, PUPTR, KUPTR, NFIXTR, RNLV, RNST, RNRT, RNSO, NLIVT, RPLV, RPST, RPRT, RPSO, PLIVT;

	int IDFLOW;
	int DAYEM, IDEM;
//, IDEMERG;
};



struct Lintul3Model {

	void model_run();

	struct Lintul3Crop crop;
	struct Lintul3Soil soil;
	struct Lintul3Control control;
	struct LintulWeather wth;
	
	std::vector<std::vector<double> > out;
	std::vector<std::string> out_names;
	
//	double Teff, Tsum, RainIntercepted;
	double RAIN, RAIN0, E0, ES0, ETC, TMPA, PAR; 
	
	int time;
	unsigned step, DOY;
	long emergence, today;

	Lintul3Model(Lintul3Crop c, Lintul3Soil s, Lintul3Control t, LintulWeather w) : crop(c), soil(s), control(t), wth(w) { };
	
	void weather_step();
	
	void crop_initialize();
	void crop_rates();
	void crop_ratesNPK();
	void crop_states();

	void soil_initialize();
	void soil_rates();
	void soil_states();
	
	void model_initialize();	
		
		
	void model_output();
};

