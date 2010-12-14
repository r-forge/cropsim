# Author: Jorrel Khalil S. Aunario, jaunario@gmail.com
# Date :  22 September 2010
# Version 0.0.1
# Licence GPL v3

.dd2DMS <- function(dd, lat=T){
    if (dd!=-99){
        aDD <- abs(dd)
        deg <- trunc(aDD)
        dec <- aDD - deg
        mn <- round(dec*60)
        DMS <- paste(deg, mn)
        if (lat & dd>0){
            DMS <- paste(DMS, "N")
        } else if (lat & dd<0){
            DMS <- paste(DMS, "S")
        } else if (!lat & dd>0){
            DMS <- paste(DMS, "E")
        } else {
            DMS <- paste(DMS, "W")
        }
    } else {
        DMS <- "-99."
    }
    return(DMS)
}


write.fse <- function(wth, year, country, stn, author="", src="", target=".", na.val=-99, y2ksafe=1, sradkJ=TRUE, ...){    
    if (length(year)>1){
        stop("Multiple years not yet supported")
    }
    if (class(wth)!="weather"){
        stop("Usupported weather data format.")
    }
    border <- "*-----------------------------------------------------------"
    cols <- rbind("*  Column    Daily Value",
                "*     1      Station number",
                "*     2      Year",
                "*     3      Day",
                "*     4      irradiance         KJ m-2 d-1",
                "*     5      min temperature            oC",
                "*     6      max temperature            oC",
                "*     7      vapor pressure            kPa",
                "*     8      mean wind speed         m s-1",
                "*     9      precipitation          mm d-1")
                
    auth <- paste("*  Author      :", author, na.val, ": nil value")
    srcname <- paste("*  Source      :", src)


    hdri1 <- paste("*  Station Name:", country)
    hdri2 <- paste("*  Longitude:  ", .dd2DMS(wth@lon, F), "   Latitude:", .dd2DMS(wth@lat), "   Altitude:  ", wth@alt,"m")
    hdri3 <- paste(sprintf("%.2f",wth@lon),sprintf("%.2f",wth@lat),format(wth@alt, width=5), "0.00", "0.00")
    if ((year>=2000 & y2ksafe==1)|(y2ksafe==2)) {
        addcomment <-  rbind("*",paste("*  Original year:",year), "*  Created by R weather package")
        year <- year-(20*(trunc((year-2000)/20)+1))
                
    }    
    
    
    hdr <- rbind(border,hdri1,auth,srcname, hdri2,cols,addcomment, border,hdri3)
    
    fname <- paste(target, paste(tolower(paste(country, stn, sep="")),substr(year,2,4),sep="."),sep= "/")
    tmpdat <- wth@w[grep(year,wth@w$year),]
    if (sradkJ) tmpdat$srad <- tmpdat$srad*1000
    tmpdat[is.na(tmpdat)] <- na.val
    dattxt <- hdr
    for(i in 1:nrow(tmpdat)){
        dattxt <- rbind(dattxt, paste(c(stn, year, format(i,width=3), format(tmpdat$srad[i], width=5, justify="right"), format(sprintf("%.1f",tmpdat[i, c("tmin", "tmax", "vapr", "wind", "prec")]), width=5, justify="right")), collapse=" "))
    }
    writeLines(dattxt, fname)
    return(dattxt)    
}
