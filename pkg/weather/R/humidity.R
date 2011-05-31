# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009


rhMinMax <- function(rhavg, tmin, tmax, tavg=(tmin+tmax)/2) {
	tmin <- pmax(tmin, -5)
	tmax <- pmax(tmax, -5)
	tavg <- pmax(tavg, -5)
    es <- saturatedVaporPressure(tavg)
	vp <- rhavg / 100 * es
    es <- saturatedVaporPressure(tmax)
    rhmin <- 100*vp/es;
	rhmin <- pmax(0, pmin(100, rhmin))
    es <- saturatedVaporPressure(tmin)
    rhmax <- 100*vp/es;
	rhmax <- pmax(0, pmin(100, rhmax))
	return(cbind(rhmin, rhmax))
}	



saturatedVaporPressure <- function(temp) {
	i <- which(temp >= 0)
	temp[i] <- 6.1 + 0.27*temp[i] + 0.024*temp[i]*temp[i]
	i <- which(temp < 0)
	temp[i] <- exp(0.0628979  * temp[i] +  1.7845445)                                  
	return(temp)
}

vaporPressureDeficit <- function(rh, tavg){
    svp <- saturatedVaporPressure(tavg)
    return((1-(rh/100))*svp)
}


FtoC <- function(x) {(5/9)*(x-32) }
CtoF <- function(x) { x*9/5 + 32 }

atmp <- function(alt) {
  101.325 * (1 - 2.25577 * 10^-5 * alt) ^ 5.25588   # kPa 
}

rel2abshum <- function(rh, t) {
	es <- saturatedVaporPressure(t)
	ea <- rh * es / 100
	M <- 18.02 # g/mol
	R <- 8.314472 # Pa·m³/(mol·K)
	T <- t + 273.15  # C to K
	hum <- ea*M/(T*R)
	return(hum)
}

abs2relhum <- function(hum, t) {
	M <- 18.02 # g/mol
	R <- 8.314472 # Pa·m³/(mol·K)
	T <- t + 273.15  # C to K
	ea <- hum / (M/(T*R))
	es <- saturatedVaporPressure(t)
	rh <- 100 * ea / es
	rh  <- pmin(rh, 100)
	return(rh)
}


spechum <- function(rh, t, alt) {
	es <- saturatedVaporPressure(t)
	ea <- rh * es / 100
	P <- atmp(alt)
	MR <- 0.622*ea/(P-ea)
	SH <- MR/(1+MR)
	return(SH)
}



diurnalRH <- function(lat, date, rhavg, tmin, tmax, tavg=(tmin+tmax)/2) {
	hrtemp <- diurnalTemp(lat, date, tmin, tmax) 
	vp <- saturatedVaporPressure(tavg) * rhavg / 100 
	hr <- 1:24
	es <- saturatedVaporPressure(hrtemp[hr])
	rh <- 100*vp/es
	rh <- pmin(100, pmax(0, rh))
	return(rh)
}

