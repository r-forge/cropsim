
require(RODBC)

getLandCells <- function(){
	con <- odbcConnect('NASAclim')
	lc <- sqlQuery(con, "SELECT cell_id AS cell FROM masks WHERE resolution = 1 AND arable = TRUE")
	odbcClose(con)
	lc <- lc$cell
	return(lc)	
}

spatSim <- function(raster, model, emergence='2000-7-15', ...)  {
	if (!all(resolution(raster) == c(1,1))) {
		stop('raster has wrong resolution')
	}
	onedegworld <- raster()
	cells <- cellsFromBbox(onedegworld, raster)
	cells <- cells -1
	if (ncell(raster) != length(cells)) { stop("not good") }

	result <- vector(length=length(cells))
	land <- getLandCells()
	cnt <- 0
	for (cell in cells) {
		cnt <- cnt + 1			
		if(sum(cell==land)>0){
			wth <- DBgetWthCell('NASAclim', 'daily', cell)
			wth$year <- yearFromDate(wth$day)
			wth$prec[is.na(wth$prec)] <- 0
			res  <- model(wth, ...)
			result[cnt] <- sum(res[,6]) / 120
		}
		else{
			result[cnt] <- NA
		}
	}
	raster <- setValues(raster, result)
	return(raster)
}
