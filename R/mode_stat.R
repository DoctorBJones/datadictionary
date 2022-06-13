
#' Calculate mode (statistic)
#'
#' @param x A vector
#' @param freq If true the frequency of the mode will display.
#'
#' @return if freq = FALSE mode_stat will return a single value. If freq = TRUE it will return a dataframe
#'
#' @examples foo <- sample(x = c("L1", "L2", "L3", "L4", "L5"), size = 200, replace = TRUE,
#'   prob = c(0.2, 0.4, 0.1, 0.05, 0.25))
#' bar <- floor(rnorm(n = 200, mean = 50, sd = 5))
#' dat <- as.data.frame(cbind(foo, bar))
#'
#' mode_stat(dat$foo)
#'
#' mode_stat(dat$bar, freq = TRUE)
#'
#' @export
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
