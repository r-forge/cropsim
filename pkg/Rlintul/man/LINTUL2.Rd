\name{lintul2}

\alias{lintul2}
\alias{lintul2_crop}
\alias{lintul2_soil}
\alias{crop<-,Rcpp_Lintul2Model-method}
\alias{soil<-,Rcpp_Lintul2Model-method}
\alias{weather<-,Rcpp_Lintul2Model-method}
\alias{control<-,Rcpp_Lintul2Model-method}
\alias{run,Rcpp_Lintul2Model-method}

\title{
LINTUL2 crop growth model
}

\description{
LINTUL is a relatively simple crop growth simulation model
}

\usage{
lintul2(crop, weather, soil, control)
lintul2_crop()
lintul2_soil()
\S4method{crop}{Rcpp_Lintul2Model}(x)<-value
\S4method{soil}{Rcpp_Lintul2Model}(x)<-value
\S4method{control}{Rcpp_Lintul2Model}(x)<-value
\S4method{weather}{Rcpp_Lintul2Model}(x)<-value
\S4method{run}{Rcpp_Lintul2Model}(x, ...)
}

\arguments{
 \item{x}{Rcpp_Lintul2Model object}
 \item{crop}{list with named crop parameters. See Details. An example is returned by \code{lintul2_crop()}} 
 \item{soil}{list with named soil parameters. See Details. An example is returned by \code{lintul2_soil()}} 
 \item{control}{list with named control parameters} 
 \item{weather}{data.frame with daily weather data} 
 \item{value}{a list with crop or control parameters, or a data.frame with weather data. As above}
 \item{...}{additional arguments. None implemented}
}

\value{
matrix
}

\references{
???
}


\examples{

m <- lintul2()
emerg=as.Date('2012-04-01')
contr <- list(emergence=emerg, start=emerg-30, maxdur=200)

crop(m) <- lintul2_crop()
soil(m) <- lintul2_soil()
control(m) <- contr
weather(m) <- default_weather()

m$run()

\dontrun{
# test LINTUL2

f1 <- system.file("lintul/test/2/res.dat", package="Rlintul")
s <- readLIN1output(f1)
f2 <- system.file("weather/Netherlands_Wageningen.csv", package="meteor")
wth <- read.csv(f2)
wth$date <- as.Date(wth$date)
wth$srad <- wth$srad / 1000

crop <- lintul2_crop()
soil <- lintul2_soil()

sdate <- dateFromDoy(58, 1971)
contr <- list(emergence=sdate+2, start = sdate, long_output=TRUE)
x <- lintul2(crop, wth, soil, contr)

plot(s[,'TIME'], s[,'LAI'], type='l')
points(x[, 'step']+58, x[, 'LAI'])

plot(s[,'TIME'], s[,'WSO'], type='l')
points(x[, 'step']+58, x[, 'WSO'])
}

}

