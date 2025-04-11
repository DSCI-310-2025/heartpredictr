library(testthat)
library(dplyr)
library(broom)
library(tibble)

test_that("Function returns significant variables correctly", {
  data <- make_fake_heart_data(50)
  result <- get_significant_variables(data, target = "Heart_Attack_Risk", p_thresh = 0.2)

  expect_type(result, "character")
  expect_true(length(result) >= 0)
  expect_true(all(result %in% names(data)))
})

test_that("Function returns empty when no variable is significant", {
  data <- make_non_sig_data(30)
  result <- get_significant_variables(data, target = "Heart_Attack_Risk", p_thresh = 0.01)

  expect_type(result, "character")
  expect_length(result, 0)
})

test_that("Function handles input errors correctly", {
  data <- make_fake_heart_data()

  expect_error(get_significant_variables(42), "data frame")
  expect_error(get_significant_variables(data, target = "not_a_column"), "Target column not found")
  expect_error(get_significant_variables(data, p_thresh = -0.2), "p_thresh must be between 0 and 1")
})

test_that("Function works with missing values (after removing NAs)", {
  data <- make_data_with_nas(10)
  data <- na.omit(data)
  data$Heart_Attack_Risk <- factor(data$Heart_Attack_Risk)

  expect_silent({
    result <- get_significant_variables(data)
  })
  expect_type(result, "character")
})
