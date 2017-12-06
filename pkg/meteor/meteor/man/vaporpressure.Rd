\name{vaporpressure}

\alias{SVP}
\alias{VP}
\alias{VPD}


\title{Vapor pressure}

\description{
Functions to compute the saturated vapor pressure, actual vapor pressure, and vapor pressure deficit in Pascal.
}

\usage{
SVP(temp, simple=FALSE)
VP(temp, relh, simple=FALSE)
VPD(temp, relh, simple=FALSE)
}


\arguments{
  \item{temp}{numeric. Temperature in degrees C}
  \item{simple}{Boolean. If \code{TRUE} saturated vapor pressure is computed as \code{610.8 * exp(17.27 * temp / (temp + 237.3)} is used. If \code{FALSE}, the equation by Goff (1957) is used, except if \code{temp < 0}, in which case the equation for ice by Goff and Gratch (1946) is used}
  \item{relh}{relative humidity (percent)}
}

\value{
numeric vector (Pascal).
}


\references{
Goff, J.A.,and S. Gratch, 1946. Low-pressure properties of water from -160 to 212 F. Transactions of the American society of heating and ventilating engineers, p. 95-122, presented at the 52nd annual meeting of the American society of heating and ventilating engineers, New York, USA.
Goff, J. A. 1957. Saturation pressure of water on the new Kelvin temperature scale, Transactions of the American society of heating and ventilating engineers, pp 347-354, presented at the semi-annual meeting of the American society of heating and ventilating engineers, Murray Bay, Quebec, Canada.
}

\author{
Robert Hijmans, based on Python meteolib by Maarten J. Waterloo and J. Delsman \url{http://python.hydrology-amsterdam.nl/}
}

\examples{
SVP(30, FALSE)
SVP(30, TRUE)
VP(30, 60)
VPD(30, 60)
}
