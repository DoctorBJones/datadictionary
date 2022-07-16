testthat::expect_length(
  summarise_variable(iris, "Species"),
  5
)

testthat::expect_equal(
  nrow(summarise_variable(iris, "Sepal.Length")),
  5
)
