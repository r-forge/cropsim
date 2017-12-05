\name{quefts}


\alias{quefts}
\alias{quefts_crop}
\alias{quefts_soil}
\alias{soil<-}
\alias{crop<-}
\alias{fert<-}


\title{
QUEFTS model
}

\description{
Calculate nutrient requirements and nutrient limited yields according to the QUEFTS model.
}

\usage{
quefts(soil, crop, fertilizer)
quefts_soil()
quefts_crop(name="")
crop(x) <- value
soil(x) <- value
fert(x) <- value
}

\arguments{
 \item{soil}{list with named soil parameters. See Details. An example is returned by \code{quefts_soil()}}
 \item{crop}{list with named crop parameters. See Details. An example is returned by \code{quefts_crop()}} 
 \item{fertilizer}{list with named fertilizer parameters (N, P and K). . An example is returned by \code{quefts_fert()}} 
 \item{name}{character. crop name} 
 
 \item{value}{a list with soil, crop, or fertlizer parameters as above}
 
}


\details{


\tabular{lll}{
	\tab \bold{Input Variables} \tab \bold{Explanation} \cr
	\tab \bold{Soil} \tab . \cr
	\tab \code{N_base_supply, P_base_supply, K_base_supply} \tab Potential supply (kg/ha) of N, P and K of the (unfertilzed) soil in a growing season of standard length (default is 120 days). See \code{\link{soilNutrientSupply}} to estimate that. \cr
	\tab \code{N_recovery, P_recovery, K_recovery} \tab Fertilzer recovey, that is, the fraction of applied fertilizer that can be taken up by the plant. \cr
	\tab \code{UptakeAdjust} \tab Two-colum matrix to compute the fraction uptake from soil supply as function of length of season. The default standard season length is 120 days. The first column is the length of the growing season, the second column is the fraction uptake. Intermediate values are computed by linear interpolation. \cr
	
	\tab \bold{Crop} \tab . \cr
	\tab \code{leaf_att, stem_att, store_att} \tab Total attainable (or target) crop biomass (dry-matter, kg/ha) for leaves, stems and storage organs.  \cr
	\tab \code{SeasonLength} \tab Length of the growing season (days) \cr
	\tab \code{_minVeg, _maxVeg, _minStore, _maxStore} \tab minimum and maximum concentration of "\code{_}" (N, P, or K) in vegetative organs and in storage organs (kg/kg) \cr
	\tab \code{Yzero} \tab the maximum biomass of vegetative organs at zero yield of storage organs (kg/ha) \cr
	\tab \code{Nfix} \tab the fraction of a crop's nitrogen uptake supplied by biological fixation \cr
	\tab \bold{Managment} \tab . \cr

	\tab \code{N, P, K} \tab N, P, and K fertilzer applied. \cr
	
	\tab . \tab \cr
	\tab . \tab \cr
	\tab \bold{Output Variables} \tab \bold{Explanation} \cr
	\tab \code{N_actual_supply, P_actual_supply, K_actual_supply} \tab nutrient uptake from soil (not fertilzer) (kg/ha) \cr
	\tab \code{leaf_lim, stem_lim, store_lim} \tab nutrient limited yield of leaves, stems, and storage organ (kg/ha) \cr
	\tab \code{N_gap, P_gap, K_gap} \tab fertilizer required to reach the specified yield (kg/ha) \cr
}
}


\value{
vector, see Details
}

\references{
Janssen et al., 1990. A system for the quantitative evaluation of tropical soils. Geoderma 46: 299-318

Sattari et al., 2014. Crop yield response to soil fertility and N, P, K inputs in different environments: Testing and improving the QUEFTS model. Field Crops Research 157:35-46
}


\examples{
library(Rquefts)

soil <- quefts_soil()
barley <- quefts_crop('Barley')
fert <- list(N=0, P=0, K=0)

barley$SeasonLength <- 162
barley$leaf_att <- 2651
barley$stem_att <- 5053
barley$store_att <- 8208

q <- quefts(soil, barley, fert)
q

fert$N <- 200
fert$P <- 100
fert$K <- 100

quefts(soil, barley, fert)

soil <- quefts_soil()
N <- 1:20*50
fert <- list(N=0, P=0, K=0)

q <- list()
for (i in 1:length(N)) {
	fert$N <- N[i]
	q[[i]] <- quefts(soil, barley, fert)
}

yield <- sapply(q, function(i) i['storage_yield'])

par(mfrow=c(1,2))
plot(N, yield, type='l', lwd=2)
Efficiency = yield / N
plot(N, Efficiency, type='l', lwd=2)

f <- expand.grid(N=seq(0,400,10), P=seq(0,400,10), K=c(0,200))
x <- rep(NA, nrow(f))
for (i in 1:nrow(f)) {0
	fert$N <- f$N[i] 
	fert$P <- f$P[i] 
	fert$K <- f$K[i] 
	x[i] <- quefts(soil, barley, fert)['storage_yield']
}
x <- cbind(f, x)


library(raster)
r0 <- rasterFromXYZ(x[x$K==0, -3])
plot(r0, xlab='N fertilizer', ylab='P fertilizer', las=1, main="K=0")
contour(r0, add=TRUE)

r200 <- rasterFromXYZ(x[x$K==200, -3])
plot(r200, xlab='N fertilizer', ylab='P fertilizer', las=1, main="K=200")
contour(r200, add=TRUE)



## Another way to run quefts
qsoil <- quefts_soil()
barley <- quefts_crop('Barley')
f <- list(N=50, P=20, K=25)

q <- QueftsModel$new()
soil(q) <- quefts_soil()
crop(q) <- quefts_crop('Barley')
fert(q) <- list(N=50, P=20, K=25)
q$run()
q$N <- 100
q$run()



}
