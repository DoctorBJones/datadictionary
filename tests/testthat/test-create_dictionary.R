
testthat::test_that("errors", {
  testthat::expect_error(
    create_dictionary(c(1,2,3,4)),

    "You can only make a dictionary for a dataframe or tibble"
  )
})


testthat::expect_equal(
  nrow(create_dictionary(esoph)),
  29
)
