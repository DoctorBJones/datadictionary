
#' Create a data dictionary from any dataset
#'
#' Note: you must specify one of output = TRUE or supply an argument to file.
#'
#' @param dataset The dataset you wish to summarise
#' @param id_var A variable or vector of variables that are identifiers (optional)
#' @param file The filepath the write an Excel spreadsheet
#' @param output Output to console (default = FALSE)
#' @param ... Other arguments

#' @return Either an Excel spreadsheet or a dataframe
#'
#' @importFrom haven 'as_factor'
#' @importFrom data.table '%like%'
#' @importFrom openxlsx 'write.xlsx'
#'
#' @export
create_dictionary <- function(dataset, id_var = NULL, file = NULL, output = FALSE, ...) {

  # must have at least one of output or file, but only one
  if ((!is.null(file)) && output == TRUE) {
    stop("You must specify only one of 'output' or 'file'")
  }

  if (is.null(file) && output == FALSE) {
    stop("You must specify one of 'output' or 'file'")
  }

  # initialise empty dataframe that will be the output
  out <- data.frame()

  # create internal variable for the dataset
  df <- dataset

  # check if there are any labelled vars, and coerce to factor if TRUE
  if (any(lapply(dataset, class) %like% "label")) {
    df <- haven::as_factor(dataset, only_labelled = TRUE)
    warning("Labelled data has been coerced to a factor")
  }

  # Use the id summary function for id var/s
  # remove the id vars from internal version of the data
  # once the summary is done so it doesn't get replicated
  if (! is.null(id_var)) {
    vec <- id_var

    for (i in vec) {
      f <- id_summary(dataset, i)

      out <- rbind(out, f)

      df <- df[, ! names(df) == i]    }
  }


  # find the names of the internal dataframe to iterate over
  df_col <- colnames(df)

  # summarise each column and append the summary to the output
  for (col in df_col) {

    x <- summarise_variable(df, col)

    out <- rbind(out, x)
  }

  if (output == FALSE) {

    openxlsx::write.xlsx(out, file = file)

  } else {

    return(out)

  }

}
