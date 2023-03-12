
#' Create a data dictionary from any dataset
#'
#'
#' @param dataset The dataset you wish to summarise
#' @param file The file path to write an Excel spreadsheet (optional)
#' @param var_labels A named vector of variable labels (optional)
#' @param id_var A variable/vector of variables that are identifiers (optional)

#' @return Either an Excel spreadsheet or a dataframe
#'
#' @importFrom haven 'as_factor'
#' @importFrom data.table '%like%'
#' @importFrom openxlsx 'write.xlsx'
#' @importFrom labelled 'var_label'
#'
#' @examples
#'
#'  # A simple dictionary printed to console
#'  create_dictionary(esoph)
#'
#'  # You can specify id variable/s
#'  mtcars$id <- 1:nrow(mtcars)
#'  create_dictionary(mtcars, id_var = "id")
#'
#'  # You can also specify labels with a named vector
#'  iris.labels <- c(Sepal.Length = "Sepal length in mm",
#'      Sepal.Width = "Sepal width in mm",
#'      Petal.Length = "Petal length in mm",
#'      Petal.Width = "Petal width in mm",
#'      Species = "Species of iris")
#'  create_dictionary(iris, var_labels = iris.labels)
#'
#' @export
create_dictionary <- function(dataset,
                              id_var = NULL,
                              file = NULL,
                              var_labels = NULL) {

  # first check that the argument is correct class
  dataset_class <- class(dataset)

  if (! "data.frame" %in% dataset_class)
    stop("You can only make a dictionary for a dataframe or tibble")

  if (! is.null(file)) {
    if (grepl("xlsx$", file) == FALSE) {
      stop("You can only write to Excel files with extension `.xlsx`")
    }
  }

  if (is.null(file)) {
    output = TRUE
  } else {
    output = FALSE
  }

  if (! is.null(var_labels)) {
    labelled::var_label(dataset) <- var_labels
  }

  # initialise output dataframe with overall summary
  out <- dataset_summary(dataset)

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

      df <- df[, ! names(df) == i]
      }
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
