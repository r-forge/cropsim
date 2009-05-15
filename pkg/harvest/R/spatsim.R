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


#myfun <- function(...){sum(leafBlast(..., wetness=0)[,'severity'])}

spatSim <- function(raster, model, starts, verbose=FALSE, ...)  {
	raster <- nudgeExtent(raster)
	res(raster) <- 1

	nruns <- length(start)
	onedegworld <- raster()
	cells <- cellsFromBbox(onedegworld, raster)
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
				result[cnt, d] <- model(wth, emergence=starts[d], ...)
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



multiRunSpatSim <- function(raster, model, wtness=0, quiet=FALSE,...)  {
	if (!all(res(raster) == c(1,1))) {
        stop('raster has wrong resolution')
    }
    
    onedegworld <- raster()
	
    pdates <-as.character(seq(as.Date("1997-1-15"), by="month", length.out=120))
	cells <- cellsFromBbox(onedegworld, raster)
	if (ncell(raster) != length(cells)) {
        stop("not good")
    }

	result <- matrix(nrow=length(cells), ncol=120)
	land <- getLandCells()
	cnt <- 0
	for (cell in cells) {
        cnt <- cnt + 1
        if (!quiet) {
			# for debugging or progress tracking
			cat("\r", rep.int(" ", getOption("width")), sep="")
            cat("\rProcessing cell " , cell)
            flush.console() 
		}
		if ((cell-1) %in% land){
            if(wtness==0){
                wth <- DBgetWthCell('nasaclim', 'daily', cell-1)
            }
            else{
                xy <- xyFromCell(onedegworld, cell)
                wth <- DBgetWthLWCell('nasaclim', 'daily', cell-1, xy[2])
            }
            wth$year <- yearFromDate(wth$day)
            wth$prec[is.na(wth$prec)] <- 0
            run <- 0
            for (pdate in pdates){
                run <- run + 1            
                res  <- model(wth, emergence=pdate, wetness=wtness, ...)
                result[cnt,run] <- sum(res[,12])            
            }            
        }
        else{
            result[cnt, ] <- NA
        }        
    }
    raster <- setValues(raster, rowMeans(result))
    rStack <- stack(raster)
    for (i in 1:120){
        raster <- setValues(raster, result[,i])
        rStack <- addLayer(rStack,c(raster))        
    }    
    
	return(rStack)
}
