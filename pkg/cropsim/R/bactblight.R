
# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans , Rene Pangga & Jorrel Aunario, r.hijmans@gmail.com (translated from STELLA BLBMod v6.1)
# International Rice Research Institute
# Date :  2 February 2009
# Version 0.1
# Licence GPL v3


bactBlight <- function(tmp, rh, duration=120, startday=1, rhlim=90) {
#    tmp <- (wth$tmax + wth$tmin) / 2
#	rh <- wth$rh
	RRG <- 0.1
	RRPhysiolSenesc <- 0.01
	SenescType <- 1	
	AGGR <- 4
	BaseRc <- 0.87
	Sitemax <- 3200
	initInfection <- 1
	initSites <- 100


	infectious_transit_time <- 30
	infectious <- vector(length=duration)
	infectious[] <- 0
	now_infectious <- vector(length=duration)
	now_infectious[] <- 0
	latency_transit_time <- 5
	latency <- vector(length=duration)
	latency[] <- 0
	now_latent <- vector(length=duration)
	now_latent[] <- 0
	Removed <- vector(length=duration)
	Removed[] <- 0
	Diseased <- vector(length=duration)
	Diseased[] <- 0
	Sites <- vector (length=duration)
	Sites[] <- 0
	Incidence <- vector (length=duration)
	Incidence[] <- 0
	
	AgeCoefRc <- cbind(0:12 * 10, c( 1, 1, 1, 0.9, 0.62, 0.43, 0.41, 0.42, 0.41, 0.41, 0.41, 0.41, 0.41))
	
	RHCoefRc  <- rh
	RHCoefRc[] <- 0
	RHCoefRc[rh >= rhlim] <- 1
 	
	TempCoefRc <- cbind(18.5 + (0:4 * 3.125), c(0.29, 0.44, 0.90, 0.90, 1.0))

	RcAgeTemp <- vector (length=duration)
	
	Rtransfer <- 0
	Rinfection <- 0
	COFR <- 1
	Senesced <- 0
	MatPer <- 20
	
	for (day in 1:duration) {
			
	# State calculations
		if (day==1) {
		# start crop growth 
			Sites[day] <- initSites
			Sites[day] <- 108.69
		}
		infectious[day] <- Rtransfer
				
 		latency[day] <- Rinfection
		latday <- day - latency_transit_time + 1
		latday <- max(1, latday)
		now_latent[day] <- sum(latency[latday:day])
		
		infday <- day - infectious_transit_time + 1
		infday <- max(1, infday)
		now_infectious[day] <- sum(infectious[infday:day])

		if (day > 1) {
#			Sites[day] <- Sites[day-1] + RGrowth - Rinfection 
# Or should it be:			
			Sites[day] <- Sites[day-1] + RGrowth - Rinfection - RSenesced

# consider natural senescence...
#			Sites[day] <- min(Sites[day], MatScen)
			Senesced[day] <- Senesced[day-1] + RSenesced
			if (Sites[day] < 0 ) { 
				Sites[day] <- 0
				break 
			}
		}
		
		Diseased[day] <- sum(infectious) + now_latent[day] + Removed[day]
		Removed[day] <- sum(infectious) - now_infectious[day]
		TotalSites <- Diseased[day] + Sites[day]
		
	# Rate calculations
		RcAgeTemp <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * RHCoefRc[day]
		Rinfection <- now_infectious[day] * RcAgeTemp * (COFR^AGGR)
		RGrowth <- RRG * Sites[day] * (1-(TotalSites/Sitemax))


# consider natural senescence...		
#		MatScen <- -1*(day*Sitemax/MatPer) + (Sitemax * duration/MatPer)
		
		if (day > infectious_transit_time) {
			removedToday <- infectious[infday-1]
		} else {
			removedToday <- 0
		}
		if (day==1){
			RSenesced <- removedToday * SenescType + RRPhysiolSenesc * initSites
			Senesced[day] <- RSenesced
		}

		RSenesced <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]		
		COFR <- 1-(Diseased[day]/(Sites[day]+Diseased[day]))

	# Boxcar transger to other staet 
		if (day >= latency_transit_time ) {	
			Rtransfer <- latency[latday]
		} else { 
			Rtransfer <- 0	
		}	
		
		if (day==startday) {
			Rinfection <- initInfection
		}		
		
	Incidence[day] <- (Diseased[day]-Removed[day])/(TotalSites - Removed[day])*100		
#	 print(c(day, infday, Rinfection, Rtransfer, RGrowth, RSenesced, infectious[day], now_infectious[day]))		
	}
	
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Incidence)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "incidence")
	return(res)
}

