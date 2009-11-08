# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU Library General
# Public License along with this library; if not, write to the
# Free Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA  02111-1307  USA

# Copyrights (C)
# for this R-port:
#   1999 - 2007, Diethelm Wuertz, GPL
#   Diethelm Wuertz <wuertz@itp.phys.ethz.ch>
#   info@rmetrics.org
#   www.rmetrics.org
# for the code accessed (or partly included) from other R-ports:
#   see R's copyright and license files
# for the code accessed (or partly included) from contributed R-ports
# and other sources
#   see Rmetrics's copyright file



.movingFun = function(x, n, fun=function(x){sum(x, na.rm=TRUE)}) 
{ 

# Based on the rollFun function implemented by Diethelm Wuertz in the 
# fTrading package
# Version:	2100.76
# Published:	2009-09-29


# modified and simplified by Robert Hijmans
# for the cropsim package
# September 2009

# what is returned is a moving fun (e.g. sum or mean) computed for t=t-n to t=t
# i.e. this is unlike a typical moving average which is for t-floor(0.5n) to t+floor(0.5n)


    # Description:  #   Compute rolling function value
    # Arguments:
    #   x - an univariate numeric vector.
    #   n - an integer specifying the number of periods or
    #       terms to use in each rolling/moving sample.
    #   FUN - the rolling function, arguments to this function can be
    #       passed through the \code{\dots} argument.

    # FUNCTION:

    if (n < 1) { stop('n < 1')  }
    x = as.vector(x)
	add <- rep(NA, (n-1))
	x <- c(add, x)
    names(x) = NULL
	n <- round(n)

    # Roll FUN:
    start = 1
    end = length(x)-n+1
    m = x[start:end]
    for (i in 2:n) {
        start = start + 1
        end = end + 1
        m = cbind(m, x[start:end])
    }
    # Result:
    apply(m, MARGIN = 1, FUN = fun)
}
