# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  July 2016


readLIN3output <- function(f) {
	X <- readLines(f)
	H <- .trim2(X[17])
	H <- unlist(strsplit(H, ' '))
	X <- X[-c(1:17)]
	X = .trim2(X)
	X <- strsplit(X, ' ')
	s = lapply(X, function(i) as.numeric(i))
	ss = do.call(rbind, s)

	colnames(ss) = H
	ss
}



lintul3_control <- function() {
	f <- system.file("lintul/control.ini", package="Rlintul")
	ini <- .readIniFile(f)
	.getNumLst(ini)
}


lintul3_soil <- function(name='p1') {
	f <- list.files(system.file("lintul/soil", package="Rlintul"), full.names=TRUE)
	soils <- gsub('LINTUL_soil_', '', basename(f))
	soils <- gsub('.ini', '', soils)
	if (name %in% soils) {
		i <- which (name == soils)
		ini <- .readIniFile(f[i])
		lst <- .getNumLst(ini)
		return(lst)
	} else {
		stop(paste('not available. Choose one of:', paste(soils, collapse=', ')))
	}
}



lintul3_crop <- function(name) {
    f <- list.files(system.file("lintul/crop", package="Rlintul"), full.names=TRUE)
    crops <- gsub('lintul3_', '', basename(f))
    crops <- gsub('.ini', '', crops)
    if (name %in% crops) {
		i <- which (name == crops)
		ini <- .readIniFile(f[i])
		lst <- .getNumLst(ini)
		return(lst)
    } else {
		stop(paste('not available. Choose one of:', paste(crops, collapse=', ')))
    }
}


