
if (!isGeneric("crop<-")) { setGeneric("crop<-", function(x, value) standardGeneric("crop<-")) }	
if (!isGeneric("soil<-")) { setGeneric("soil<-", function(x, value) standardGeneric("soil<-")) }	
if (!isGeneric("control<-")) { setGeneric("control<-", function(x, value) standardGeneric("control<-")) }	
if (!isGeneric("weather<-")) { setGeneric("weather<-", function(x, value) standardGeneric("weather<-")) }	


.trim2 <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=TRUE))

readLIN1output <- function(f) {
	X <- readLines(f)
	H <- unlist(strsplit(X[7], '\t'))
	X <- X[-c(1:8)]
	X = .trim2(X)
	X <- strsplit(X, '\t')
	s = lapply(X, function(i) as.numeric(i))
	ss = do.call(rbind, s)
	colnames(ss) = H
	ss
}


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
	
default_weather <- function() {
	f <- system.file("weather/18419.rds", package="Rlintul")
	readRDS(f)
}


.getNumLst <- function(ini) {
	v <- ini[,3]
	vv <- sapply(v, function(i) strsplit(i, ','), USE.NAMES = FALSE)
	vv <- sapply(vv, as.numeric)
	lst <- lapply(vv, function(i) if(length(i) > 1) { matrix(i, ncol=2, byrow=TRUE) } else {i})
	names(lst) <- ini[,2]
	lst
}


lintul1_crop <- function() {
	params <- list(LAIi=0.012, SLA=0.022, Tbase=0, RGRL=0.009, Tsum1=1110, Tsum2=2080, LAIcr=4, RDRSHM=0.03, RUE=3.0, K=0.6, MaxDur=365)
	RDRT <- matrix(c(-10.,0.03, 10.,0.03, 15.,0.04, 30.,0.09, 50.,0.09), ncol=2, byrow=TRUE)
	FRTTB <- matrix(c(0.,0.50, 110, 0.50, 275 ,0.34, 555, 0.12, 780, 0.07, 1055, 0.03, 1160, 0.02, 1305, 0, 2500, 0), ncol=2, byrow=TRUE)
	FLVTB <- matrix(c(0, 0.33, 110, 0.33, 275, 0.46, 555, 0.44, 780, 0.14, 1055, 0, 2500, 0), ncol=2, byrow=TRUE)
	FSTTB <- matrix(c(0, 0.17, 110, 0.17, 275, 0.20, 555, 0.44, 780, 0.79, 1055.,0.97, 1160, 0, 2500, 0), ncol=2, byrow=TRUE)
	FSOTB <- matrix(c(0, 0, 1055, 0, 1160.,0.98, 1305, 1, 2500, 1), ncol=2, byrow=TRUE)
	crop <- c(params, list(RDRT=RDRT, FRTTB=FRTTB, FLVTB=FLVTB, FSTTB=FSTTB, FSOTB=FSOTB))
	return(crop)
}


lintul2_crop <- function() {
	c(list(ROOTDi = 0.1, ROOTDM = 1.2, RRDMAX = 0.012, TRANCO = 8.), lintul1_crop())
}


lintul2_soil <- function() {
	list(WCi=0.36, WCAD=0.08, WCWP=0.23, WCFC=0.36, WCWET=0.48, WCST=0.55, DRATE=50, IRRIGF=0)
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

