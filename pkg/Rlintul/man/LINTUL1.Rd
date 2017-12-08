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
contr <- list(emergence=as.Date('2012-04-01'), maxdur=200, long_output=FALSE)

m <- Lintul1Model$new()
crop(m) <- crop
control(m) <- contr
weather(m) <- w

m$run()

m$crop$RUE <- 3.5

m$control$emergence=as.Date('2012-04-01')
m$run()

m$out
out <- m$out

date <- as.Date(m$control$emergence, origin="1970-01-01") + out$step
par(mfrow=c(1,2))
plot(date, out$LAI)

prod <- cbind(out$WRT, out$WLV, out$WST, out$WSO)

wtot <- rowSums(prod)
plot(date, wtot, type='l', lwd=2)
lines(date, prod[,2], col='green', lwd=2)
lines(date, prod[,4], col='red', lwd=2)

}

