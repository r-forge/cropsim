

spatsim <- function(raster, model, emergence='2000-7-15', ...)  {
	if (!all(resolution(raster) == c(1,1))) {
		stop('raster has wrong resolution')
	}
	onedegworld <- raster()
	cells <- cellsFromBbox(onedegworld, raster)
	if (ncell(raster) != length(cells)) { stop("not good") }

	result <- vector(length=length(cells))

	cnt <- 0
	for (cell in cells) {
		cnt <- cnt + 1
		wth <- DBgetWthCell('NASAclim', 'daily', cell)
		wth$year <- yearFromDate(wth$day)
		wth$prec[is.na(wth$prec)] <- 0
		res  <- model(wth, emergence=emergence, ...)
		result[cnt] <- sum(res[,6]) / 120
	}
	raster <- setValues(raster, result)
	return(raster)
}

