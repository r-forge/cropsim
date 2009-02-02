
splot <- function(x, ...) {
	x <- as.data.frame(x)
#	attach(x)
	plot(x$day, x$sites, ylim=c(0, 100),  ylab="% of sites", ...)
	points(x$day, x$diseased, col="gray")
	points(x$day, x$removed, col="blue")
	points(x$day, x$latent, col="red")
	points(x$day, x$infectious,  col="green")
	legend(0, 60, c("sites", "diseased", "removed", "latent", "infectious"), col=c("black", "gray", "blue", "red", "green"), pch=21)
#	detach(x)
}	



splot2 <- function(x, ...) {
	x <- as.data.frame(x)
	plot(x$day, x$sites, ylab="sites", ...)
	points(x$day, x$diseased, col="gray", ...)
	points(x$day, x$removed, col="blue", ...)
	points(x$day, x$latent, col="red",...)
	points(x$day, x$infectious,  col="green", ...)
	legend(0, max(x$sites), legend=c("sites", "diseased", "removed", "latent", "infectious"), col=c("black", "gray", "blue", "red", "green"), pch=21)

}	

splot3 <- function(x, ...) {
	x <- as.data.frame(x)
#	attach(x)
	plot(x$day, x$severity, ylim=c(0, 100),  ylab="incidence or severity (%)", ...)
#	points(x$day, x$incidence, col="gray")
#	points(x$day, x$removed, col="blue")
#	points(x$day, x$latent, col="red")
#	points(x$day, x$infectious,  col="green")
	legend(0, 60, c("severity"), col=c("black"), pch=21)
#	detach(x)
}	



splot4 <- function(x, vars=c('sites', 'diseased', 'removed', 'latent', 'infectious'), cols=c('black', 'gray', 'blue', 'red', 'green'), ...) {
	x <- as.data.frame(x)
	plot(x$day, x[[vars[1]]], xlab="time", ylab="sites", col=cols[1], ...)
	if (length(vars) > 1) {
		for (i in 2:length(vars)) {
			points(x$day, x[[vars[i]]], ylab="sites", col=cols[i], ...)
		}
	}
}



splot5 <- function(x, vars=2:length(x[1,]), ...) {
	x <- as.data.frame(x)
	cols=c('black', 'gray', 'blue', 'red', 'green')
	plot(x$day, x[,vars[1]], xlab="time", ylab="sites", col=cols[1], ...)
	if (length(vars) > 1) {
		for (i in 2:length(vars)) {
			points(x$day, x[,vars[i]], ylab="sites", col=cols[i], ...)
		}
	}
}
