
library(raster)

for2C <- function(f) {
	d <- readLines(f)
	x <- read.csv('translate.csv')
	for (i in 1:nrow(x)) {
		d <- gsub(x[i,1], x[i,2], d)
	}
	d <- paste0(d, ';')
	d[trim(d) == ';'] = ''
	extension(f) <- '.cpp'
	writeLines(d, f)
}

setwd('C:/@R/oryzaC')
for2C('Models.f90')

