# tests/testthat/test-data_preparation.R

library(testthat)
library(readr)
library(dplyr)

# Define helper functions directly in the test file

# Write a data frame to a temporary CSV file and return the file path
write_to_temp_csv <- function(df) {
  temp_file <- tempfile(fileext = ".csv")
  readr::write_csv(df, temp_file)
  return(temp_file)
}

# Generate fake heart data for testing
make_fake_heart_data <- function(n = 100) {
  set.seed(123)
  data.frame(
    Age = sample(30:80, n, replace = TRUE),
    Cholesterol = round(runif(n, 150, 300)),
    Heart_Attack_Risk = sample(c(0, 1), n, replace = TRUE)
  )
}

test_that("prepare_heart_data correctly splits data", {
  # Create test data using the helper function
  test_data <- make_fake_heart_data(100)

  # Write test_data to a temporary CSV file using helper function
  temp_file <- write_to_temp_csv(test_data)

  # Call the function under test
  result <- prepare_heart_data(temp_file, train_ratio = 0.7, random_seed = 123)

  # Check the structure of the returned list
  expect_type(result, "list")
  expect_named(result, c("train_data", "test_data"))

  # Verify the data split: training set rows should be greater than test set rows,
  # and the total number of rows should equal the original data's row count
  expect_gt(nrow(result$train_data), nrow(result$test_data))
  expect_equal(nrow(result$train_data) + nrow(result$test_data), nrow(test_data))

  # Ensure the target variable is converted to a factor
  expect_s3_class(result$train_data$Heart_Attack_Risk, "factor")
  expect_s3_class(result$test_data$Heart_Attack_Risk, "factor")

  unlink(temp_file)
})

test_that("prepare_heart_data works with extreme train_ratio values", {
  test_data <- make_fake_heart_data(100)

  temp_file <- write_to_temp_csv(test_data)

  # Test with an extreme train_ratio, e.g., 0.99
  result <- prepare_heart_data(temp_file, train_ratio = 0.99, random_seed = 123)

  expect_gt(nrow(result$train_data), 95)
  expect_lt(nrow(result$test_data), 5)

  unlink(temp_file)
})

test_that("prepare_heart_data throws appropriate errors for invalid inputs", {
  # Should throw an error if the file does not exist
  expect_error(
    prepare_heart_data("nonexistent_file.csv"),
    "Data file does not exist"
  )

  # Should throw an error if the target column is missing
  test_data <- data.frame(Age = 1:10, Cholesterol = runif(10, 150, 300))
  temp_file <- write_to_temp_csv(test_data)

  expect_error(
    prepare_heart_data(temp_file, target_col = "Heart_Attack_Risk"),
    "Target column 'Heart_Attack_Risk' not found"
  )

  # Should throw an error if train_ratio is out of valid range
  test_data$Heart_Attack_Risk <- sample(c(0, 1), 10, replace = TRUE)
  temp_file <- write_to_temp_csv(test_data)

  expect_error(
    prepare_heart_data(temp_file, train_ratio = 1.5),
    "Training ratio must be between 0 and 1"
  )

  unlink(temp_file)
})
