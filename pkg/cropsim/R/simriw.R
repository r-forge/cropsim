#     SIMRIW.FOR
#     SImulation Model for RIce-Weather Relationships
#     by Takeshi Horie, Lab. Crop Science, Kyoto Univ.,
#     Kyoto,Japan 



# CROPARAM
# This file gives values of crop parameters
# used in SIMRIW
# Parameters in the line 1 to 6 (GO to DVSAS)
# are related to crop phenology up to heading,
# and VERY CULTIVAR - SPECif IC!
# Those in the line 7 to 8 (GR to KCR) are for crop phenology during ripening phase.
# Those in the line 10 to 11 (EXTC and COVES) are  related to dry matter production.
# HIMX (line 12) is the maximum harvest index.
# CTR (line 13) is the critical temp. for autumn coolness.
# Those in the line 14 to 19 (A to BETA) are related to leaf  area growth.
# Those in the line 20 to 23 are related to cooling-degree-days for spikelet sterility.
#
# Current total numbers of cultivars are:


setClass('SIMRIWcultivar',
	representation (
		name = 'character',
		GV = 'numeric',
		ALF = 'numeric',
		TH = 'numeric',
		BDL = 'numeric',
		LC = 'numeric',
		DVIA  = 'numeric',
		TCR   = 'numeric',
		GR    = 'numeric',
		KCR   = 'numeric',
		EXTC  = 'numeric',
		COVES = 'numeric',
		HIMX  = 'numeric', 
		CTR   = 'numeric',
		A     = 'numeric',
		KF    = 'numeric',
		ETA   = 'numeric',
		FAS   = 'numeric',
		TCF   = 'numeric',
		BETA  = 'numeric', 
		THOT  = 'numeric',
		STO   = 'numeric',
		BST   = 'numeric',
		PST   = 'numeric'
 )
)


