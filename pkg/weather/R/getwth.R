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
	raster <- raster()
	cell <- cellFromXY(raster, c(lon, lat))
	if (is.na(cell)) {
		stop("invalid coordinates")
	} 
	filename <- paste("daily_weather_", cell, ".nasa", sep="")

	vars <- c("swv_dwn", "T2M", "T2MN", "T2MX", "RH2M", "RAIN")
	nicevars <- c("year", "doy", "srad", "tavg", "tmin", "tmax", "relh", "prec")

	xy <- xyFromCell(raster, cell)
	lon <- xy[1]
	lat <- xy[2]
	if (!file.exists(filename)) {
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
	alt <- NA
	try(alt <- as.numeric(substr(lns[4],60,66)), silent=TRUE)
	hdr <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns[14]))  , " ")[[1]]
	if (hdr[1] != "YEAR") { stop("Something (not so) funny is going on") }
	lns <- lns[15:length(lns)]
	lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
	lns <- matrix(as.numeric(unlist(lns)), ncol=length(lns[[1]]), byrow=T)
	colnames(lns) <- nicevars
	rhnx <- rhMinMax(lns[,'relh'], lns[,'tmin'], lns[,'tmax'], lns[,'tavg']) 
	lns <- cbind(lns, rhnx)
	
	date <- dateFromDoy(lns[,'doy'], lns[,'year'])
	lns <- cbind(as.data.frame(date), lns)
	wth <- new('weather')
	wth@lon <- xy[1]
	wth@lat <- xy[2]
	wth@alt <- alt
	wth@w <- lns
	return(wth)
}

