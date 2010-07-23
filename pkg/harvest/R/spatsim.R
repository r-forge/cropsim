# Author: 	Robert J. Hijmans, r.hijmans@gmail.com; Jorrel Khalil S. Aunario
#Date: 6 February 2009
# Version 0.1  
# License GPL3

getLandCells <- function(odbcname='NASAclim'){
    cnt <- 0
    repeat {
		cnt<-cnt+1
		con <- odbcConnect(odbcname)	
		if (con!=-1){
			break
		}
		else if (cnt > 4) {
			cat("Unable to connect to server \n")
			stop();
		}
		rm(con)
		cat("Retrying to connect. \n")
		flush.console()
	}
	lc <- sqlQuery(con, "SELECT cell_id AS cell FROM masks WHERE resolution = 1 AND arable = TRUE")
	odbcClose(con)
	lc <- lc$cell
	return(lc)	
}

spatSim <- function(raster, model, starts, verbose=FALSE, ...)  {
	raster <- nudgeExtent(raster)
	res(raster) <- 1

	nruns <- length(start)
	onedegworld <- raster()
	cells <- cellsFromExtent(onedegworld, raster)
	if (ncell(raster) != length(cells)) { stop("not good") }
	
	result <- matrix(NA, nrow=length(cells), ncol=length(starts))
	
	land <- getLandCells()
	cnt <- 0
	for (cell in cells) {
		cnt <- cnt + 1			
		if (verbose) {
			# for debugging or progress tracking
			cat("\r", rep.int(" ", getOption("width")), sep="")
			cat("\r", "cell: " , cell)
			flush.console() 
		}
		if ((cell-1) %in% land) {
#			if (wtness==0) {
			wth <- DBgetWthCell('nasaclim', 'daily', cell-1)			
#			}
#			else{
#				xy <- xyFromCell(onedegworld, cell)
#				wth <- DBgetWthLWCell('nasaclim', 'daily', cell-1, xy[2])
#			}
			wth$year <- yearFromDate(wth$day)
			wth$prec[is.na(wth$prec)] <- 0
			
			for (d in 1:length(starts)) {
				result[cnt, d] <- model(wth, emergence=starts[d])
			}
		}
		else {
			result[cnt] <- NA
		}
	}

    rStack <- new('RasterStack')
	for (d in 1:length(starts)) {
		r <- setValues(raster, result[,d])
		rStack <- addLayer(rStack, r)    
	}
	return(rStack)
}

spatSimFlex <- function(ras, pdateraster, model, years, period=14, periodpt=7, skipzero=TRUE, verbose=FALSE, ...){
    
	ras <- nudgeExtent(ras)
	res(ras) <- 1
	
	nruns <- length(start)
	onedegworld <- raster()
	pcells <- cellsFromExtent(onedegworld, pdateraster)
	cwpd <- which(pdateraster[]>0)
	
    cells <- cellsFromExtent(onedegworld, ras)[pcells[cwpd]]
	#if (ncell(raster) != length(cells)) { stop("not good") }
	
	result <- matrix(NA, nrow=length(cells), ncol=length(years))
	
	land <- getLandCells()
	cnt <- 0
	for (cell in cwpd) {
		cnt <- cnt + 1			
		if (verbose) {
			# for debugging or progress tracking
			cat("\r", rep.int(" ", getOption("width")), sep="")
			cat("\r", "cell: " , pcells[cell])
			flush.console()
		}
		
		if (pdateraster[cell]==0 & skipzero) next
		
		if ((pcells[cell]-1) %in% land) {
#			if (wtness==0) {
            xy <- xyFromCell(onedegworld,cell)
			wth <- getWthXY(xy[1], xy[2])			
#			}
#			else{
#				xy <- xyFromCell(onedegworld, cell)
#				wth <- DBgetWthLWCell('nasaclim', 'daily', cell-1, xy[2])
#			}
			wth@w$prec[is.na(wth@w$prec)] <- 0
			wth@w$rhmax[is.na(wth@w$rhmax)] <- 0
			for (d in 1:length(years)) {
				if (pdateraster[cell]>0){
					pdate <- dateFromDoy((pdateraster[cell]-1)*period+periodpt,years[d])
				} else {
					pdate <- paste(years[d], "5-15", sep="-") 
				} 
				result[cnt, d] <- model(wth, emergence=pdate)
			}
		}
		else {
			result[cnt] <- NA
		}
	}

	rStack <- new('RasterStack')
	for (d in 1:length(years)) {
		r <- setValues(ras, result[,d])
		rStack <- addLayer(rStack, r)    
	}
	return(rStack)
}
