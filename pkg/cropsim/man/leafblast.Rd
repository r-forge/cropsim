\name{leafBlast}
\alias{leafBlast}


\title{Rice leaf blast disease}

\description{
  A dynamic mechanistic simulation of rice leaf blast. The model is driven by daily weather data. 
}

\usage{
leafBlast(wth, emergence='2000-05-15', onset=15, duration=120, rhlim=90, rainlim=5, wetness=0, rc=1.14, latrans=5, inftrans=20) 
}

\arguments{
  \item{wth}{daily weather data frame containing relative humidity (relh), minimum temeperature (tmin), and maximum temperature (tmax)}
  \item{emergence}{expected date of plant emergence}
  \item{onset}{expected number of days until the onset of disease after emergence date}
  \item{duration}{simulation duration}
  \item{rhlim}{threshold to decide whether leaves are wet or not}
  \item{rainlim}{threshold to decide whether leaves are wet or not}
  \item{wetness}{simulate RHmax or rain threshold (0) or leaf wetness duration (1)}
  \item{rc}{ corrected basic infection rate }
  \item{latrans}{ latent period }
  \item{inftrans}{ infectious period }
}

\value{
  An object of class 'SEIR'
}

\references{ 
Hwang B.K., Koh, Y.J., Chung, H.S., 1987. Effects of adult-plant resistance on blast severity and yield of rice. Plant Disease 71:1035-1038. 
Hemmi, T., Abe, T., Ikaya, J., and Inoue, Y. 1936. Studies on the rice blast disease. IV. Relation of the environment to the development of blast disease and physiologic specialization in the rice blast fungus. Materials for Rural Improvement, Department of Agriculture and Forestry, Japan No. 105, 145p.
Kato, H and Kozaka, T., 1974. Effect of temperature on lesion enlargement and sporulation of Pyricularia oryzae in rice leaves. Phytopathology 64:828-830.
Torres, C.Q., 1986. Effect of plant age on the expression of resistance to Pyricularia oryzae Cav. in upland rice varieties. PhD Thesis, University of the Philippines at Los Banos, 82 p.
El Refaei, M.I., 1977. Epidemiology of rice blast disease in the tropics with special reference to the leaf wetness in relation to disease development. PhD Thesis, Indian Agricultural Research Institute, New Delhi, 195 p.
Luo Wei-Hong, 1996. Simulation  and measurement of leaf wetness formation in paddy rice crops. PhD Thesis, Wageningen Agricultural University, 87 p.
}

\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }

\seealso{ \code{\link[cropsim]{brownspot}}, \link[cropsim]{sheatblight}  }

\examples{
wth <- getWthFile(system.file("weather/daily_weather_28368.nasa", package = "cropsim"))
res <- leafBlast(wth, onset=15, duration=120)
plot(res)
}


\keyword{ spatial }
