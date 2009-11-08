raudpc <- function(x) {
	if (length(x$severity) > 0) {
		sum(x$severity)/length(x[,1])
	} else 	if (length(x$incidence) > 0) {
		sum(x$incidence)/length(x[,1])
	} else {
		stop('cannot find incidence or severity')
	}
}
