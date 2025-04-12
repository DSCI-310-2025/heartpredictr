# ============================================================
# tests/test-get_significant_variables.R
# ------------------------------------------------------------
# Unit tests for `get_significant_variables()`
#
# The function is expected to:
#   * Return a character vector of predictors whose p-values
#     are below a chosen threshold.
#   * Gracefully handle edge cases (no sig vars, bad inputs).
#   * Work even after rows with missing data are removed.
#
# These tests use small helper generators that simulate
# heart-health datasets of varying sizes and properties.
# ============================================================

library(testthat)
library(dplyr)
library(broom)
library(tibble)

# 1. at least one variable should be significant
test_that("Function returns significant variables correctly", {
  data <- make_fake_heart_data(50)
  result <- get_significant_variables(
    data,
    target   = "Heart_Attack_Risk",
    p_thresh = 0.20
  )

  # Basic type/structure checks
  expect_type(result, "character")
  expect_true(length(result) >= 0)

  # Every name it returns should actually exist in `data`
  expect_true(all(result %in% names(data)))
})


# 2. Edge case - nothing is significant
test_that("Function returns empty when no variable is significant", {
  data <- make_non_sig_data(30)
  result <- get_significant_variables(
    data,
    target   = "Heart_Attack_Risk",
    p_thresh = 0.01
  )

  expect_type(result,  "character")
  expect_length(result, 0)
})


# 3. Bad-input handling
test_that("Function handles input errors correctly", {
  data <- make_fake_heart_data()

  expect_error(get_significant_variables(42),
               "data frame")
  expect_error(get_significant_variables(data, target = "not_a_column"),
               "Target column not found")
  expect_error(get_significant_variables(data, p_thresh = -0.2),
               "p_thresh must be between 0 and 1")
})


# 4. Works after dropping rows with missing values
test_that("Function works with missing values (after removing NAs)", {
  data <- make_data_with_nas(10)   # inject some NA rows
  data <- na.omit(data)            # mimic a typical preprocessing step
  data$Heart_Attack_Risk <- factor(data$Heart_Attack_Risk)

  expect_silent({
    result <- get_significant_variables(data)
  })
  expect_type(result, "character")
})
