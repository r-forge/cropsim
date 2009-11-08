# Author: Serge Savary & Rene Pangga. 
# Translated from STELLA LeafBlastMod v5T and LeafBlastMod v5W by Robert J. Hijmans, Rene Pangga, & Jorrel Aunario  
# r.hijmans@gmail.com 
# International Rice Research Institute
# Date :  10 June 2009
# Version 0.2
# Licence GPL v3

# wetness = 1 uses leaf wetness duration corresponding to  STELLA LeafBlastMod v5W vs. 
# wetness = 0 uses RH + rain threshold corresponding to  STELLA LeafBlastMod v5T 

oldleafBlast <- function(wth, emergence='2000-05-15', onset=15, duration=120, rhlim=90, rainlim=5, wetness=0, rc=1.14, latrans=5, inftrans=20) {
	emergence <- as.Date(emergence)
	wth@w <- subset(wth@w, wth@w$date >= emergence)
	if (dim(wth@w)[1] < duration) {	stop("Incomplete weather data") }
	wth@w <- wth@w[1:duration,]
	
	if (wetness == 1) {
		W <- leafWet(wth, simple=TRUE)
	}
	
	# constants
	RRG <- 0.1
	RRPhysiolSenesc <- 0.01
	SenescType <- 1	
	AGGR <- 1
	BaseRc <- rc
	Sitemax <- 30000
	initInfection <- 1
	initSites <- 600
	infectious_transit_time <- inftrans
	latency_transit_time <- latrans

	# outputvars
	TotalSites <- rep(0, times=duration)
	COFR <- Rc <- RHCoef <- latency <- infectious <- Severity <- RSenesced <- RGrowth <- Rtransfer <- Rinfection <- Diseased <- Senesced <- Removed <- now_infectious <- now_latent <- Sites <- TotalSites

	AgeCoefRc <- cbind(0:24 * 5, c(1, 1, 1, 0.9, 0.8, 0.7, 0.64, 0.59, 0.53, 0.43, 0.32, 0.22, 0.16, 0.09, 0.03, 0.02, 0.02, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01))
	TempCoefRc <- cbind(2:9 * 5, c(0, 0.5, 1, 0.6, 0.2, 0.05, 0.01, 0))
	RHCoefRc <- cbind (4 + (0:10) * 2, c(0, 0.02, 0.09, 0.19, 0.29, 0.43, 0.54, 0.63, 0.77, 0.88, 1.0))	
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
#	print(c(day, RHCoef[day]))	
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

