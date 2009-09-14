\name{sheathBlight}
\alias{sheathBlight}
\alias{sheathBlight_v1}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ STELLA-R Sheath Blight Model }
\description{
 A dynamic mechanistic simulation of rice sheath blight disease. The model is driven by daily weather data. 
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
  \item{rainlim}{threshold to decide whether leaves are wet or not}
  \item{wetness}{simulate RHmax or rain threshold (0) or leaf wetness duration (1)} 
}

\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ 
Savary, S., Castilla, N.P., Willocquet, L. 2001. Analysis of the spatio-temporal structure of rice sheath blight epidemics in a farmer's field. Plant Pathology 50:53-68.
Savary, S., Willocquet, L., Teng, P.S., 1997. Modelling sheath blight epidemics on rice tillers. Agricultural Systems 55:359-384.
Castilla, N.P., Leano, R.M., Elazegui, F.A., Teng, P.S., Savary, S., 1996. Effects of plant contacts, inoculation pattern, leaf wetness regime, and nitrogen supply on inoculum efficiency in rice sheath blight. Journal of Phytopathology 144:187-192.
Sharma, N.R., Teng, P.S., Olivares, F.M., 1990. Effect of rice growth stage on sheath blight (ShB) development and yield loss. International Rice Research Newsletter 15:19-20.
Hashiba, T. and Ijiri, T., 1989. Estimation of yield loss and computerized forecasting system (BLIGHTAS) for rice sheath blight disease. International Symposium on Tropical Agricultural Research: Crop losses due to disease outbreaks in the tropics and countermeasures. Tropical Agricultural Research Series (Japan) No. 22 pp. 163-171.
Tu, C.C., Chang, Y.C., Wang, C.W., 1979. Studies on the ecology of Rhizoctonia solani, the causal organism of rice sheath blight. Natl. Sci. Counc. Monthly, ROC 7:1208-1219.
Gross, M.K., Santini, J.B., Tikhonova, I. and Latin, R. 1998. The influence of temperature and leaf wetness duration on infection of perennial ryegrass by Rhizoctonia solani. Plant Disease 82:1012-1016.
}
\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }
\note{ ~~further notes~~ 

 
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