simriw <- function(wth, lat, cultivar, startday, CO2=350) {

#      TMN0=0.0
#      TMX0=20.0
#      RAD0=10000
##     Conversion from KJ to MJ 
    AVT = wth$temp
	RAD <- wth$srad
	TMX <- wth$tmax
	
#     Constants and parameters which may not be cutivar specific
#     Constants related to optcal properties of canopy
    SCAT = 0.25
	RSOL  = 0.1
	RCAN  = 0.22
	KREF = 0.5
#     Parameters related changes with DVI in radiation conversion efficiency
    CL = 0.001
	TAUC = 0.1
#     Conversion factors from rough to brown rice, and panicle to rough rice
    CVBP = 0.76
	CVPP = 0.9
 
#     Initial conditions for simulation

	transplant <- TRUE
	
	if (transplant) {
		DVII = 0.15  #transplant	
		LAII = 0.05
		DWI = 15
	} else {
		DVII = 0 # emergence
		LAII = 0.0025
		DWI = 4
	}
#      OPEN(30,FILE='RESULTS.SIM')
#  850 FORMAT(// ,' MON',' DAT',' DAY','    DVI','    LAI',   +' DW(g/m)',' GY(g/m)',' PY(g/m)','   T(#)',' R(MJ)',' DL(H)',/ )

    IFLUG1=0
    IFLUG2=0
    CDED=0.
    TCHECK=0.
    STERP=0.
    HTSUM=0.
    HTDAY=0.
    STHT=0.0
    ATHHT=cultivar@HIMX
    ATHLT=cultivar@HIMX
    JJ=1
    DWGRAIN=0.0
    DVI=DVII
    LAI=LAII
    DW=DWI
    DWGRAIN=0.0
    DWPAN=0.0
#     Dynamic Section of The Model  ************************************************************

	endday <- as.Date(startday) + 300
	days <- seq(startday, endday, 1)
	DL <- daylength(lat, days)

	
	growing <- TRUE
	day <- 0
	while (growing) {
		day <- day + 1
#     Culculation of Developmental Index DVI
		if (DVI < cultivar@DVIA) {
			EFT <- AVT[day]-cultivar@TH
			DVR <- 1.0/(cultivar@GV*(1.0+exp(-cultivar@ALF*EFT)))
		} else if (DVI <= 1.0) {
			EFT <- AVT[day]-cultivar@TH
			EFL <- min(DL[day]-cultivar@LC,0.)
			DVR <- (1.0-exp(cultivar@BDL*EFL))/(cultivar@GV*(1.0+exp(-cultivar@ALF*EFT)))
		} else {
			EFT <- max(AVT[day]-cultivar@TCR,0.)
			DVR <- (1.0-exp(-cultivar@KCR*EFT))/cultivar@GR
		}
		DVI <- DVI+DVR
#
#    Culculation of LAI
#
		if (DVI < 0.95) {
			EFFTL <- max(AVT[day]-cultivar@TCF,0.)
			GRLAI <- LAI*cultivar@A*(1.0-exp(-cultivar@KF*EFFTL))*(1.0-(LAI/cultivar@FAS)**cultivar@ETA)
			GRL95 <- GRLAI
			DVI95 <- DVI
		} else if (GRLAI > 0.0  |  DVI <= 1.0) {
			GRLAI <- GRL95*(1.0-(DVI-DVI95)/(1-DVI95))
			LAIMX <- LAI
			DVI1 <- DVI
		} else if (DVI < 1.1) {
			GRLAI <- -(LAIMX*(1.0-cultivar@BETA)*(DVI-DVI1)/(1.1-DVI1))*DVR
		} else {
			GRLAI <- -LAIMX*(1.0-cultivar@BETA)*DVR
		} 
		LAI <- LAI+GRLAI
#
#    Culuculation of Crop Dry Weight
#
		TAU <- exp(-(1.0-SCAT)*cultivar@EXTC*LAI)
		REF <- RCAN-(RCAN-RSOL)*exp(-KREF*LAI)
		ABSOP <- 1.0-REF-(1.0-RSOL)*TAU
		ABSRAD <- RAD[day]*ABSOP
		COVCO2 <- cultivar@COVES*(1.54*(CO2-330.0)/(1787.0+(CO2-  330.0))+1.0)
		if (DVI < 1.0) {
			CONEF <- COVCO2
		} else {
			CONEF <- COVCO2*(1.0+CL)/(1.0+CL*exp((DVI-1.0)/TAUC))
		}
		DW <- DW+CONEF*ABSRAD
#
#    Culuculation of Spikelet Sterility Percentage due to Cool Temerature
#
		if (DVI > 0.75  &  DVI < 1.2) {
			CDEG <- max(cultivar@THOT-AVT[day],0.)
			CDED <- CDED+CDEG
			SSTR <- cultivar@STO+cultivar@BST*CDED**cultivar@PST
			STLT <- min(100.0,SSTR)
			RIPEP <- 1.0-STLT/100.0
			ATHLT <- cultivar@HIMX*RIPEP
		}
#
#    Culculation of Spikelet Sterility Percentage due to Heat Stress
#
		if (DVI > 0.96  &  DVI < 1.20) {
			HTSUM <- HTSUM+TMX[day]
			HTDAY <- HTDAY+1
		} 
		if (DVI >= 1.20  &  IFLUG1 == 0) {
			AVTMX <- HTSUM/HTDAY
			STHT <- 100.0/(1.0+exp(-0.853*(AVTMX-36.6)))
			ATHHT <- (1.0-STHT/100.0)*cultivar@HIMX
			IFLUG1 <- 1
		} 
#
#    Culculation of Grain Yield
#
		ATHI <- min(ATHLT,ATHHT)
		STERP <- max(STHT,STLT)
		EFDVI <- max(DVI-1.22, 0.0)
		HI <- ATHI*(1.0-exp(-5.57*EFDVI))
		DWGRAIN <- DW*HI
		DWPAN <- DWGRAIN/CVBP/CVPP
#
#    Time Control and Terminal Condition of Simulation
#
		if (DVI > 1.0  &  AVT[day] < cultivar@CTR) {
			TCHECK <- TCHECK+1
		} 
		if (DVI > 2.0) {
			growing <- FALSE
		}
	}

#    Terminal Section of  Simulation
    PYBROD <- DWGRAIN/100.0
    PYBRON <- PYBROD/0.86
    PYPADY <- PYBRON/CVBP
    PANDW <- PYBROD/CVBP/CVPP
    DWT <- DW/100.0
} 
