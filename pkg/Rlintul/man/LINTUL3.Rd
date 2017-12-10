\name{lintul3}

\alias{lintul3}
\alias{lintul3_crop}
\alias{lintul3_soil}
\alias{lintul3_control}

\alias{readLIN3output}


\title{
LINTUL3 crop growth model
}

\description{
LINTUL is a relatively simple crop growth simulation model
}

\usage{
lintul3(crop, weather, soil, control)
lintul3_crop(name)
lintul3_soil(name='p1')
lintul3_control()
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


\examples{

\dontrun{
w <- default_weather()
wth <- subset(w, date > as.Date('2012-01-01'))
crop <- lintul1_crop()
str(crop)

contr <- list(emergence=as.Date('2012-04-01'), long_output=FALSE)

## LINTUL3
crop = lintul3_crop('POTATO')
soil = lintul3_soil(name='p1')
contr = lintul3_control()
contr$PL = FALSE
contr$emergence =as.Date('2012-04-01')
contr$start <- contr$emergence - 10
contr$long_output=TRUE
x = lintul3(crop, wth, soil, contr)



# test LINTUL3

wf <- system.file("extdata/Netherlands_Wageningen.csv", package="meteor")
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


