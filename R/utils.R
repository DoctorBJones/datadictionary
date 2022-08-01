
#' @importFrom tidyr 'pivot_longer'
#' @importFrom tidyselect 'everything'
#' @importFrom stats 'median'
#' @importFrom lubridate 'date'
#' @importFrom dplyr 'mutate'
#' @importFrom tibble 'rownames_to_column'
#' @importFrom chron 'as.times'
#' @import magrittr


factor_summary <- function(dataset, column) {
  a <- as.data.frame(table(dataset[[column]]))
  names(a)[1] <- "summary"

  # throw a warning in case it should be numeric or character
  if (nrow(a) > 10) {
    msg <- paste0(column, " has more than 10 levels, did you want a character variable?")
    warning(msg)
  }

  # this creates the factor level with it's value in parentheses
  # e.g. Strongly disagree (5)

  a <- a %>%
    dplyr::mutate(summary = paste(summary,
                                  " (",
                                  as.numeric(summary),
                                  ")", sep = ""))

  names(a)[2] <- "value"

  a$item <- ""
  a$item[1] <- gsub('"', '', deparse(column))

  a$class <- ""
  a$class[1] <-
    paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(is.null(attr(dataset[[column]], "label")),
                       "No label", attr(dataset[[column]], "label"))
  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]
  a[nrow(a) + 1, ] <-
    c("", "", "", "missing", sum(is.na(dataset[[column]])))

  a$value <- as.character(a$value)
  return(a)
}

numeric_summary <- function(dataset, column) {

  var <- dataset[[column]]

  a <- as.data.frame(round(mean(var, na.rm = TRUE)), digits = 2)
  names(a)[1] <- "mean"

  a$median = as.numeric(round(median(var, na.rm = TRUE)), digits = 2)
  a$min = round(min(var, na.rm = TRUE), digits = 2)
  a$max = round(max(var, na.rm = TRUE), digits = 2)
  a$missing = sum(is.na(dataset[[column]]))

  a <- a %>%
    pivot_longer(cols = everything(),
                 names_to = "summary",
                 values_to = "value",
                 values_transform = list(value = as.character))

  # pivot_longer creates a tibble which actually messes with output
  a <- as.data.frame(a) # so coerce to df

  a$item <- ""
  a$item[1] <- gsub('"','', deparse(column))

  a$class <- ""
  a$class[1] <- paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(
    is.null(attr(dataset[[column]], "label")),
    "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")

  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}

