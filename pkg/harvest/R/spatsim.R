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

spatSimFlex <- function(BaseRaster, model, outcolnames, years, pdateraster, croppingraster=NULL, nosinglecrop=FALSE, mcount=4, period=14, periodpt=7, skipzero=TRUE, verbose=FALSE, out="C:\temp",...){
    if (!file.exists(out)) dir.create(out, recursive=TRUE)
	BaseRaster <- nudgeExtent(BaseRaster)
	res(BaseRaster) <- 1
	
	#nruns <- length(start)
	onedegworld <- raster()
	pcells <- cellsFromExtent(onedegworld, pdateraster)
	cwpd <- pcells[which(pdateraster[]>0)]
	
	if (!is.null(croppingraster)& class(croppingraster)=="RasterLayer"){
        ccells <- cellsFromExtent(onedegworld,croppingraster)
        checkcropping <- TRUE
    } else {
        checkcropping <- FALSE
    }
	
    cells <- cellsFromExtent(onedegworld, BaseRaster)
    inc <- which(cells %in% cwpd)
    cells <- cells[inc] 
	#if (ncell(raster) != length(cells)) { stop("not good") }
	
	result <- matrix(NA, nrow=length(cells), ncol=length(years)*mcount)
	
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
		
		#if (pdateraster[pcells==cell]==0 & skipzero) next
				
		if ((cell-1) %in% land) {
#			if (wtness==0) {
            xy <- xyFromCell(onedegworld,cell)
			wth <- DBgetWthXY('geoclimate', "nasa_1d", xy[1], xy[2])			
#			}
#			else{
#				xy <- xyFromCell(onedegworld, cell)
#				wth <- DBgetWthLWCell('nasaclim', 'daily', cell-1, xy[2])
#			}
			wth@w$prec[is.na(wth@w$prec)] <- 0
			wth@w$rhmin[is.na(wth@w$rhmin)] <- 0
			wth@w$tavg[is.na(wth@w$tavg)] <- (wth@w$tmin[is.na(wth@w$tavg)]+wth@w$tmax[is.na(wth@w$tavg)])/2
			wth@w$rhmax[is.na(wth@w$rhmax)] <- wth@w$rhmin[is.na(wth@w$rhmax)]
			cellresults <- numeric(0)
			
		    if (checkcropping){
                if(nosinglecrop & croppingraster[ccells==cell]>1) PCISrice <- 1 else PCISrice <- 0     
            }

			for (d in 1:length(years)) {
				if (pdateraster[pcells==cell]>0){
					pdate <- dateFromDoy((pdateraster[pcells==cell]-1)*period+periodpt,years[d])
				} else {
					pdate <- paste(years[d], "5-15", sep="-") 
				}                             
				if (checkcropping) cellresults <- c(cellresults,model(wth, emergence=pdate, PCISrice=PCISrice)) else cellresults <- c(cellresults,model(wth, emergence=pdate))
			}
            result[cnt, ] <- cellresults
		}
		else {
			result[cnt,] <- NA
		}
	}
    #models <- c("leafblast", "brownspot", "bactblight", "sheathblight")
    cnames <- character(0)	
    for (y in years){
        cnames <- c(cnames,paste(outcolnames, y,sep=""))
    }
    colnames(result) <- cnames
	for (i in 1:ncol(result)) {
	    r <- raster(BaseRaster)
		r[inc] <- result[,i]
		writeRaster(r, paste(out, paste(colnames(result)[i],".tif", sep = ""), sep = "/"),...)
        rm(r)		    
	}
    return(stack(paste(out, paste(colnames(result),".tif", sep = ""), sep = "/")))
}
