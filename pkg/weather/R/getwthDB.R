# Author: Robert J. Hijmans and Jorell Aunario, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

DBgetWthXY <- function(database, tablename, lon, lat, alt=2, rst=raster(), ...) {
	cell <- cellFromXY(rst, c(lon, lat))-1
	wc <- DBgetWthCell(database, tablename, cell, ...)
	wth <- new('weather')
	wth@lon <- lon
    wth@lat <- lat
	wth@alt <- 0
	wth@w <- wc
    return(wth)
}

DBgetWthCell <- function(database, tablename, cell, verbose=FALSE, year="all") {
	# use rodbcExt to be able to retry connections automatically
    db <- odbcConnect(database)
	
	if (year=='all'){
        query <- paste("SELECT * FROM", tablename, "WHERE cell =", cell)    
    } else {
        query <- paste("SELECT * FROM", tablename, "WHERE cell =", cell, "AND YEAR(wdate) IN (",paste(year, collapse=","),")")
    }
	w <- sqlQuery(db, query)
	odbcClose(db)
	year <- yearFromDate(w$wdate)
	doy <- doyFromDate(w$wdate)
	vars <- colnames(w)[4:ncol(w)]
    w <- cbind(w$wdate,year,doy,w[,-(1:3)])
    colnames(w) <- c("date", "year", "doy", vars)
	
	if (nrow(w)>0){
       	rhnx <- rhMinMax(w$relh, w$tmin, w$tmax, w$tavg)
        w$rhmin <- rhnx[,1]
    	w$rhmax <- rhnx[,2]
        w$vapr <- w$relh * saturatedVaporPressure(w$tavg) / 1000          
    } 
	return(w)     
}

DBgetWthCellNoDSN <- function(tablename, cell, user, pwd, driver="MySQL ODBC 5.1 Driver", server="geo.irri.org", database="nasa") {
	require(RODBC)
	connString <- paste("'DRIVER={",driver,"};SERVER=",server,";DATABASE=",database,";USER=",user,";PASSWORD=", pwd,";OPTION=27;",sep="'")
	cnt <-0
	repeat {
		cnt<-cnt+1
		db <- odbcDriverConnect(connString)
		if (db!=-1){
			break
		}
		else if (cnt > 4) {
			cat("Unable to connect to server (cell=", cell,") \n", sep="")
			stop();
		}
		rm(db)
		cat("Retrying to connect. (cell=",cell,", retries=",cnt, ") \n", sep="")
	}
	query <- paste("SELECT * FROM", tablename, "WHERE cell =", cell)
	data <- sqlQuery(db, query)
	odbcClose(db)
	rm(db)
	colnames(data) <- c("cell", "day", "srad", "tmax", "tmin", "prec", "tdew", "temp", "relh")
	return(data[,-1])     
}

DBgetWthLWXY <- function(database, tablename, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(DBgetWthLWCell(database, tablename, cell, lat))
}	

DBgetWthLWCell <- function(database, tablename, cell, latitude) {
	w <- DBgetWthCell(database, tablename, cell)
	w$lfwt <- leafWetWithRain(w, FALSE)
	return(w)
}	

DBgetWthLWCellNoDSN <- function(tablename, cell, latitude, user, pwd, ...) {
	w <- DBgetWthCellNoDSN(tablename, cell, user, pwd)
	w$lfwt <- leafWetWithRain(w, FALSE)
	return(w)
}

AccessGetWthXY <- function(database, tablename, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(AccessGetWthCell(database, tablename, cell))   }	

	
AccessGetWthCell <- function(database, tablename, cell) {
	require(RODBC)
	query <- paste("SELECT * FROM", tablename, "WHERE cell =", cell)
	db <- odbcConnectAccess(database)
	w <- sqlQuery(db, query)
	odbcClose(db)
	colnames(w) <- c("cell", "day", "prec", "relh", "srad", "tmax", "tmin")
	rhnx <- rhMinMax(w$relh, w$tmin, w$tmax) 
	w$rhmn <- rhnx[,1]
	w$rhmx <- rhnx[,2]
	return(w[,-1])     
}	

AccessGetCellNumbers <- function(database, tablename) {
	require(RODBC)
	query <- paste("SELECT cell FROM", tablename, "GROUP BY cell") 
	db <- odbcConnectAccess(database)
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(as.vector(data[,1]))
}
