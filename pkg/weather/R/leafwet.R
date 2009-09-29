# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

eLW <- function(rhmin, rhmax, tmin) {
    ewhr <- exp(-8.093137318+0.11636662*rhmax-0.03715678*rhmin+0.000358713*rhmin*rhmin)
    if (rhmin < 52) {
      ewhr52 <- exp(-8.093137318+0.11636662*rhmax-0.03715678*52+0.000358713*52*52);
      ewhr <- ewhr52 - (ewhr - ewhr52);
	}
    ewhr <- max(0, min(ewhr, 24))
    if (tmin < 0) {ewhr <- 0}
	return(ewhr)
}


LeafWet <- function(lat, date, rhavg, tmin, tmax, simple=TRUE) {
	lw <- vector()
	for (d in 1:length(date)) {
		rh <- diurnalRH(lat, date[d], rhavg[d], tmin[d], tmax[d], tavg=(tmin[d]+tmax[d])/2)
		if (simple) {
			lw[d] <- length(rh[rh>=90])
		} else {
			w <- rh
			x <- (rh - 80) / (95 - 80)
			w[rh > 95] <- 1
			w[rh < 95] <- x[rh < 95]
			w[rh < 80] <- 0
			lw[d] <- sum(w)
		}
	}
	return(lw)
}


LeafWetWithRain <- function(lat, date, rhavg, tmin, tmax, prec, simple=TRUE) {
	lw <- LeafWet(lat, date, rhavg, tmin, tmax, simple=simple)
	prec[is.na(prec)] <- 0 
	prhrs <- pmin(12, prec / 5)
	return(lw + (1 - lw/24) * prhrs)
}


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
	return(6.1 + 0.27*temp + 0.024*temp*temp)
}


diurnalTemp <- function(lat, date, tmin, tmax) {
	TC<-4.0
    P<-1.5
	dayl <- daylength(lat, doyFromDate(date))
	nigthl <- 24-dayl
    sunris <- 12 - 0.5 * dayl
    sunset <- 12 + 0.5 * dayl
	hrtemp <- vector(length=24)
	for (hr in 1:24) {
#    period a: dhour between midnight and sunrise;
		if ( hr < sunris)  {
			tsunst <- tmin+(tmax-tmin)*sin(pi*(dayl/(dayl+2*P)))
			hrtemp[hr] <- (tmin-tsunst*exp(-nigthl/TC)+(tsunst-tmin)*exp(-(hr+24-sunset)/TC))/(1-exp(-nigthl/TC))
		} else if ( hr < (12+P) ) {
#  period b: dhour between sunrise and normal time that tmax is reached (after noon)
			hrtemp[hr] <- tmin+(tmax-tmin)*sin(pi*(hr-sunris)/(dayl+2*P))
		} else if (hr < sunset) {
#  period c: dhour between time of tmax and sunset;
			hrtemp[hr] <- tmin+(tmax-tmin)*sin(pi*(hr-sunris)/(dayl+2*P))
		} else {
#  period d: dhour between sunset and midnight;
			tsunst <- tmin+(tmax-tmin)*sin(pi*(dayl/(dayl+2*P)))
			hrtemp[hr] <- (tmin-tsunst*exp(-nigthl/TC)+(tsunst-tmin)*exp(-(hr-sunset)/TC))/(1-exp(-nigthl/TC))
		}
	}
	return(hrtemp)
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


