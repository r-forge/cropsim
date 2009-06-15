\name{brownSpot}
\alias{brownSpot}

\title{ STELLA-R Brown Spot model}
\description{
A dynamic mechanistic simulation of rice brown spot disease. The model is driven by daily weather data. 
}
\usage{
brownSpot(wth, emergence='2000-05-15', onset=20, duration=120, rhlim=90, rainlim=5, wetness=0) 
 
}
\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}  
  \item{rhlim}{threshold to decide whether leaves are wet or not}
  \item{rainlim}{threshold to decide whether leaves are wet or not due to rain}
  \item{wetness}{switch to simulate leaf wetness duration (1) or use RH max or rain threshold (0)}
}

\value{
  ...
}

\references{ 
Klomp, A.O., 1977. Early senescence of rice and Dreschslera oryzae in the Wageningen polder, Surinam. PhD thesis, 97p.
Levy, Y. and Cohen, Y., 1980. Sporulation of Helminthosporium turcicum on sweet corn: Effects of temperature and dew period. Canadian Journal of Plant Pathology 2:65-69.
Padmanabhan, S.Y. and Ganguly, D. 1954. Relation between the age of rice plant and its susceptibility to Helminthosporium and blast disease. Proceedings of the Indian Academy of Sciences B 29:44-50.
Sarkar, A.K. and Sen Gupta, P.K., 1977. Effect of temperature and humidity on disease development and sporulation of Helminthosporium oryzae on rice. Indian Phytopathology 30:258-259.
Luo Wei-Hong, 1996. Simulation  and measurement of leaf wetness formation in paddy rice crops. PhD, Wageningen Agricultural University, 87 p.
Waggoner. P.E., Horsfall, J.G., and Lukens, R.J. 1972. EPIMAY. A Simulator pf Southern Corn Leaf Blight. Bulletin of the Connecticut Experiment Station, New Haven, 85 p.
}

\author{ Serge Savary, Ireneo Pangga, Robert Hijmans, Jorrel Khalil Aunario }


\examples{
prectable <- cbind(0:10*12, c(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5))
rhmxtable <- cbind(0:10*12, c(99, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96.0))
tmptable <- cbind(0:10*12, rep(25, 11))
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
#	precint[d] <- AFGen(precinttable ,d)
    lfwt[d] <- AFGen(lfwttable, d)
#	w <- ewhr[d] + ((1+ewhr/24) * precint[d])
}	

#rh <- round(rh)
tmin <- tmp - 5
tmax <- tmp + 5
wth <- as.data.frame(cbind(tmin, tmax, rhmx, prec, lfwt))
wth$day <-day

res <- as.data.frame(brownSpot(wth, onset=20, duration=120))
splot2(res)


# example runs to create contour plot
rhrange <- 1:10 * 3 + 70
tmprange <- 1:4 * 3 + 14
m <- matrix(NA, length(rhrange), length(tmprange))

rhc <- 0
for (r in rhrange) {
	rhc <- rhc + 1
	tc <- 0
	for (t in tmprange) {
		tc <- tc + 1
		rhmx <- rep(r, 120)
		tmp <- rep(t, 120)
		tmin <- tmp-3
		tmax <- tmp+3
		day <- seq(as.Date("2000-5-15"), len=dur, by="1 day")
		wth <- as.data.frame(cbind(tmin,tmax,rhmx, prec, lfwt))
		wth$day <- day
		res <- brownSpot(wth, onset=20)
		raudpc <- sum(res[,6]) / 120
		m[rhc, tc] <- raudpc
	}
}
contour(rhrange, tmprange, m, xlab="Relative humidity (perc)", ylab="Temperature (C)", labcex = 1, col = (terrain.colors(14)), lwd=2 )

}
\keyword{ spatial }
