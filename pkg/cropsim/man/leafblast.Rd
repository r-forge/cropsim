\name{leafBlast}
\alias{leafBlast}
\alias{leafBlast_v1}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
leafBlast(wth, emergence='2000-05-15', onset=1, duration=120, rhlim=90) 
leafBlast_v1(tmp, rh, duration=120, startday=1) 
}

\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}  
  \item{rhlim}{threshold to decide whethere leaves are wet or not}
  \item{tmp}{ Describe \code{xy} here }
  \item{rh}{ Describe \code{xy} here }
  \item{startday}{ Describe \code{x} here }
}

\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

rhtable <- cbind(0:10*12, c(99, 97, 100, 97.5, 97.5, 96.5, 96.5, 98.5, 96.5, 97.5, 97.5))
tmptable <- cbind(0:10*12, rep(20, 11))

dur <- 120
relh <- vector(length=dur)
tmp  <- vector(length=dur)
day  <- seq(as.Date('2000-5-15'), len = dur, by = '1 day')
for (d in 1:dur) {
	relh[d] <- AFGen(rhtable, d)
	tmp[d] <- AFGen(tmptable, d)
}	
#rh <- round(rh)
tmin <- tmp - 5
tmax <- tmp + 5
wth <- as.data.frame(cbind(tmin, tmax, relh))
wth$day <-day

res <- as.data.frame(leafBlast(wth, duration=120, onset=15))

# example runs to create contour plot
rhrange <- 1:10 * 3 + 70
tmprange <- 1:4 * 3 + 14
m <- matrix(NA, length(rhrange), length(tmprange))

day  <- seq(as.Date('2000-5-15'), len = 120, by = "1 day")

rhc <- 0
for (r in rhrange) {
	rhc <- rhc + 1
	tc <- 0
	for (t in tmprange) {
		tc <- tc + 1
		relh <- rep(r, 120)
		tmp <- rep(t, 120)
		tmin <- tmp - 5
		tmax <- tmp + 5
		wth <- as.data.frame(cbind(tmin, tmax, relh))
		wth$day <-day

		res <- leafBlast(wth)
		raudpc <- sum(res[,6]) / 120
		m[rhc, tc] <- raudpc
	}
}
contour(rhrange, tmprange, m, xlab="Relative humidity (perc)", ylab="Temperature (C)", labcex = 1, col = (terrain.colors(14)), lwd=2 )

}
\keyword{ spatial }
