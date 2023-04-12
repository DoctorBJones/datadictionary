testthat::test_that("length", {

  testthat::expect_length(
    summarise_variable(
      readRDS(file = testthat::test_path("testdata", 'tester.rds')),
      "start_date"),
    5
  )

  testthat::expect_equal(
    nrow(summarise_variable(
      readRDS(file = testthat::test_path("testdata", 'tester.rds')),
      "lab_location")),
    3
  )

})

# Errors

testthat::test_that("error", {

  testthat::expect_warning(
    summarise_variable(
      readRDS(file = testthat::test_path("testdata", 'tester.rds')),
      "bad_factor"),
    "bad_factor has more than 10 levels, did you want a character variable?"
  )

  testthat::expect_warning(
    summarise_variable(
      readRDS(file = testthat::test_path("testdata", 'tester.rds')),
      "bad_labels"),
    "bad_labels has different numbers of labels and levels. It has been treated as numeric"
    )

})

# test each data class
testthat::test_that("classes", {

  #'Date' class
  sd <- summarise_variable(
    readRDS(file = testthat::test_path("testdata",'tester.rds')),
    "start_date")

  testthat::expect_equal(
    sd$value[1],
    "2022-02-17"
  )

  # POSIX date class
  ed <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "end_date")

  testthat::expect_equal(
    ed$value[2],
    "2022-01-20 2022-04-18 2022-04-22"
  )

  # factor class
  g <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "gender")

  testthat::expect_equal(
    g$summary[1],
    "Female (1)"
  )

  # integer
  a <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "age")

  testthat::expect_equal(
    a$value[4],
    "49"
  )

  # haven labelled
  s <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "state")

  testthat::expect_equal(
    s$summary[3],
    "Qld (3)"
  )

  # haven partially labelled
  p <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "bad_labels")

  testthat::expect_equal(
    p$summary[1],
    "mean"
  )

  # difftime
  d <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "duration")

  testthat::expect_equal(
    d$value[2],
    "20"
  )

  # ordered factor
  l <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "likert")

  testthat::expect_equal(
    l$summary[3],
    "Disagree (3)"
  )

  # double
  d <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "speed")

  testthat::expect_equal(
    d$value[3],
    "3.83"
  )

  # character

  testthat::expect_warning(
    summarise_variable(readRDS(file = testthat::test_path("testdata",'tester.rds')), "comments"),
    "comments has fewer than 10 unique values, did you want a factor?"
  )

  c  <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "suggestions")
  testthat::expect_equal(
    c$summary,
    c("unique responses", "missing")
  )

  # logical
  log <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "lab_location")

  testthat::expect_equal(
    log$summary[2],
    "TRUE"
  )

  # datetime
  dttm <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "effective_date")

  testthat::expect_equal(
    dttm$value[1],
    "2022-04-13"
  )

  # all missing values
  nas <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "all_missing")

  testthat::expect_equal(
    nas$value[1],
    "11"
  )

  # times
  time <- summarise_variable(
    readRDS(file = testthat::test_path("testdata", 'tester.rds')),
    "time_recorded")

  testthat::expect_equal(
    time$value[4],
    "21:36:52"
  )

})

testthat::test_that("NA and mode", {

  testthat::expect_equal(
    nrow(summarise_variable(
      readRDS(file = testthat::test_path("testdata", 'tester.rds')),
      "all_missing")),
    1
  )

  tester <- readRDS(file = testthat::test_path("testdata", 'tester.rds'))

  testthat::expect_equal(
    mode_stat(tester$start_date),
    c(18996, 19084)
  )

})
