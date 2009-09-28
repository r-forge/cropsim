# Author: Robert J. Hijmans and Jorell Aunario, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

DBgetWthXY <- function(database, table, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(DBgetWthCell(database, table, cell))
}

DBgetWthCell <- function(database, table, cell, verbose=FALSE) {
	require(RODBC)
	cnt <-0
	repeat {
		cnt<-cnt+1
		db <- odbcConnect(database)
		if (db!=-1){
			break
		}
		else if (cnt > 4) {
			cat("Unable to connect to server (cell=", cell,") \n", sep="")
			stop();
		}
		rm(db)
		if (verbose){
            cat("Retrying to connect. (cell=",cell,", retries=",cnt, ") \n", sep="")
            flush.console()    
        }
		
	}
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	w <- sqlQuery(db, query)
	odbcClose(db)
	colnames(w) <- c("cell", "day", "srad", "tmax", "tmin", "prec", "tdew", "temp", "relh")
	rhnx <- rhMinMax(w$relh, w$tmin, w$tmax, w$temp) 
	w$rhmn <- rhnx[,1]
	w$rhmx <- rhnx[,2]
	return(w[,-1])     
}

DBgetWthCellNoDSN <- function(table, cell, user, pwd, driver="MySQL ODBC 5.1 Driver", server="geo.irri.org", database="nasa") {
	require(RODBC)
	connString <- paste('DRIVER={",driver,"};SERVER=",server,";DATABASE=",database,";USER=",user,";PASSWORD=", pwd,";OPTION=27;",sep="')
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
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	data <- sqlQuery(db, query)
	odbcClose(db)
	rm(db)
	colnames(data) <- c("cell", "day", "srad", "tmax", "tmin", "prec", "tdew", "temp", "relh")
	return(data[,-1])     
}

DBgetWthLWXY <- function(database, table, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(DBgetWthLWCell(database, table, cell, lat))
}	

DBgetWthLWCell <- function(database, table, cell, latitude) {
	w <- DBgetWthCell(database, table, cell)
	w$lfwt <- LeafWetWithRain(latitude, w$day, w$relh, w$tmin, w$tmax, w$prec, FALSE)
	return(w)
}	

DBgetWthLWCellNoDSN <- function(table, cell, latitude, user, pwd, ...) {
	w <- DBgetWthCellNoDSN(table, cell, user, pwd)
	w$lfwt <- LeafWetWithRain(latitude, w$day, w$relh, w$tmin, w$tmax, w$prec, FALSE)
	return(w)
}

AccessGetWthXY <- function(database, table, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(AccessGetWthCell(database, table, cell))   }	

	
AccessGetWthCell <- function(database, table, cell) {
	require(RODBC)
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	db <- odbcConnectAccess(database)
	w <- sqlQuery(db, query)
	odbcClose(db)
	colnames(w) <- c("cell", "day", "prec", "relh", "srad", "tmax", "tmin")
	rhnx <- rhMinMax(w$relh, w$tmin, w$tmax) 
	w$rhmn <- rhnx[,1]
	w$rhmx <- rhnx[,2]
	return(w[,-1])     
}	

AccessGetCellNumbers <- function(database, table) {
	require(RODBC)
	query <- paste("SELECT cell FROM", table, "GROUP BY cell") 
	db <- odbcConnectAccess(database)
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(as.vector(data[,1]))
}
