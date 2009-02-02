

# Author: Serge Savary & Rene Pangga. 
# R translation: Rene Pangga, RJH, JA (translated from STELLA ShBMod v6)
# International Rice Research Institute
# Date :  2  February 2009
# Version 0.1
# Licence GPL v3

sheathBlight <- function(tmp, rh, duration=120, startday=30) {
	RRG <- 0.2
	RRPhysiolSenesc <- 0.005
	SenescType <- 1
	AGGR <- 2.8
	BaseRc <- 0.46
	Sitemax <- 800
	initInfection <- 1
	initSites <- 25
	initSenesced <- 0

	
	infectious_transit_time <- 120
	infectious <- vector(length=duration)
	infectious[] <- 0
	now_infectious <- vector(length=duration)
	now_infectious[] <- 0
	latency_transit_time <- 3
	latency <- vector(length=duration)
	latency[] <- 0
	now_latent <- vector(length=duration)
	now_latent[] <- 0
	Removed <- vector(length=duration)
	Removed[] <- 0
	Diseased <- vector(length=duration)
	Diseased[] <- 0
	Sites_transit_time <- 120
	Sites <- vector (length=duration)
	Sites[] <- 0
	now_Sites <-vector (length=duration)
	now_Sites <- 0
	Senesced <- vector (length=duration)
	Senesced[] <- 0
	Incidence <- vector (length=duration)
	Incidence[] <- 0
	
	
	AgeCoefRc <- cbind(0:12 * 10, c(0.84, 0.84, 0.84, 0.84, 0.84, 0.84, 0.83, 0.88, 0.88, 1.0, 1.0, 1.0, 1.0))
	RHCoefRc <- cbind(0:20 * 5, c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.24, 0.87, 0.96, 1.0))
	TempCoefRc <- cbind(3:9 * 4, c(0, 0.42, 0.94, 0.94, 1.0, 0.85, 0.64))

	Rtransfer <- 0
	Rinfection <- 0
	COFR <- 1
	Senesced <- 0
	
	for (day in 1:duration) {

		if (day==1) {
		# start crop growth 
			Sites[day] <- initSites
			Sites[day] <- 29.72
		}
		infectious[day] <- Rtransfer
		
		latency[day] <- Rinfection
		latday <- day - latency_transit_time
		latday <- max(1, latday)
		now_latent[day] <- sum(latency[latday:day])
 
		infday <- day - infectious_transit_time
		infday <- max(1, infday)
		now_infectious[day] <- sum(infectious[infday:day])

		if (day > 1) { 
			Sites[day] <- Sites[day-1] + RGrowth - Rinfection - RSenesced
			Senesced[day] <- Senesced[day-1] + RSenesced
		}	
		
		Diseased[day] <- sum(infectious) + now_latent[day]
		Removed[day] <- sum(infectious) - now_infectious[day]
		TotalSites <- Diseased[day] + Sites[day] + Senesced[day]
		
#Rate calculations
		
		
		RcAgeTemp <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * AFGen(RHCoefRc, rh[day])
		Rinfection <- now_infectious[day] * RcAgeTemp * (COFR^AGGR)
		RGrowth <- RRG * Sites[day] * (1-TotalSites/Sitemax)
		
	
	if (day > infectious_transit_time ) {	
		removedToday <- infectious[infday-1]
	} else {
		removedToday <- 0
	}	
	

	RSenesced <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]
	COFR <- 1-(Diseased[day]/(Sites[day] + Diseased[day]))
	
	if (day >= latency_transit_time ) {
		Rtransfer <- latency[latday]
		} else {
		Rtransfer <- 0

	}
	
	if (day==startday) {
		# start disease 
			{Rinfection <- initInfection}
		}
	#sday <- day - Sites_transit_time
	#sday <- max(1, sday)
	#now_Sites[day] <- sum(Sites[sday:day])
		
	Incidence[day] <- (Diseased[day]-Removed[day])/(TotalSites - Senesced[day] -Removed[day])*100	
	}
	
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Incidence)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "incidence")
	return(res)
}

