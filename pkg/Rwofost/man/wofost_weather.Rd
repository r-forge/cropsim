\name{wofost_weather}

\alias{wofost_weather}

\title{
Weather data for the WOFOST crop growth model
}

\description{
This functions returns a data.frame with weather data for the WOFOST crop growth model
}

\usage{
wofost_weather(lon, lat, folder=file.path(getwd(), 'power'), ...)
}

\arguments{
\item{lon}{numeric}
\item{lat}{numeric}
\item{folder}{character}
\item{...}{additional arguments}
}

\value{
data.frame
}


\examples{
w <- wofost_weather()
w$srad <- w$srad * 1000
wth <- subset(w, date > as.Date('2012-01-01'))

head(wth)
}
