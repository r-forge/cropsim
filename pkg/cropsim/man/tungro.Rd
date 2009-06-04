\name{tungro}
\alias{tungro}


%- Also NEED an '\alias' for EACH other topic documented here.
\title{ STELLA-R Rice Tungro Disease Model }
\description{
 A dynamic mechanistic simulation of rice tungro disease. The model is driven by daily weather data. 
}
\usage{
tungro(wth, emergence='2000-05-15', onset=25, duration=120, rhlim=0, rainlim=0, wetness=0) 

}
\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}  
  \item{rhlim}{threshold to decide whethere leaves are wet or not}
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
Tiongco, E.R., Cabunagan, R.C., Flores, Z.M., Hibino, H., and Koganezawa, H., 1993. Serological monitoring of rice tungro disease development in the field: its implication in disease management. Plant Disease 77:877-882.
Rivera, C.T. and Ou, S.H., 1965. Leafhopper transmission of tungro disease of rice. Plant Disease Reporter 49:127-131.
Ling, K.C., Palomar, M.K., 1966. Studies on rice plants infected with the tungro virus at different ages. Philippines Agriculturist 50:165-177.
Ling, K.C., and Tiongco, E.R., Effect of temperature on the transmission of rice tungro virus by Nephotettix virescens. Philippine Phytopathology 11:46-57.
}
\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }
\note{ ~~further notes~~ 

 
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

prectable <- cbind(0:10*12, c(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5))
rhmxtable <- cbind(0:10*12, c(99, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96))
tmptable <- cbind(0:10*12, c(31.5, 31.3, 31.3, 31.5, 31.5, 31.5, 31.3, 31.3, 31.4, 31.4, 31.5))
lfwttable <- cbind (0:10*12, rep(24, 11))

dur <- 120
rhmx <- vector(length=dur)
tmp  <- vector(length=dur)
prec <- vector(length=dur)
lfwt <- vector(length=dur)
day  <- seq(as.Date('2000-5-15'), len = dur, by = "1 day")

for (d in 1:dur) {
	prec[d] <- AFGen(prectable, d)
	rhmx[d] <- AFGen(rhmxtable, d)
	tmp[d] <- AFGen(tmptable, d)
	lfwt[d] <- AFGen(lfwttable, d)
}	
tmin <- tmp - 5
tmax <- tmp + 5
wth <- as.data.frame(cbind(tmin, tmax, rhmx, prec, lfwt))
wth$day <-day

res <- as.data.frame(tungro(wth, duration=120, onset=25))
splot2(res)


}
\keyword{ spatial }
