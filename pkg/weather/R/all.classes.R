# R classes for spatial data (raster data specifically) 
# Author: Robert J. Hijmans
# International Rice Research Institute
# contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,3
# Licence GPL v3


setClass('weather', 
	representation (
		lon ='numeric',
		lat ='numeric',		
		alt ='numeric',
		w = 'data.frame'
	),
	prototype (	
		lon = 0,
		lat = 0,
		alt = 0,
		w = data.frame()
	),	
	validity = function(object)
	{
		con <- (x >= -180 & x <= 180 & y <= 90 & y >= -90)
		return(con)
	}
)



setMethod ('show' , 'weather', 
	function(object) {
		cat('class   :' , class(object), '\n')
		cat('\n')	
		cat('location' , '\n')
		cat('longitude:' , object@lon, '\n')
		cat('latitude :' , object@lat, '\n')
		cat('altitude :' , object@alt, '\n')
		cat('\n')
		l <- dim(object@w)[1]
		if (l == 0) {
			cat('no weather data\n')
		} else {
			cat(l ,'rows: \n')
			if (l < 25) {
				print(object@w)
			} else {
				print(object@w[1:5,])
				cat('\n')
				cat('  (... ...  ...)\n')
				cat('\n')
				print(object@w[(l-5):l,])
			}
		}
	}
)	
