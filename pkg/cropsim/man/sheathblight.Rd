\name{sheathBlight}
\alias{sheathBlight}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sheathBlight(wth, emergence='2000-05-15', onset=30,  duration=120, rhlim=90) 
}
\arguments{
  \item{wth}{ Describe \code{xy} here }
  \item{emergence}{ Describe \code{xy} here }
  \item{onset}{ Describe \code{x} here }
  \item{duration}{ Describe \code{x} here }  
  \item{rhlim}{ Describe \code{x} here }
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

rhtable <- cbind(0:10*12, c(99.0, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96))
tmaxtable <- cbind(0:10*12, rep(33,11))
tmintable <- cbind(0:10*12, c(22.63, 22.63, 22.88, 22.75, 22.5, 22.5, 22.5, 22.25, 22.38, 22.25, 22))
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

wth <- as.data.frame(cbind(relh, tmax, tmin))
wth$day <- day

res <- as.data.frame(sheathBlight(wth))
splot2(res)
}
\keyword{ spatial }
