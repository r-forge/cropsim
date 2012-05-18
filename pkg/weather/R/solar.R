# Author: Jorrel Khalil S. Aunario, jaunario@gmail.com
# Date :  8 May 2012
# Version 0.0.1
# Licence GPL v3

# TODO 
sunhoursToSRad <- function(sunhour, doy, lat, anga, angb){
    deg2rad <- 0.017453292
    dec <- -1*asin(sin(23.45*deg2rad)*cos(2*pi*(doy+10)/365))
    sc <- 1370*(1+0.033*cos(2*pi*doy/365))
    
    sinld <- sin(deg2rad*lat)*sin(dec)
    cosld <- cos(deg2rad*lat)*cos(dec)
    aob <- sinld/cosld  
    
    dayl <- 12*(1+2*asin(aob)/pi)
    dsinb <- 3600*(dayl*sinld+24*cosld*sqrt(1-(aob^2))/pi)
    angot <- sc*dsinb
    
    return(angot*(anga+angb*((sunhour)/dayl))/1000000) 
      
}
