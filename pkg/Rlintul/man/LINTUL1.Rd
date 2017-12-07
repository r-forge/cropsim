\name{lintul}

\alias{lintul1}
\alias{lintul1_crop}

\title{
LINTUL1 crop growth model
}

\description{
LINTUL1 is a relatively simple crop growth simulation model
}

\usage{
lintul1(crop, weather, control)
lintul1_crop()
}

\arguments{
\item{crop}{list. Crop parameters}
\item{weather}{data.frame with weather data}
\item{control}{list. Model control options}
\item{name}{character}
}

\value{
matrix
}

\references{
Spitters, C.J.T. and A.H.C.M. Schapendonk, 1990. Evaluation of breeding strategies for drought tolerance in potato by means of crop growth simulation. Plant and Soil 123: 193-203.
}


\examples{

library(Rlintul)
w <- default_weather()
crop <- lintul1_crop()
contr <- list(emergence=as.Date('2012-04-01'), maxstep=365, long_output=FALSE)

m <- Lintul1Model$new()
crop(m) <- crop
control(m) <- contr
#weather(m) <- w
m$setWeather(w, lon=0, lat=10, elevation=100)


\dontrun{
crop$RUE <- 3.5

contr <- list(emergence=as.Date('2012-04-01'), long_output=TRUE)
d <- lintul1(crop, wth, contr)

head(d)
tail(d)

date <- contr$emergence + d[,'step']
par(mfrow=c(1,2))
plot(date, d[,'LAI'])

wtot <- rowSums(d[,4:7])
plot(date, wtot, type='l', lwd=2)
lines(date, d[,4], col='green', lwd=2)
lines(date, d[,7], col='red', lwd=2)


dates <- as.Date(gsub(' ', '-', paste(2010, 1:12, 15)))
dates <- c(dates, dates + 365)
dates
contr$emergence <- dates
x <- lintul1(crop, w, contr)
head(x)
}

}

