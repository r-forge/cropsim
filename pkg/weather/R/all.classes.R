# R classes for spatial data (raster data specifically) 
# Author: Robert J. Hijmans
# International Rice Research Institute
# contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,3
# Licence GPL v3


setClass('location', 
	representation (
		x ='numeric',
		y ='numeric',		
		alt ='numeric'
	)
)


setClass('weather', 
	representation (
		temp ='vector',
		prec = 'vector',
		rad = 'vector',
		wind = 'vector',
		vapr = 'vector',
		relh  = 'vector',
		time = 'vector'
	),
	prototype (	
		
	),	
	validity = function(object)
	{ # all vectors should have same length 
	}
)

	
setClass ('dailyweather',
	contains = 'weather',
	representation (
		mintmp ='numeric',
		maxtmp ='numeric'
		),
	validity = function(object)
	{
		cond1 <- isTRUE(object@mintmp <= object@maxtmp)
		cond <- cond1 #& cond2 & cond3
		return(cond)
	}
)
	
	
