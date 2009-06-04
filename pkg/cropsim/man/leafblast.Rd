\name{leafBlast}
\alias{leafBlast}
\alias{leafBlast_v1}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ STELLA-R Leaf Blast Model }
\description{
  A dynamic mechanistic simulation of rice leaf blast. The model is driven by daily weather data. 
}
\usage{
leafBlast(wth, emergence='2000-05-15', onset=15, duration=120, rhlim=90, rainlim=5, wetness=0, rc=1.14, latrans=5, inftrans=20) 
leafBlast_v1(tmp, rh, duration=120, startday=1) 
}

\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}
  \item{rhlim}{threshold to decide whether leaves are wet or not}
  \item{tmp}{ temperature }
  \item{rh}{ relative humidity }
  \item{startday}{ start day of simulation }
  \item{rainlim}{threshold to decide whether leaves are wet or not}
  \item{wetness}{simulate RHmax or rain threshold (0) or wetness (1)}
  \item{rc}{ corrected basic infection rate }
  \item{latrans}{ latent period }
  \item{inftrans}{ infectious period }
}

\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ 
Hwang B.K., Koh, Y.J., Chung, H.S., 1987. Effects of adult-plant resistance on blast severity and yield of rice. Plant Disease 71:1035-1038. 
Hemmi, T., Abe, T., Ikaya, J., and Inoue, Y. 1936. Studies on the rice blast disease. IV. Relation of the environment to the development of blast disease and physiologic specialization in the rice blast fungus. Materials for Rural Improvement, Department of Agriculture and Forestry, Japan No. 105, 145p.
Kato, H and Kozaka, T., 1974. Effect of temperature on lesion enlargement and sporulation of Pyricularia oryzae in rice leaves. Phytopathology 64:828-830.
Torres, C.Q., 1986. Effect of plant age on the expression of resistance to Pyricularia oryzae Cav. in upland rice varieties. PhD Thesis, University of the Philippines at Los Baños, 82 p.
El Refaei, M.I., 1977. Epidemiology of rice blast disease in the tropics with special reference to the leaf wetness in relation to disease development. PhD Thesis, Indian Agricultural Research Institute, New Delhi, 195 p.
Luo Wei-Hong, 1996. Simulation  and measurement of leaf wetness formation in paddy rice crops. PhD Thesis, Wageningen Agricultural University, 87 p.
}
\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }
\note{ ~~further notes~~ 

 
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

prectable <- cbind(0:10*12, c(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5))
rhmxtable <- cbind(0:10*12, c(99, 97, 100, 97.5, 97.5, 96.5, 96.5, 98.5, 96.5, 97.5, 97.5))
tmptable <- cbind(0:10*12, rep(20, 11))
lfwttable <- cbind (0:10*12, rep(18, 11))

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


res <- as.data.frame(leafBlast(wth, onset=15, duration=120))

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

		res <- leafBlast(wth)
		raudpc <- sum(res[,6]) / 120
		m[rhc, tc] <- raudpc
	}
}
contour(rhrange, tmprange, m, xlab="Relative humidity (perc)", ylab="Temperature (C)", labcex = 1, col = (terrain.colors(14)), lwd=2 )

}
\keyword{ spatial }
