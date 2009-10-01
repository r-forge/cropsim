\name{simriw}

\alias{simriw}


\title{ Rice simulation model}

\description{
  Get weather data from a NASA website
}


\usage{
simriw(wth, cultivar, startday, transplant=FALSE, CO2=350)
}

\arguments{
  \item{wth}{ object of class 'weather' }  
  \item{cultivar}{ object of class 'SIMRIWcultivar' }    
  \item{startday}{ planting or transplanting date }    
  \item{transplant}{Logical }  
  \item{CO2}{ CO2 concentration }    
}



\references{
Horie, T., Nakagawa, H.N., Centeno, H.G.S., Kropff, M.J. (1995). The rice simulation model SIMRIW and its testing. In: R.B. Matthews, M.J. Kropff, D. Bachelet & H.H. van Laar (Eds), Modeling the impact of climate change on rice production in Asia. CABI, UK, IRRI, Philippines, pp. 95-139.
}


\value{
 An object of class 'SIMRIW'
}

\author{ Robert J. Hijmans }

\examples{
wth <- getWthFile(system.file("weather/daily_weather_28368.nasa", package = "cropsim"))
sim <- simriw(wth, SIMRIWcultivar('Nipponbare'), startday='2000-05-15')
sim
plot(sim)
}