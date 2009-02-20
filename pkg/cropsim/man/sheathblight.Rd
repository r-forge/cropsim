\name{sheathBlight}
\alias{sheathBlight}
\alias{sheathBlight_v1}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sheathBlight(wth, emergence='2000-05-15', onset=30,  duration=120, rhlim=90, rainlim=5, wetness=0) 
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
  \item{rainlim}{threshold to decide whether leaves are wet or not}
  \item{wetness}{simulate RHmax or rain threshold (0) or wetness (1)} 
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

prectable <- cbind(0:10*12, c(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5))
rhmxtable <- cbind(0:10*12, c(99.0, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 96, 95.5, 96))
tmptable <- cbind(0:10*12, c(27.8, 27.8, 28, 27.9, 27.8, 27.8, 27.8, 27.7, 27.7, 27.7, 27.5))
lfwttable <- cbind (0:10*12, rep(24, 11))

dur <- 120
prec <- vector (length=dur)
rhmx <- vector(length=dur)
tmp  <- vector(length=dur)
lfwt <- vector(length=dur)
day  <- seq(as.Date('2000-5-15'), len = dur, by = "1 day")

for (d in 1:dur) {
	rhmx[d] <- AFGen(rhmxtable, d)
	tmp[d] <- AFGen(tmptable, d)
	prec[d] <- AFGen(prectable, d)
    lfwt[d] <- AFGen(lfwttable, d)
}	
tmin <- tmp - 5
tmax <- tmp + 5
wth <- as.data.frame(cbind(tmin, tmax, rhmx, prec, lfwt))
wth$day <-day

res <- as.data.frame(sheathBlight(wth, duration=120, onset=30))
splot2(res)
}
\keyword{ spatial }
