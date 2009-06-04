\name{bactBlight}
\alias{bactBlight}


%- Also NEED an '\alias' for EACH other topic documented here.
\title{ STELLA-R Bacterial Blight Model }
\description{
  A dynamic mechanistic simulation of rice bacterial blight disease. The model is driven by daily weather data. 
}
\usage{
bactBlight(wth, emergence='2000-05-15', onset=20, duration=120, rhlim=90, rainlim=5, wetness=0) 
 
}
\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}  
  \item{rhlim}{threshold to decide whether leaves are wet or not}
  \item{rainlim}{threshold to decide whether leaves are wet or not}
  \item{wetness}{simulate RHmax or rain threshold (0) or wetness (1)}
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ 
Adhikari, T.B., 1991. Effects of rice genotype and environment on bacterial blight progression. PhD thesis, University of the Philippines at Los Baños, 143 p. 
Nayak, P., Suriya Rao, A.V., Chakrabarti, N.K., 1987. Components of resistance to bacterial blight disease of rice. Journal of Phytopathology 119:312-318.
Baw A. and Mew, T.W., 1988. Scoring systems for evaluating rice varietal resistance to bacterial blight (BB): lesion size by growth stage. International Rice Research Newsletter 13:10-11.
Luo Wei-Hong, 1996. Simulation  and measurement of leaf wetness formation in paddy rice crops. PhD, Wageningen Agricultural University, 87 p.
Horino, O., Mew, T.W., Yamada, T., 1982. The effect of temperature on the development of bacterial leaf blight on rice. Annals of the Phytopathological Society of Japan 48: 72-75
}
\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }
\note{ ~~further notes~~ 

 
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

prectable <- cbind(0:10*12, c(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5))
rhmxtable <- cbind(0:10*12, c(99, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96))
tmptable <- cbind(0:10*12, rep(28, 11))
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
#rh <- round(rh)
tmin <- tmp - 5
tmax <- tmp + 5
wth <- as.data.frame(cbind(tmin, tmax, rhmx, prec, lfwt))
wth$day <-day


res <- as.data.frame(bactBlight(wth, onset=30, duration=120))

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
		rhmx <- rep(r, 120)
		tmp <- rep(t, 120)
		tmin <- tmp - 5
		tmax <- tmp + 5
		wth <- as.data.frame(cbind(tmin, tmax, rhmx, prec, lfwt))
		wth$day <-day

		res <- bactBlight(wth)
		raudpc <- sum(res[,6]) / 120
		m[rhc, tc] <- raudpc
	}
}
contour(rhrange, tmprange, m, xlab="Relative humidity (perc)", ylab="Temperature (C)", labcex = 1, col = (terrain.colors(14)), lwd=2 )

}
\keyword{ spatial }
