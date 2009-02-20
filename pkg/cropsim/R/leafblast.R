# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans, Rene Pangga, & Jorrel Aunario  r  hijmans@gmail.com (translated from STELLA LeafBlastMod v5)
# International Rice Research Institute
# Date :  18 February 2009
# Version 0.1
# Licence GPL v3
#Comparison of the use of wetness (1) vs. RH + rain threshold (0)

leafBlast <- function(wth, emergence='2000-05-15', onset=1, duration=120, rhlim=90, rainlim=5, wetness=0) {
	emergence <- as.Date(emergence)
	wth <- subset(wth, wth$day >= emergence)
#average temperature
    tmp <- (wth$tmax + wth$tmin) / 2
#maximum RH
	rhx <- wth$rhmx
#rain amount
	rain <- wth$prec
# wetness
	W <- wth$lfwt
	
	if (length(tmp) < duration) {
		print("Incomplete weather data")
		stop()
	}

	# constants
	RRG <- 0.1
	RRPhysiolSenesc <- 0.01
	SenescType <- 1	
	AGGR <- 1
	BaseRc <- 1.14
	Sitemax <- 30000
	initInfection <- 1
	initSites <- 600
	infectious_transit_time <- 20
	latency_transit_time <- 5

	# outputvars
	TotalSites <- vector(length=duration)
	TotalSites[] <- 0
	Sites <- vector (length=duration)
	Sites[] <- 0
	now_latent <- vector(length=duration)
	now_latent[] <- 0
	now_infectious <- vector(length=duration)
	now_infectious[] <- 0
	Removed <- vector(length=duration)
	Removed[] <- 0
	Senesced <- vector(length=duration)
	Senesced[] <- 0
	Diseased <- vector(length=duration)
	Diseased[] <- 0
	Rinfection <- vector(length=duration)
	Rinfection[] <- 0
	Rtransfer <- vector(length=duration)
	Rtransfer[] <- 0
	RGrowth <- vector(length=duration)
	RGrowth[] <- 0
	RSenesced <- vector(length=duration)
	RSenesced[] <- 0
	Severity <- vector (length=duration)
	Severity[] <- 0

	infectious <- vector(length=duration)
	infectious[] <- 0
	latency <- vector(length=duration)
	latency[] <- 0

	# Parameters
	if (wetness==0) {
		RHCoef  <- rhx

	} else {
		RHCoef <- W
	}
	
	AgeCoefRc <- cbind(0:24 * 5, c(1, 1, 1, 0.9, 0.8, 0.7, 0.64, 0.59, 0.53, 0.43, 0.32, 0.22, 0.16, 0.09, 0.03, 0.02, 0.02, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01))
	TempCoefRc <- cbind(2:9 * 5, c(0, 0.5, 1, 0.6, 0.2, 0.05, 0.01, 0))
	RHCoefRc <- cbind (4 + (0:10) * 2, c(0, 0.02, 0.09, 0.19, 0.29, 0.43, 0.54, 0.63, 0.77, 0.88, 1.0))	
	Rc <- vector(length=duration)
	Rc[] <- 0
	COFR <- vector(length=duration)
	COFR[] <- 0
	MatPer <- 20
	
	

	for (day in 1:duration) {

	# State calculations
		if (day==1) {
		# start crop growth 
			Sites[day] <- 652.80
			RSenesced[day] <- RRPhysiolSenesc * Sites[day]
			Senesced[day] <- RRPhysiolSenesc * initSites
			COFR[day] <- 1
		}
		else {
			if (day > infectious_transit_time) {
				removedToday <- infectious[infday+1]
			} else {
				removedToday <- 0
			}

			Sites[day] <- Sites[day-1] + RGrowth[day-1] - Rinfection[day-1] - RSenesced[day-1]
			RSenesced[day] <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]
			Senesced[day] <- Senesced[day-1] + RSenesced[day-1]

			latency[day] <- Rinfection[day-1]
			latday <- day - latency_transit_time + 1
			latday <- max(1, latday)
			now_latent[day] <- sum(latency[latday:day])

			infectious[day] <- Rtransfer[day-1]		
			infday <- day - infectious_transit_time + 1
			infday <- max(1, infday)
			now_infectious[day] <- sum(infectious[infday:day])
		}

		if (Sites[day] < 0 ) { 
			Sites[day] <- 0
			break 
		}
		
		if (wetness==0){
			if (rhx[day] >= rhlim | rain[day] >= rainlim) {
				RHCoef[day] <- 1
			}
		} else {
			RHCoef[day]<- AFGen (RHCoefRc, W[day])
		}		

		Rc[day] <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * RHCoef[day]
		Diseased[day] <- sum(infectious) + now_latent[day] + Removed[day]
		Removed[day] <- sum(infectious) - now_infectious[day]

		COFR[day] <- 1-(Diseased[day]/(Sites[day]+Diseased[day]))

		if (day==onset) {
		# initialization of the disease
			Rinfection[day] <- initInfection
		} else if (day > onset) {
			Rinfection[day] <- now_infectious[day] * Rc[day] * (COFR[day]^AGGR)
		} else {
			Rinfection[day] <- 0
		}
		
		if (day >= latency_transit_time ) {	
			Rtransfer[day] <- latency[latday]
		} else {
			Rtransfer[day] <- 0
		}

		TotalSites[day] <- Diseased[day] + Sites[day]
		RGrowth[day] <- RRG * Sites[day] * (1-(TotalSites[day]/Sitemax))
		Severity[day] <- (Diseased[day]-Removed[day])/(TotalSites[day] - Removed[day])*100
#	print(c(day, RHCoef[day]))	
	}

	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Rinfection, Rtransfer, RGrowth, RSenesced, Severity)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "rateinf", "rtransfer", "rgrowth", "rsenesced", "severity")
	return(res)
}

