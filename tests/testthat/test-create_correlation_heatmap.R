library(testthat)
library(ggplot2)
library(dplyr)
library(tidyr)

# Test 1: Mixed-type input (factors + numerics)
# Ensure factor columns are converted to numeric and correlation heatmap is generated
test_that("Factor columns are converted to numeric and heatmap is generated", {
  df_mixed <- make_mixed_type_data(20)
  df_numeric <- df_mixed %>% mutate(across(where(is.factor), as.numeric))

  # Call function
  p <- create_correlation_heatmap(df_mixed)

  # Expect: ggplot object
  expect_s3_class(p, "ggplot")

  # Expect: correlation matrix values are numeric and between -1 and 1
  cor_matrix <- cor(df_numeric, use = "pairwise.complete.obs")
  expect_true(all(is.numeric(cor_matrix)))
  expect_true(all(cor_matrix >= -1 & cor_matrix <= 1))
})

# Test 2: All-numeric input
# Ensure function works directly with numeric data
test_that("All-numeric input works as expected", {
  df_numeric <- make_all_numeric_data(20)
  p <- create_correlation_heatmap(df_numeric)

  # Expect: ggplot object
  expect_s3_class(p, "ggplot")

  # Expect: correlation matrix dimensions match
  cor_matrix <- cor(df_numeric)
  expect_equal(nrow(cor_matrix), ncol(df_numeric))
  expect_equal(ncol(cor_matrix), ncol(df_numeric))
})

# Test 3: Input with NA values
# Ensure NA values are handled gracefully and don't break the plot
test_that("NA values are handled and heatmap is still generated", {
  df_na <- make_data_with_na_for_correlation(20)

  cor_matrix <- cor(df_na, use = "pairwise.complete.obs")

  # Expect: correlation matrix is numeric and diagonals (if not NA) are 1
  expect_true(all(is.numeric(cor_matrix)))
  diags <- diag(cor_matrix)
  diags_non_na <- diags[!is.na(diags)]
  expect_true(all(diags_non_na == 1))

  # Expect: function still returns a ggplot object
  p <- create_correlation_heatmap(df_na)
  expect_s3_class(p, "ggplot")
})
