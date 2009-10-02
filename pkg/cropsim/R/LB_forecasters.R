# cropsim

# Potato late blight forecast models
# Model name: Hyre
# Hyre, R. A. 1954. Progress in forecasting late blight of potato and tomato. Plant Disease Reporter. 38: 245-253.

# R implementation by Robert Hijmans, r.hijmans@gmail.com
# October 2009

# Days are considered blight favorable when the 5-day average temperature 
# is below 25.5 C and the total rainfall for the last 10 days is 3 cm or greater. 
# Days with minimum temperatures below 7.2 C are considered unfavorable.

# Source: http://www.ipm.ucdavis.edu/DISEASE/DATABASE/potatolateblight.html#hyre	

.getwth <- function(wth, emergence='2000-05-15', duration=120) {
	emergence <- as.Date(emergence)
	wth@w <- subset(wth@w, wth@w$date >= emergence)
	if (dim(wth@w)[1] < duration) {
		stop("Incomplete weather data")
	}
	wth@w <- wth@w[1:duration,]
	wth
}


.cumulate <- function(x) {
	xx <- vector(length=length(x))
	xx[1] <- x[1]
	for (i in 2:length(x)) {
		xx[i] <- xx[i-1] + x[i]
	}
	xx
}


Hyre <- function(wth, emergence='2000-05-15', duration=120) {
	w <- .getwth(wth, emergence, duration)@w
	t5 <- movingFun(w$tavg, 5) / 5
	p10 <- movingFun(w$prec, 10)
	blightFavorable <- t5 < 25.5 & w$tavg > 7.2 & p10 > 30
	cbind(as.data.frame(w$date), blightFavorable)
}


Wallin <- function(wth, emergence='2000-05-15', duration=120) {

	wth <- .getwth(wth, emergence, duration)
	leafwet <- leafWet(wth)
	w <- wth@w
	t1 <- w$tavg > 7.2 & w$tavg <= 11.6
	t2 <- w$tavg > 11.6 & w$tavg <= 15.0
	t3 <- w$tavg > 15.0 & w$tavg <= 26.6
	sv <- vector(length=duration)
	sv[ leafwet == 0 & t1 ] <- 15
	sv[ leafwet == 0 & t2 ] <- 12
	sv[ leafwet == 0 & t3 ] <- 9
	sv[ leafwet == 1 & t1 ] <- 17
	sv[ leafwet == 1 & t2 ] <- 14
	sv[ leafwet == 1 & t3 ] <- 11
	sv[ leafwet == 2 & t1 ] <- 20
	sv[ leafwet == 2 & t2 ] <- 19
	sv[ leafwet == 2 & t3 ] <- 14
	sv[ leafwet == 3 & t1 ] <- 23
	sv[ leafwet == 3 & t2 ] <- 20
	sv[ leafwet == 3 & t3 ] <- 17
	sv[ leafwet == 4 & t1 ] <- 25
	sv[ leafwet == 4 & t2 ] <- 22
	sv[ leafwet == 4 & t3 ] <- 19
	cumSeverity <- .cumulate(sv)
	x <- which(cumSeverity > 19) + 10
	x <- subset(x, x <= duration)
	Action <- vector(length=length(sv))
	Action[] <- FALSE
	Action[x] <- TRUE
	cbind(as.data.frame(w$date), cumSeverity, Action )
}


