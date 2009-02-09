\name{tungro}
\alias{tungro}


%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
tungro(wth, emergence='2000-05-15', onset=1,  duration=120, rhlim=90) 

}
\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}  
  \item{rhlim}{threshold to decide whethere leaves are wet or not}
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

rhtable <- cbind(0:10*12, c(99, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96))
tmaxtable <- cbind(0:10*10, rep(35,11))
tmintable <- cbind(0:10*12, c(27.88, 27.5, 27.63, 28, 27.88, 27.88, 27.63, 27.63, 27.75, 27.75, 27.88))
dur <- 120
relh <- vector(length=dur)
tmax  <- vector(length=dur)
tmin  <- vector(length=dur)
day  <- seq(as.Date('2000-5-15'), len=dur, by='1 day')

for (d in 1:dur) {
	relh[d] <- AFGen(rhtable, d)
	tmax[d] <- AFGen(tmaxtable, d)
	tmin[d] <- AFGen(tmintable, d)
}	
	
#rh <- round(rh)
wth <- as.data.frame(cbind(relh, tmax, tmin))
wth$day <- day


res <- as.data.frame(tungro(wth, duration=120, onset=25, rhlim=1))
splot2(res)


}
\keyword{ spatial }
