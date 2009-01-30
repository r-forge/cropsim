
# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans & Rene Pangga, r.hijmans@gmail.com (translated from STELLA TungroMod v5)
# International Rice Research Institute
# Date :  30 January 2009
# Version 0.1
# Licence GPL v3


tungro <- function(tmp, rh, duration=120, startday=1, rhlim=1) {
#    tmp <- (wth$tmax + wth$tmin) / 2
#	rh <- wth$rh
	RRG <- 0.1
#	RRPhysiolSenesc <- 0.01
#	SenescType <- 1	
	AGGR <- 1
	BaseRc <- 0.18
	Sitemax <- 100
	initInfection <- 1
	initSites <- 100


	infectious_transit_time <- 120
	infectious <- vector(length=duration)
	infectious[] <- 0
	now_infectious <- vector(length=duration)
	now_infectious[] <- 0
	latency_transit_time <- 6
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
	
	AgeCoefRc <- cbind (0:8 * 15, c(1.0, 1.0, 0.98, 0.73, 0.51, 0.34, 0, 0, 0))
	
	RHCoefRc  <- rh
	RHCoefRc[] <- 0
	RHCoefRc[rh >= rhlim] <- 1
 	
	TempCoefRc <- cbind (10 + (0:9 * 3.1111), c(0.13, 0.65, 0.75, 0.83, 0.89, 0.93, 0.97, 1.0, 0.96, 0.93))

	RcAgeTemp <- vector (length=duration)
	
	Rtransfer <- 0
	Rinfection <- 0
	COFR <- 1
#	Senesced <- 0
#	MatPer <- 20
	
	for (day in 1:duration) {
			
	# State calculations
		if (day==1) {
		# start crop growth 
			Sites[day] <- initSites
			Sites[day] <- 100
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
			Sites[day] <- Sites[day-1] + RGrowth - Rinfection

# consider natural senescence...
#			Sites[day] <- min(Sites[day], MatScen)
#			Senesced[day] <- Senesced[day-1] + RSenesced
#			if (Sites[day] < 0 ) { 
#				Sites[day] <- 0
#				break 
#			}
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
		
#		if (day > infectious_transit_time) {
#			removedToday <- infectious[infday-1]
#		} else {
#			removedToday <- 0
#		}
#		if (day==1){
#			RSenesced <- removedToday * SenescType + RRPhysiolSenesc * initSites
#			Senesced[day] <- RSenesced
#		}

#		RSenesced <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]		
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
		
		
#	 print(c(day, infday, Rinfection, Rtransfer, RGrowth, RSenesced, infectious[day], now_infectious[day]))		
	}
	
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased")
	return(res)
}

