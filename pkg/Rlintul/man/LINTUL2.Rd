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
crop(x) <- value
soil(x) <- value
control(x) <- value
weather(x) <- value
run(x, ...)
}

\arguments{
 \item{x}{Rcpp_Lintul2Model object}
\S4method{crop}{Rcpp_Lintul2Model}(x)<-value
 \item{name}{character. crop name} 
\S4method{soil}{Rcpp_Lintul2Model}(x)<-value
\S4method{control}{Rcpp_Lintul2Model}(x)<-value
\S4method{weather}{Rcpp_Lintul2Model}(x)<-value
\S4method{run}{Rcpp_Lintul2Model}(x, ...)
 \item{value}{a list with crop, soil, or control parameters, or a data.frame with weather data. As above}
 \item{...}{additional arguments. None implemented}
}

\value{
matrix
}

\references{
Spitters, C.J.T. and A.H.C.M. Schapendonk, 1990. Evaluation of breeding strategies for drought tolerance in potato by means of crop growth simulation. Plant and Soil 123: 193-203.
}


\examples{
\dontrun{
w <- default_weather()
wth <- subset(w, date > as.Date('2012-01-01'))
crop <- lintul1_crop()
str(crop)

## LINTUL2
s <- lintul2_soil()
crp <- lintul2_crop()
contr <- list(emergence=as.Date('2012-04-01'), long_output=TRUE)
contr$start <- contr$emergence - 10
d <- lintul2(crp, wth, s, contr)

# test LINTUL2

library(meteor)
library(LINTUL)
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

