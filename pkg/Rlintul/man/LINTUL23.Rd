\name{lintul2}

\alias{lintul0}
\alias{lintul2}
\alias{lintul3}
\alias{lintul2_crop}
\alias{lintul3_crop}
\alias{lintul2_soil}
\alias{lintul3_soil}
\alias{lintul3_control}

\alias{default_weather}

\title{
LINTUL2 crop growth model
}

\description{
LINTUL is a relatively simple crop growth simulation model
}

\usage{
lintul1(crop, weather, control)
lintul1_crop()

lintul2(crop, weather, soil, control)
lintul2_crop()
lintul2_soil()

lintul3(crop, weather, soil, control)
lintul3_crop(name)
lintul3_soil(name='p1')
lintul3_control()

default_weather()
}

\arguments{
\item{crop}{list. Crop parameters}
\item{weather}{data.frame with weather data}
\item{soil}{list. Soil parameters}
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
\dontrun{
w <- default_weather()
wth <- subset(w, date > as.Date('2012-01-01'))
crop <- lintul1_crop()
str(crop)

contr <- list(emergence=as.Date('2012-04-01'), long_output=FALSE)

lintul1(crop, wth, contr)
crop$RUE <- 3.5
lintul1(crop, wth, contr)


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


## LINTUL2
s <- lintul2_soil()
crp <- lintul2_crop()
contr <- list(emergence=as.Date('2012-04-01'), long_output=TRUE)
contr$start <- contr$emergence - 10
d <- lintul2(crp, wth, s, contr)


## LINTUL3
crop = lintul3_crop('POTATO')
soil = lintul3_soil(name='p1')
contr = lintul3_control()
contr$PL = FALSE
contr$emergence =as.Date('2012-04-01')
contr$start <- contr$emergence - 10
contr$long_output=TRUE
x = lintul3(crop, wth, soil, contr)



# test LINTUL1

library(meteor)
library(Rlintul)
f1 <- system.file("lintul/test/1/res.dat", package="Rlintul")
s <- readLIN1output(f1)
f2 <- system.file("weather/Netherlands_Wageningen.csv", package="Rlintul")
wth <- read.csv(f2)
wth$date <- as.Date(wth$date)
wth$srad <- wth$srad / 1000

crop <- lintul1_crop()
sdate <- dateFromDoy(58, 1971)
contr <- list(emergence=sdate+2, start = sdate, long_output=TRUE)
x <- lintul1(crop, wth, contr)

plot(s[,'TIME'], s[,'LAI'], type='l')
points(x[, 'step']+58, x[, 'LAI'])


# test LINTUL2

library(meteor)
library(LINTUL)
f1 <- system.file("lintul/test/2/res.dat", package="Rlintul")
s <- readLIN1output(f1)
f2 <- system.file("weather/Netherlands_Wageningen.csv", package="Rlintul")
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


# test LINTUL3

library(meteor)
library(Rlintul)
wf <- system.file("weather/Netherlands_Wageningen.csv", package="Rlintul")
wth <- read.csv(wf)
wth$date <- as.Date(wth$date)
wth$srad <- wth$srad / 1000
crop <- lintul3_crop('WWHEAT')
soil <- lintul3_soil('p1')
sdate <- dateFromDoy(1, 1969)
contr <- lintul3_control()
contr$emergence=sdate
contr$start = sdate
contr$long_output=TRUE
contr$PL = FALSE


contr$IOPT = 1
contr.IRRI = 1
f1 <- system.file("lintul/test/3/WAGI1PTS.OUT", package="Rlintul")
s1 <- readLIN3output(f1)
x <- lintul3(crop, wth, soil, contr)
plot(s1[,'DAY'], s1[,'LAI'], type='l')
points(x[, 'step']+1, x[, 'LAI'])

contr$IOPT = 2
contr.IRRI = 1
f2 <- system.file("lintul/test/3/WAGW2PTS.OUT", package="Rlintul")
s2 <- readLIN3output(f2)
x2 <- lintul3(crop, wth, soil, contr)
plot(s2[,'DAY'], s2[,'LAI'], type='l')
points(x2[, 'step']+1, x2[, 'LAI'])

contr$IOPT = 3
f3 <- system.file("lintul/test/3/WAGW3PTS.OUT", package="Rlintul")
s3 <- readLIN3output(f3)
x3 <- lintul3(crop, wth, soil, contr)
plot(s3[,'DAY'], s3[,'LAI'], type='l')
points(x3[, 'step']+1, x3[, 'LAI'])

contr$IOPT = 4
f4 <- system.file("lintul/test/3/WAGW4PTS.OUT", package="Rlintul")
s4 <- readLIN3output(f4)
x4 <- lintul3(crop, wth, soil, contr)
plot(s4[,'DAY'], s4[,'LAI'], type='l')
points(x4[, 'step']+1, x4[, 'LAI'])
}

}

