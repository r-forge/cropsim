# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans , Rene Pangga &  Jorrel Aunario r.hijmans@gmail.com (translated from STELLA BSMod v6T and  BSMod v6W)
# International Rice Research Institute
# Date :  10 June 2009
# Version 0.1
# Licence GPL v3
#switch :  wetness (1) uses leaf wetness duration corresponding to  STELLA BSMod v6W vs. wetness (0)  uses RH + rain threshold corresponding to  STELLA  BSModv6T 


brownSpot <- function(wth, emergence='2000-05-15', onset=20, duration=120, rhlim=90, rainlim=5, wetness=0) {
	emergence <- as.Date(emergence)
	wth@w <- subset(wth@w, wth@w$date >= emergence)
	if (dim(wth@w)[1] < duration) {
		stop("Incomplete weather data")
	}
	wth@w <- wth@w[1:duration,]
	
# wetness
	if (wetness == 1) {
		W <- leafWet(wth, simple=TRUE)
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
	Severity <- vector (length=duration)
	Severity[] <- 0

	# Boxcar
	infectious <- vector(length=duration)
	infectious[] <- 0
	latency <- vector(length=duration)
	latency[] <- 0

	# Parameters
	
	RHCoef <- vector(length=duration)
	RHCoef[] <- 0
	
	AgeCoefRc <- cbind(0:6 * 20, c(0.35, 0.35, 0.35, 0.47, 0.59, 0.71, 1.0))
	TempCoefRc <- cbind(15+(0:5) * 5, c(0, 0.06, 1.0, 0.85, 0.16, 0))
	RHCoefRc <- cbind(0:8 * 3, c(0, 0.12, 0.20, 0.38, 0.46, 0.60, 0.73, 0.87, 1.0))
	Rc <- vector(length=duration)
	Rc[] <- 0
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

		if (wetness==0){
			if (wth@w$rhmax[day] >= rhlim | wth@w$prec[day] >= rainlim) {
				RHCoef[day] <- 1
			}
		} else {
			RHCoef[day]<- AFGen (RHCoefRc, W[day])
		}		

		Rc[day] <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, wth@w$tavg[day]) * RHCoef[day]
			
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
	}

	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Rinfection, Rtransfer, RGrowth, RSenesced, Severity)
	res <- as.data.frame(res[1:day,])
	dates <- seq(emergence, emergence+duration, 1)
	res <- cbind(dates[1:day], res)
	colnames(res) <- c("date", "sites", "latent", "infectious", "removed", "diseased", "senesced", "rateinf", "rtransfer", "rgrowth", "rsenesced", "severity")

	result <- new('SEIR')
	result@d <- res
	return(result)
}

