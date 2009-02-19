# Author: Serge Savary & Rene Pangga. 
# R translation: Rene Pangga, RJH, JA (translated from STELLA ShBMod v6)
# International Rice Research Institute
# Date :  19  February 2009
# Version 0.1
# Licence GPL v3
#Comparison of the use of wetness (wetness=1) vs. RH + rain threshold (wetness=0)

sheathBlight <- function(wth, emergence='2000-05-15', onset=30, duration=120, rhlim=90, rainlim=5, wetness=1) {
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

	# Constants
	RRG <- 0.2
	RRPhysiolSenesc <- 0.005
	SenescType <- 1
	AGGR <- 2.8
	BaseRc <- 0.46
	Sitemax <- 800
	initInfection <- 1
	initSites <- 25
	infectious_transit_time <- 120
	latency_transit_time <- 3
	Sites_transit_time <- 120
	
	# Output vars
	TotalSites <- vector(length=duration)
	TotalSites[] <- 0
	Sites <- vector(length=duration)
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
	
	Incidence <- vector (length=duration)
	Incidence[] <- 0

	# Boxcar
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
	
	AgeCoefRc <- cbind(0:12 * 10, c(0.84, 0.84, 0.84, 0.84, 0.84, 0.84, 0.83, 0.88, 0.88, 1.0, 1.0, 1.0, 1.0))
	RHCoefRc <- cbind(9 + (0:5) * 3, c(0.24, 0.41, 0.68, 0.94, 0.97, 1.0))
	TempCoefRc <- cbind(3:9 * 4, c(0, 0.42, 0.94, 0.94, 1.0, 0.85, 0.64))
	Rc <- vector(length=duration)
	Rc[] <- 0
	COFR <- vector(length=duration)
	COFR[] <- 0

	for (day in 1:duration) {

		if (day==1) {
		# start crop growth 
			Sites[day] <- 29.71875
			RSenesced[day] <- RRPhysiolSenesc * Sites[day]
			Senesced[day] <- RRPhysiolSenesc * initSites
		}
		else {
			if (day > infectious_transit_time ) {	
				removedToday <- infectious[infday+1]
			} else {
				removedToday <- 0
			}
			
			Sites[day] <- Sites[day-1] + RGrowth[day-1] - Rinfection[day-1] - RSenesced[day-1]
			RSenesced[day] <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]
			Senesced[day] <- Senesced[day-1] + RSenesced[day-1]
			
			latency[day] <- Rinfection[day-1]
			latday <- day - latency_transit_time+1
			latday <- max(1, latday)
			now_latent[day] <- sum(latency[latday:day])
 
			infectious[day] <- Rtransfer[day-1]
			infday <- day - infectious_transit_time+1
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
		
		Diseased[day] <- sum(infectious) + now_latent[day]
		Removed[day] <- sum(infectious) - now_infectious[day]
		
		COFR[day] <- 1-(Diseased[day]/(Sites[day] + Diseased[day]))
		
		if (day==onset) {
			# start disease 
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
		
		TotalSites[day] <- Diseased[day] + Sites[day] + Senesced[day]
		RGrowth[day] <- RRG * Sites[day] * (1-TotalSites[day]/Sitemax)
	
	#sday <- day - Sites_transit_time
	#sday <- max(1, sday)
	#now_Sites[day] <- sum(Sites[sday:day])
		
		Incidence[day] <- (Diseased[day]-Removed[day])/(TotalSites[day] - Senesced[day] - Removed[day])*100
	}
	
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Rinfection, Rtransfer, RGrowth, RSenesced, Incidence)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "rateinf", "rtransfer", "rgrowth", "rsenesced", "incidence")
	return(res)
}

