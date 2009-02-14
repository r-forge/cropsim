
# Author: 	Robert J. Hijmans, r.hijmans@gmail.com; Jorrel Khalil S. Aunario
#Date: 6 February 2009
# Version 0.1  
# License GPL3

require(RODBC)
require(raster)

getLandCells <- function(){
	con <- odbcConnect('NASAclim')
	lc <- sqlQuery(con, "SELECT cell_id AS cell FROM masks WHERE resolution = 1 AND arable = TRUE")
	odbcClose(con)
	lc <- lc$cell
	return(lc)	
}


spatSim <- function(raster, model, emergence='2000-7-15', track=1:ncell(raster), ...)  {
	if (!all(resolution(raster) == c(1,1))) {
		stop('raster has wrong resolution')
	}

	onedegworld <- raster()
	cells <- cellsFromBbox(onedegworld, raster)
	if (ncell(raster) != length(cells)) { stop("not good") }

	result <- vector(length=length(cells))
	land <- getLandCells()
	cnt <- 0
	for (cell in cells) {
		cnt <- cnt + 1			
		if (cnt %in% track) {
			# for debugging or progress tracking
			cat(cell, '\n' ) 
		}
		if(sum((cell-1)==land)>0){
            xy <- xyFromCell(onedegworld, cell)		    
			wth <- DBgetWthCell('nasaclim', 'daily', cell)
			wth$year <- yearFromDate(wth$day)
			wth$prec[is.na(wth$prec)] <- 0
			res  <- model(wth, ...)
			result[cnt] <- sum(res[,12])
		}
		else{
			result[cnt] <- NA
		}
	}
	raster <- setValues(raster, result)
	return(raster)
}
