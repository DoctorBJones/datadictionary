

mode_stat <- function(x, freq = FALSE) {
  z <- 2
  if (freq)
    z <- 1:2
  run <- x

  run <- as.vector(run)

  run <- sort(run)

  run <- rle(run)

  run <- unclass(run)

  run <- data.frame(run)

  colnames(run) <- c("freq", "value")

  run[which(run$freq == max(run$freq)), z]
}
