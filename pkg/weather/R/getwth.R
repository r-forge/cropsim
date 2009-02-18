
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

getWthXY <- function(lon, lat, start="1993-1-1", end="2009-12-31") {
	sday <- dayFromDate(start)
	smon <- monthFromDate(start)
	syr <- yearFromDate(start)
	eday <- dayFromDate(end)
	emon <- monthFromDate(end)
	eyr <- yearFromDate(end)
	raster <- newRaster()
	cell <- cellFromXY(raster, c(lon, lat))
	if (is.na(cell)) {
		stop("invalid coordinates")
	} 
	filename <- paste("daily_weather_", cell, ".nasa", sep="")

	vars <- c("swv_dwn", "T2M", "T2MN", "T2MX", "RH2M", "RAIN")
	nicevars <- c("year", "doy", "srad", "temp", "tmin", "tmax", "relh", "prec")

	if (!file.exists(filename)) {
		xy <- xyFromCell(raster, cell)
		lon <- xy[1]
		lat <- xy[2]

		
		part1 <- "http://earth-www.larc.nasa.gov/cgi-bin/cgiwrap/solar/agro.cgi?email=agroclim%40larc.nasa.gov&step=1&lat="
		part2 <- paste(lat, "&lon=", lon, "&sitelev=&ms=", smon, "&ds=", sday, "&ys=", syr, "&me=", emon, "&de=", eday, "&ye=", eyr, sep="")
		part3 <- ''
		for (i in 1:length(vars)) {
			part3 <- paste(part3, "&p=", vars[i], sep="")
		}
		part3 <- paste(part3, "&submit=Submit", sep="")
		theurl <- paste(part1, part2, part3, sep="")
	
		download.file(url=theurl, destfile=filename, method="auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
	}
	lns <- readLines(filename)
	hdr <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns[14]))  , " ")[[1]]
	if (hdr[1] != "YEAR") { stop("Something funny is going on") }
	lns <- lns[15:length(lns)]
	lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
	lns <- matrix(as.numeric(unlist(lns)), ncol=length(lns[[1]]), byrow=T)
	colnames(lns) <- nicevars
	return(lns)
}

DBgetWthXY <- function(database, table, lon, lat, rst=raster()) {
	cell <- cellFromXY(rst, c(lon, lat))
	return(DBgetWthCell(database, table, cell))
}	

DBgetWthCell <- function(database, table, cell) {
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
		cat("Retrying to connect. (cell=",cell,", retries=",cnt, ") \n", sep="")
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
	connString <- paste("DRIVER={",driver,"};SERVER=",server,";DATABASE=",database,";USER=",user,";PASSWORD=", pwd,";OPTION=27;",sep="")
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
	return(data[,2:9])     
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
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	db <- odbcConnectAccess(database)
	data <- sqlQuery(db, query)
	odbcClose(db)
	colnames(data) <- c("cell", "day", "prec", "relh", "srad", "tmax", "tmin")
	return(data[,2:7])     
}	

AccessGetCellNumbers <- function(database, table) {
	query <- paste("SELECT cell FROM", table, "GROUP BY cell") 
	db <- odbcConnectAccess(database)
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(as.vector(data[,1]))
}
