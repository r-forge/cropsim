\name{tungro}
\alias{tungro}


%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
tungro(tmp, rh, duration=120, startday=1, rhlim=1) 

}
\arguments{
  \item{tmp}{ Describe \code{xy} here }
  \item{rh}{ Describe \code{xy} here }  
  \item{duration}{ Describe \code{x} here }  
  \item{startday}{ Describe \code{x} here }    
  \item{rhlim}{ threshold to decide whethere leaves are wet or not }      
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

rhtable <- cbind(0:10*12, c(99, 98.5, 97, 96, 98.5, 96, 95.5, 96.5, 97, 95.5, 96))
tmptable <- cbind(0:10*12, c(31.5, 31.3, 31.3, 31.5, 31.5, 31.5, 31.3, 31.3, 31.4, 31.4, 31.5))
dur <- 120
rh <- vector(length=dur)
tmp  <- vector(length=dur)
for (d in 1:dur) {
	rh[d] <- AFGen(rhtable, d)
	tmp[d] <- AFGen(tmptable, d)
}	

res <- tungro(tmp, rh)
splot(res)



}
\keyword{ spatial }
