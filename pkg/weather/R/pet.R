# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  July 2010

Thornthwaite <- function(tavg, lat=0) {
	# L <- avgMonthDaylength(lat)
	L <- rep(12, 12)
	tavg[tavg < 0] <- 0
	I <- sum((tavg/5)^1.514)
	alpha <- 6.75e-07 * I^3 - 7.71e-05 * I^2 + 1.79e-02 * I + 0.492
	PET <- 16 * L/12 * (10*tavg / I)^alpha

	# Willmott for > 26C
	i <- tavg > 26
	PET[i] <- -415.85 + 32.24*tavg[i] - 0.43*tavg[i]^2
	PET[tavg == 0] <- 0
	return(PET / 30)
}


Thornthwaite2 <- function(tmin, tmax, lat=0) {
	# L <- avgMonthDaylength(lat)
	L <- rep(12, 12)
	
	trange <- tmax - tmin
	Tef <- 0.35 * (3 * tmax - tmin)
	Tavg <- Tef * L / (24-L)	
	
	tavg[tavg < 0] <- 0
	I <- sum((tavg/5)^1.514)
	alpha <- 6.75e-07 * I^3 - 7.71e-05 * I^2 + 1.79e-02 * I + 0.492
	PET <- 16 * L/12 * (10*tavg / I)^alpha

	# Willmott for > 26C
	i <- tavg > 26
	PET[i] <- -415.85 + 32.24*tavg[i] - 0.43*tavg[i]^2
	PET[tavg == 0] <- 0
	return(PET / 30)
}


