\name{tungro}
\alias{tungro}

\title{Rice Tungro Disease Model }

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


\value{
  An object of class SEIR
}

\references{ 
Tiongco, E.R., Cabunagan, R.C., Flores, Z.M., Hibino, H., and Koganezawa, H., 1993. Serological monitoring of rice tungro disease development in the field: its implication in disease management. Plant Disease 77:877-882.
Rivera, C.T. and Ou, S.H., 1965. Leafhopper transmission of tungro disease of rice. Plant Disease Reporter 49:127-131.
Ling, K.C., Palomar, M.K., 1966. Studies on rice plants infected with the tungro virus at different ages. Philippines Agriculturist 50:165-177.
Ling, K.C., and Tiongco, E.R., Effect of temperature on the transmission of rice tungro virus by Nephotettix virescens. Philippine Phytopathology 11:46-57.
}

\author{ S. Savary, R. Hijmans, I. Pangga, J.K. Aunario }


\examples{
wth <- getWthFile(system.file("weather/daily_weather_28368.nasa", package = "cropsim"))
#res <- tungro(wth, duration=120, onset=25)
#plot(res)
}


\keyword{ spatial }
