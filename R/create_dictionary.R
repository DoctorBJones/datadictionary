
#' Create a data dictionary from any dataset
#'
#'
#' @param dataset The dataset you wish to summarise
#' @param file The filepath the write an Excel spreadsheet (optional)
#' @param var_labels A named vector of variable labels (optional)
#' @param id_var A variable or vector of variables that are identifiers (optional)
#' @param ... Other arguments

#' @return Either an Excel spreadsheet or a dataframe
#'
#' @importFrom haven 'as_factor'
#' @importFrom data.table '%like%'
#' @importFrom openxlsx 'write.xlsx'
#' @importFrom Hmisc 'upData'
#'
#' @examples
#'  create_dictionary(esoph)
#'
#'  mtcars$id <- 1:nrow(mtcars)
#'  create_dictionary(mtcars, id_var = "id")
#'
#'  iris.labels <- c(Sepal.Lenth = "Sepal length in mm", Sepal.Width = "Sepal width in mm")
#'  create_dictionary(iris, var_labels = iris.labels)
#'
#' @export
create_dictionary <- function(dataset,  file = NULL, var_labels = NULL, id_var = NULL, ...) {

  if (is.null(file)) {
    output = TRUE
  } else {
    output = FALSE
  }

  if (! is.null(var_labels)) {
    dataset <- Hmisc::upData(dataset, labels = var_labels)
  }

  # initialise empty dataframe that will be the output
  out <- data.frame()

  # create internal variable for the dataset
  df <- dataset

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
