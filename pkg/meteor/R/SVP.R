
SVP <- function(temp, simple = FALSE) {
    .Call(`_meteor_SVP`, temp, simple)
}

VP <- function(temp, relh, simple = FALSE) {
    .Call(`_meteor_VP`, temp, relh, simple)
}

VPD <- function(temp, relh, simple = FALSE) {
    .Call(`_meteor_VPD`, temp, relh, simple)
}