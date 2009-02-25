
# Author: 	Robert J. Hijmans, r.hijmans@gmail.com; Jorrel Khalil S. Aunario
#Date: 6 February 2009
# Version 0.1  
# License GPL3

require(RODBC)
require(raster)

getLandCells <- function(){
    cnt <- 0
    repeat {
		cnt<-cnt+1
		con <- odbcConnect('NASAclim')	
		if (con!=-1){
			break
		}
		else if (cnt > 4) {
			cat("Unable to connect to server \n")
			stop();
		}
		rm(con)
		cat("Retrying to connect. \n")
	}
	lc <- sqlQuery(con, "SELECT cell_id AS cell FROM masks WHERE resolution = 1 AND arable = TRUE")
	odbcClose(con)
	lc <- lc$cell
	return(lc)	
}


spatSim <- function(raster, model, emergence='2000-7-15', track=1:ncell(raster), wetness=0,...)  {
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
		  if(wetness==0){
            wth <- DBgetWthCell('nasaclim', 'daily', cell-1)			
          }
          else{
            xy <- xyFromCell(onedegworld, cell)
            wth <- DBgetWthLWCell('nasaclim', 'daily', cell-1, xy[2])
          }
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

multiRunSpatSim <- function(raster, model, track=1:ncell(raster), wetness=0,...)  {
	if (!all(resolution(raster) == c(1,1))) {
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
        if (cnt %in% track) {
            # for debugging or progress tracking
            cat(cell, '\n' )
        }
        if(sum((cell-1)==land)>0){
            if(wetness==0){
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
                res  <- model(wth, emergence=pdate, ...)
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
        rStack <- addRasters(rStack,c(raster))        
    }    
    
	return(rStack)
}