character_summary <- function(dataset, column) {
  var <- dataset[[column]]


  a <- as.data.frame(length(unique(var)))
  names(a)[1] <- "unique responses"

  a$missing <- sum(is.na(var))

  a <- a %>%
    pivot_longer(cols = everything(), names_to = "summary")

  if (a$value[1] < 10) {
    msg <- paste0(column, " has fewer than 10 unique values, did you want a factor?")
    warning(msg)
  }

  a <- as.data.frame(a)

  a$item <- ""
  a$item[1] <- gsub('"', '', deparse(column))

  a$class <- ""
  a$class[1] <-
    paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(is.null(attr(dataset[[column]], "label")),
                       "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}


logical_summary <- function(dataset, column) {

  a <- as.data.frame(table(dataset[[column]]))
  names(a)[1] <- "summary"
  names(a)[2] <- "value"

  a$item <- ""
  a$item[1] <- gsub('"', '', deparse(column))

  a$class <- ""
  a$class[1] <- paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(
    is.null(attr(dataset[[column]], "label")),
    "No label", attr(dataset[[column]], "label")
  )

  vars <- c("item", "label", "class", "summary", "value")

  a <- a[, vars]
  a$summary <- as.character(a$summary)
  a[nrow(a) + 1, ] <- c("", "", "", "missing", sum(is.na(dataset[[column]])))

  a$value <- as.character(a$value)

  return(a)

}


datetime_summary <- function(dataset, column) {
  var <- lubridate::date(dataset[[column]])

  a <- as.data.frame(as.character(mean(var, na.rm = TRUE)))
  names(a)[1] <- "mean"

  date_mode <- as.Date(mode_stat(var), origin = '1970-01-01')
  a$mode = paste(date_mode, sep = ", ", collapse = " ")
  a$min = as.character(min(var, na.rm = TRUE))
  a$max = as.character(max(var, na.rm = TRUE))
  a$missing = as.character(sum(is.na(dataset[[column]])))

  a <- a %>%
    pivot_longer(cols = everything(), names_to = "summary")
  a <- as.data.frame(a)

  a$item <- ""
  a$item[1] <- gsub('"', '', deparse(column))

  a$class <- ""
  a$class[1] <-
    paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(is.null(attr(dataset[[column]], "label")),
                       "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}

times_summary <- function(dataset, column) {

  a <- as.data.frame(as.character(mean(dataset[[column]], na.rm = TRUE)))
  names(a)[1] <- "mean"

  a$median = as.character(median(dataset[[column]], na.rm = TRUE))
  a$min = as.character(min(dataset[[column]], na.rm = TRUE))
  a$max = as.character(max(dataset[[column]], na.rm = TRUE))
  a$missing = as.character(sum(is.na(dataset[[column]])))

  a <- a %>%
    pivot_longer(cols = everything(), names_to = "summary")
  a <- as.data.frame(a)
  # a$value <- as.Date(a$value, format = "%Y-%m-%d")

  a$item <- ""
  a$item[1] <- gsub('"','', deparse(column))

  a$class <- ""
  a$class[1] <- paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(
    is.null(attr(dataset[[column]], "label")),
    "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}


label_summary <- function(dataset, column) {
  label_values <-
    as.data.frame(attributes(dataset[[column]])$labels) %>%
    rownames_to_column()

  names(label_values)[1] <- "label"
  names(label_values)[2] <- "value"

  label_values$summary <-
    paste(label_values$label, " (", label_values$value, ")",
          sep = "")

  a <- as.data.frame(table(dataset[[column]]))
  names(a)[1] <- "num_val"
  names(a)[2] <- "value"

  a <- merge(a, label_values, by.x = "num_val", by.y = "value")

  a$item <- ""
  a$item[1] <- gsub('"', '', deparse(column))

  a$class <- ""
  a$class[1] <-
    paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(is.null(attr(dataset[[column]], "label")),
                       "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]
  a[nrow(a) + 1, ] <-
    c("", "", "", "missing", sum(is.na(dataset[[column]])))
  a$value <- as.character(a$value)

  return(a)

}

difftimes_summary <- function(dataset, column) {

  var <- dataset[[column]]

  a <- as.data.frame(floor(mean(var, na.rm = TRUE)))
  names(a)[1] <- "mean"

  a$median = median(var, na.rm = TRUE)
  a$min = min(var, na.rm = TRUE)
  a$max = max(var, na.rm = TRUE)
  a$missing = sum(is.na(dataset[[column]]))

  a <- a %>%
    pivot_longer(cols = everything(),
                 names_to = "summary",
                 values_to = "value",
                 values_transform = list(value = as.character))

  # pivot_longer creates a tibble which actually messes with output
  a <- as.data.frame(a) # so coerce to df

  a$item <- ""
  a$item[1] <- gsub('"','', deparse(column))

  a$class <- ""
  a$class[1] <- paste(class(dataset[[column]]), sep = " ", collapse = " ")

  a$label <- ""
  a$label[1] <- ifelse(
    is.null(attr(dataset[[column]], "label")),
    "No label", attr(dataset[[column]], "label"))

  vars <- c("item", "label", "class", "summary", "value")

  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}


id_summary <- function(dataset, column) {
  var <- dataset[[column]]

  item <- gsub('"', '', deparse(column))
  label <- "Unique identifier"
  class <- ""
  summary <- "unique values"
  value <- length(unique(var))

  a <- data.frame(item, label, class, summary, value)
  a[nrow(a) + 1, ] <-
    c("", "", "", "missing", sum(is.na(dataset[[column]])))

  a$value <- as.character(a$value)

  return(a)
}

allna_summary <- function(dataset, column) {
  a <- data.frame(
    item = gsub('"', '', deparse(column)),
    label = ifelse(is.null(attr(dataset[[column]], "label")),
                   "No label", attr(dataset[[column]], "label")),
    class = paste(class(dataset[[column]]), sep = " ", collapse = " "),
    summary = "missing",
    value = length(dataset[[column]])
  )
}

dataset_summary <- function(dataset) {
  x <- as.data.frame(nrow(dataset))
  y <- as.data.frame(ncol(dataset))

  a <- cbind(x, y)
  names(a)[1] <- "Rows in dataset"
  names(a)[2] <- "Columns in dataset"

  a <- a %>%
    pivot_longer(cols = everything(), names_to = "summary")
  a <- as.data.frame(a)

  a$item <- ""

  a$class <- ""

  a$label <- ""

  vars <- c("item", "label", "class", "summary", "value")
  a <- a[, vars]

  a$value <- as.character(a$value)

  return(a)
}

#' Get the mode of a vector
#' @param x A vector
#' @param freq Boolean when TRUE returns the frequency of the mode
#' @keywords internal
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
