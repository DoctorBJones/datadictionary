
<!-- badges: start -->
[![R-CMD-check](https://github.com/DoctorBJones/datadictionary/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/DoctorBJones/datadictionary/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# datadictionary

The goal of `datadictionary` is to create a data dictionary from any
dataset in your R environment. While other packages exist I found the
output wasn’t able to be easily captured in a single view. They were
either very long, such as many pages of output in word or pdf format, or
very wide, such as concatenating all levels of factor variables in a
single string. This package attempts to solve those problems by
presenting summaries of the dataset in a format that fits easily in a
pane or screen, without using word or pdf outputs. It also presents
different summaries for different variable types.

It includes overall summaries of rows and columns and at-a-glance
summaries of each variable including mean, median, min and max for
numeric variables, counts in each level for factors, and the number of
responses for character variables. All variable summaries include a
count of missing values.

You can nominate one or more id variables, for example individuals and
clusters, so you don’t get nonsense data summaries for these variables.
You can also include a vector to add labels if you want descriptions
included in the document. You can opt for the output to write directly
to Excel.

## Installation

You can install the development version of datadictionary from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("DoctorBJones/datadictionary")
```

## Example

You can print a basic data dictionary directly to your console or assign
it to an object in your environment:

``` r
library(datadictionary)

create_dictionary(esoph)
#>         item    label          class            summary value
#> 1                                       Rows in dataset    88
#> 2                                    Columns in dataset     5
#> 3      agegp No label ordered factor          25-34 (1)    15
#> 4                                             35-44 (2)    15
#> 5                                             45-54 (3)    16
#> 6                                             55-64 (4)    16
#> 7                                             65-74 (5)    15
#> 8                                               75+ (6)    11
#> 9                                               missing     0
#> 10     alcgp No label ordered factor      0-39g/day (1)    23
#> 11                                            40-79 (2)    23
#> 12                                           80-119 (3)    21
#> 13                                             120+ (4)    21
#> 14                                              missing     0
#> 15     tobgp No label ordered factor       0-9g/day (1)    24
#> 16                                            10-19 (2)    24
#> 17                                            20-29 (3)    20
#> 18                                              30+ (4)    20
#> 19                                              missing     0
#> 20    ncases No label        numeric               mean     2
#> 21                                               median     1
#> 22                                                  min     0
#> 23                                                  max    17
#> 24                                              missing     0
#> 25 ncontrols No label        numeric               mean     9
#> 26                                               median     4
#> 27                                                  min     0
#> 28                                                  max    60
#> 29                                              missing     0

esoph_dictionary <- create_dictionary(esoph)
```

You can also specify one or more identifier variables. This is useful if
you have hierarchical data, for example and have identifiers for
individual, clusters or blocks.

``` r

# create fake id variables
mtcars$id1 <- 1:nrow(mtcars)
mtcars$id2 <- mtcars$id1*10

create_dictionary(mtcars, id_var = c("id1", "id2"))
#>    item             label   class            summary value
#> 1                                    Rows in dataset    32
#> 2                                 Columns in dataset    13
#> 3   id1 Unique identifier              unique values    32
#> 4                                            missing     0
#> 5   id2 Unique identifier              unique values    32
#> 6                                            missing     0
#> 7   mpg          No label numeric               mean    20
#> 8                                             median    19
#> 9                                                min  10.4
#> 10                                               max  33.9
#> 11                                           missing     0
#> 12  cyl          No label numeric               mean     6
#> 13                                            median     6
#> 14                                               min     4
#> 15                                               max     8
#> 16                                           missing     0
#> 17 disp          No label numeric               mean   231
#> 18                                            median   196
#> 19                                               min  71.1
#> 20                                               max   472
#> 21                                           missing     0
#> 22   hp          No label numeric               mean   147
#> 23                                            median   123
#> 24                                               min    52
#> 25                                               max   335
#> 26                                           missing     0
#> 27 drat          No label numeric               mean     4
#> 28                                            median     4
#> 29                                               min  2.76
#> 30                                               max  4.93
#> 31                                           missing     0
#> 32   wt          No label numeric               mean     3
#> 33                                            median     3
#> 34                                               min  1.51
#> 35                                               max  5.42
#> 36                                           missing     0
#> 37 qsec          No label numeric               mean    18
#> 38                                            median    18
#> 39                                               min  14.5
#> 40                                               max  22.9
#> 41                                           missing     0
#> 42   vs          No label numeric               mean     0
#> 43                                            median     0
#> 44                                               min     0
#> 45                                               max     1
#> 46                                           missing     0
#> 47   am          No label numeric               mean     0
#> 48                                            median     0
#> 49                                               min     0
#> 50                                               max     1
#> 51                                           missing     0
#> 52 gear          No label numeric               mean     4
#> 53                                            median     4
#> 54                                               min     3
#> 55                                               max     5
#> 56                                           missing     0
#> 57 carb          No label numeric               mean     3
#> 58                                            median     2
#> 59                                               min     1
#> 60                                               max     8
#> 61                                           missing     0
```

You can also optionally add labels for variables that have no labels.
You can specify all columns or only a few. You need to pass a named
vector where the names correspond to columns in your dataset.

``` r

# Create labels as a named vector. 
iris.labels <- c(Sepal.Length = "Sepal length in mm", Sepal.Width = "Sepal width in mm")

create_dictionary(iris, var_labels = iris.labels)
#> Input object size:    7256 bytes;     5 variables     150 observations
#> New object size: 8344 bytes; 5 variables 150 observations
#>            item              label            class            summary value
#> 1                                                      Rows in dataset   150
#> 2                                                   Columns in dataset     5
#> 3  Sepal.Length Sepal length in mm labelled numeric               mean     6
#> 4                                                               median     6
#> 5                                                                  min   4.3
#> 6                                                                  max   7.9
#> 7                                                              missing     0
#> 8   Sepal.Width  Sepal width in mm labelled numeric               mean     3
#> 9                                                               median     3
#> 10                                                                 min     2
#> 11                                                                 max   4.4
#> 12                                                             missing     0
#> 13 Petal.Length           No label          numeric               mean     4
#> 14                                                              median     4
#> 15                                                                 min     1
#> 16                                                                 max   6.9
#> 17                                                             missing     0
#> 18  Petal.Width           No label          numeric               mean     1
#> 19                                                              median     1
#> 20                                                                 min   0.1
#> 21                                                                 max   2.5
#> 22                                                             missing     0
#> 23      Species           No label           factor         setosa (1)    50
#> 24                                                      versicolor (2)    50
#> 25                                                       virginica (3)    50
#> 26                                                             missing     0
```

You can also write directly to Excel from the `create_dictionary`
function if you pass a filepath and name as a quoted string. There is no
visible output for this use.

``` r

create_dictionary(ChickWeight, file = "chickweight_dictionary.xlsx")
```

The package also includes a function to create a summary of a single
variable in your dataset.

``` r

summarise_variable(iris, "Sepal.Length")
#>           item    label   class summary value
#> 1 Sepal.Length No label numeric    mean     6
#> 2                                median     6
#> 3                                   min   4.3
#> 4                                   max   7.9
#> 5                               missing     0

summarise_variable(ChickWeight, "Diet")
#>   item    label  class summary value
#> 1 Diet No label factor   1 (1)   220
#> 2                        2 (2)   120
#> 3                        3 (3)   120
#> 4                        4 (4)   118
#> 5                      missing     0
```
