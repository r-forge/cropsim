
require(raster)

dm <- function(wth) {
	tmax <- wth$tmax
	tmin <- wth$tmin
	sdoy <- 200
	edoy <- 120 + sdoy
	disease <- 0
	for (d in 1:(edoy-sdoy)) { disease <- disease + tmax[d] * rain[d] } 
	return(disease)
}


mapit <- function(raster, model, ...)  {
	if (!all(resolution(raster) == c(1,1))) {
		stop('raster has wrong resolution')
	}
	onedegworld <- raster()
	cells <- cellsFromBbox(onedegworld, raster)
	if (ncell(raster) != length(cells)) { stop("not good") }

	year <- 2001
	sdoy <- 150
	edoy <- sdoy + 120

	result <- vector(length=length(cells))
	
	cnt <- 0
	for (cell in cells) {
		cnt <- cnt + 1
		wth <- DBgetWthCell('NASAclim', 'daily', cell)
		lb  <- model(wth, ...)
		result[cnt] <- sum(lb$severity) / 120
	}
	raster <- setValues(raster, dis)
	return(raster)
}


r <- raster()
#aoi <- newBbox(-10.9, 126.9, -10.9, 50.9)
aoi <- newBbox(-120, 122, -10, -5)
r <- setBbox(r, aoi, keepres=T)
mapit(r, dm, aoi)



################

plot(outras)
#plot(read.adm("PHL"), add=T)
map('world', fill = F, add=T)
