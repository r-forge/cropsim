\name{plotting}
\alias{splot}
\alias{splot2}
\alias{splot3}
\alias{splot4}
\alias{splot5}

\title{ Plotting model results }
\description{
  Function to make a plot of sites, ....
}
\usage{
splot(x, ...)
splot2(x, ...)
splot3(x, ...)
splot4(x, vars=c('sites', 'diseased', 'removed', 'latent', 'infectious'), cols=c('black', 'gray', 'blue', 'red', 'green'), ...)
splot5(x, vars=2:length(x[1,]), ...)
}
\arguments{
    \item{x}{ A simulation result object }  
	\item{vars}{ vector of variable names or indices to specify which variables should be plotted}
	\item{cols}{ vector of color names of the same length as vars, to specify the respective colors of the output variables }  
	\item{...}{ Additional arguments for plot() }  	
}
\details{
  
}
\value{
  None. Only a side effect (the plot)
}
\author{ Robert J. Hijmans }

\examples{
}
\keyword{ spatial }
