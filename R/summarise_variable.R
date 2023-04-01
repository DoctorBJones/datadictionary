
#' Summarise a single variable
#'
#' @param dataset The dataset with the variable you wish to summarise
#' @param column The column you wish to summarise as a quoted string
#'
#' @return A dataframe with a summary of the variable
#'
#' @examples
#'  summarise_variable(mtcars, "mpg")
#'
#'  summarise_variable(iris, "Species")

#' @export
summarise_variable <- function(dataset, column) {

  x <- class(dataset[[column]])

  if (sum(is.na(dataset[[column]])) == length(dataset[[column]])) {
    allna_summary(dataset, column)
  } else if ("factor" %in% x) {
    factor_summary(dataset, column)
  } else if ("haven_labelled" %in% x) {
    label_summary(dataset, column)
  } else if ("POSIXt" %in% x | "Date" %in% x) {
    datetime_summary(dataset, column)
  } else if ("times" %in% x) {
    times_summary(dataset, column)
  } else if ("difftime" %in% x |
             "hms" %in% x |
             "ms" %in% x |
             "hm" %in% x) {
    difftimes_summary(dataset, column)
  } else if ("numeric" %in% x ||
             "integer" %in% x ||
             "double" %in% x) {
    numeric_summary(dataset, column)
  } else if ("logical" %in% x |
             "boolean" %in% x ) {
    logical_summary(dataset, column)
  } else {
    character_summary(dataset, column)
  }

}
