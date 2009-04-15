
# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans , Rene Pangga & Jorrel Aunario, r.hijmans@gmail.com (translated from STELLA BLBMod v6.1)
# International Rice Research Institute
# Date :  23 F ebruary 2009
# Version 0.1
# Licence GPL v3
# comparison of wetness (wetness=1) vs. maximum RH + rain threshold (wetness=0)

tungro <- function(wth, emergence='2000-05-15', onset=1,  duration=120, rhlim=0, rainlim=0, wetness=0) {
	emergence <- as.Date(emergence)
	wth <- subset(wth, wth$day >= emergence)

#average temperature
	tmp <- (wth$tmax + wth$tmin) / 2
#maximum RH
	rhx <- wth$rhmx
#rain amount
	rain <- wth$prec
#wetness
	W <- wth$lfwt

	if (length(tmp) < duration) {
		print("Incomplete weather data")
		stop()
	}

	RRG <- 0.1
	RRPhysiolSenesc <- 0.01
	SenescType <- 1	
	AGGR <- 1
	BaseRc <- 0.18
	Sitemax <- 100
	initInfection <- 1
	initSites <- 100
	infectious_transit_time <- 120
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

	#parameters
	RHCoef <- vector(length=duration)
	RHCoef[] <- 0
	
    AgeCoefRc <- cbind (0:8 * 15, c(1.0, 1.0, 0.98, 0.73, 0.51, 0.34, 0, 0, 0))
	TempCoefRc <- cbind (c(9,10 + (0:9 * 3.1111),40), c(0,0.13, 0.65, 0.75, 0.83, 0.89, 0.93, 0.97, 1.0, 0.96, 0.93,0))
	RHCoefRc <- 1
	Rc <- vector (length=duration)
	Rc[] <- 0
	COFR <- vector(length=duration)
	COFR[] <- 0
	
	MatPer <- 20
	
	for (day in 1:duration) {
			
	# State calculations
		if (day==1) {
		# start crop growth 
			Sites[day] <- 100
			#RSenesced[day] <- RRPhysiolSenesc * Sites[day]
			#Senesced[day] <- RRPhysiolSenesc * initSites
		}
		else {
			if (day > infectious_transit_time) {
				removedToday <- infectious[infday+1]
			} else {
				removedToday <- 0
			}
			
			Sites[day] <- Sites[day-1] + RGrowth[day-1] - Rinfection[day-1]
			#RSenesced[day] <- removedToday * SenescType + RRPhysiolSenesc * Sites[day]
			#Senesced[day] <- Senesced[day-1] + RSenesced[day-1]
			
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
		RHCoef[day]<- RHCoefRc
		}		
		
		Rc[day] <- BaseRc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * RHCoef[day]
		
		Diseased[day] <- sum(infectious) + now_latent[day] + Removed[day]
		Removed[day] <- sum(infectious) - now_infectious[day]
		
		COFR[day] <- 1-(Diseased[day]/(Sites[day]+Diseased[day]))
		
		if (day==onset) {
			Rinfection[day] <- initInfection
		} else if (day > onset) {
			Rinfection[day] <- now_infectious[day] * Rc[day] * (COFR[day]^AGGR)
		} else {
			Rinfection[day] <- 0
		}
		
		# Boxcar transger to other staet 
		if (day >= latency_transit_time ) {	
			Rtransfer[day] <- latency[latday]
		} else { 
			Rtransfer[day] <- 0	
		}
		
		TotalSites[day] <- Diseased[day] + Sites[day]
		RGrowth[day] <- RRG * Sites[day] * (1-(TotalSites[day]/Sitemax))


# consider natural senescence...		
#		MatScen <- -1*(day*Sitemax/MatPer) + (Sitemax * duration/MatPer)
		Severity[day] <- (Diseased[day]-Removed[day])/(TotalSites[day] - Removed[day])*100		

	}
	
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased, Senesced, Rinfection, Rtransfer, RGrowth, RSenesced, Severity)
	res <- res[1:day,]
	#res <- Diseased / AllSites 
	res <- cbind(1:length(res[,1]), res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased", "senesced", "rateinf", "rtransfer", "rgrowth", "rsenesced", "severity")
	return(res)
}

