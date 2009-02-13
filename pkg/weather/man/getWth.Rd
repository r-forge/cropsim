\name{Get weater data}
\alias{AccessGetWthXY}
\alias{AccessGetWthCell}
\alias{DBgetWthXY}
\alias{DBgetWthCell}
\alias{DBgetWthCellNoDSN}
\alias{getWthXY}


\title{ Get weather data }
\description{
  Get weather data from a database
}
\usage{
getWthXY(lon, lat, start="1993-1-1", end="2009-12-31") 
AccessGetWthXY(database, table, lon, lat, rst=raster()) 
AccessGetWthCell(database, table, cell) 
DBgetWthXY(database, table, lon, lat, rst=raster()) 
DBgetWthCell(database, table, cell)
DBgetWthCellNoDSN(table, cell, user, pwd, driver="MySQL ODBC 5.1 Driver", server="geo.irri.org", database="nasa") 
}

\arguments{
  \item{lon}{ Latitude }  
  \item{lat}{ Longitude }    
  \item{start}{ First date }    
  \item{end}{ Late date }  
  \item{database}{ }
  \item{table}{ }  
  \item{rst}{ Describe \code{x} here }  
  \item{cell}{ Describe \code{x} here }
  \item{user}{ Describe \code{x} here }
  \item{pwd}{ Describe \code{x} here }
  \item{driver}{ Describe \code{x} here }
  \item{server}{ Describe \code{x} here }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
}
\keyword{ spatial }
