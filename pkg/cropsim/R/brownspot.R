# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans & Rene Pangga, r.hijmans@gmail.com (translated from STELLA BSMod v6)
# International Rice Research Institute
# Date :  28 January 2009
# Version 0.1
# Licence GPL v3

brownSpot <- function(wth, emergence='2000-05-15', onset=1,  duration=120, rhlim=90) {
	emergence <- as.Date(emergence)
	wth <- subset(wth, wth$day >= emergence)

	tmp <- (wth$tmax + wth$tmin) / 2
	rh <- wth$relh

	if (length(tmp) < duration) {
		print("Incomplete weather data")
		stop()
	}

	# constants	
	RRG <- 0.1
	RRPhysiolSenesc <- 0.01
	SenescType <- 1
	AGGR <- 1
	BaseRc <- 0.61
	Sitemax <- 100000
	initInfection <- 1
	initSites <- 600
	infectious_transit_time <- 19
	latency_transit_time <- 6

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

	# Boxcar
	infectious <- vector(length=duration)
	infectious[] <- 0
	latency <- vector(length=duration)
	latency[] <- 0

	# Parameters
	AgeCoefRc <- cbind(0:6 * 20, c(0.35, 0.35, 0.35, 0.47, 0.59, 0.71, 1.0))
	RHCoefRc <- rh
	RHCoefRc[] <- 0
	RHCoefRc[rh >= rhlim] <- 1
	TempCoefRc <- cbind(15+(0:4) * 5, c(0, 0.06, 1.0, 0.85, 0.16))
	RcAgeTemp <- vector(length=duration)
	RcAgeTemp[] <- 0
	COFR <- vector(length=duration)
	COFR[] <- 0
	MatPer <- 20

	for (day in 1:duration) {
		
		if (day==1){
			Sites[day] = 653.64
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


		RcAgeTemp[day] <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * RHCoefRc[day]
			
		Diseased[day] <- sum(infectious) + now_latent[day] + Removed[day]
		Removed[day] <- sum(infectious) - now_infectious[day]

		COFR[day] <- 1-(Diseased[day]/(Sites[day]+Diseased[day]))

		if (day==onset) {
			# initialization of the disease
			Rinfection[day] <- initInfection
		} else if (day > onset) {
			Rinfection[day] <- now_infectious[day] * RcAgeTemp[day] * (COFR[day]^AGGR)
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
	}

	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Rinfection, Rtransfer, RGrowth, RSenesced)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "rateinf", "rtransfer", "rgrowth", "rsenesced")
	return(res)
}

