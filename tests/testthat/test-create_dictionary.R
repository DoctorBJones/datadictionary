
testthat::test_that("errors", {

  testthat::expect_error(
    create_dictionary(c(1,2,3,4)),
    "You can only make a dictionary for a dataframe or tibble"
  )

  testthat::expect_error(
    create_dictionary(iris, file = "test.csv"),
    "You can only write to Excel files with extension `.xlsx`"
  )

})

testthat::test_that("dictionary",{

  # overall summary
  over <- create_dictionary(
    readRDS(file = testthat::test_path("testdata", 'tester_no_error.rds')),
    id_var = "id")

  testthat::expect_equal(over$summary[1],
                         "Rows in dataset"
  )

  testthat::expect_equal(over$value[2],
                         "15"
  )

  # dimensions of object
  len <- create_dictionary(
    readRDS(file = testthat::test_path("testdata", 'tester_no_error.rds')),
    id_var = "id")

  testthat::expect_equal(nrow(len),
    67
  )

  # id var properly summarised
  testthat::expect_equal(
    len$label[3],
    "Unique identifier"
  )

  # labelling working correctly

  test_labels <- c(
    id = "ID",
    start_date = "Start date",
    end_date = "End date",
    gender = "Gender",
    age = "Age",
    state = "State",
    duration = "Time taken to complete survey",
    likert = "Agreement",
    speed = "How fast",
    suggestions = "Policy suggestions",
    lab_location = "Location",
    effective_date = "Date recorded",
    all_missing = "Missing data",
    time_recorded = "Time recorded",
    labelled_data = "Labelled"
                   )

  lab <- create_dictionary(
    readRDS(file = testthat::test_path("testdata", 'tester_no_error.rds')),
    id_var = "id", var_labels = test_labels)

  testthat::expect_equal(
    lab$label[5], "Start date"
  )

  # writing to Excel
  xl <- create_dictionary(
    readRDS(file = testthat::test_path("testdata", 'tester_no_error.rds')),
    file = "test.xlsx")

  testthat::test_path(
    "~/test.xlsx"
  )

})

