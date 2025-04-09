library(testthat)

# Expected use case: function should clean and convert columns correctly
test_that("clean_heart_data returns cleaned data frame", {
  test_df <- make_heart_data(50)
  df_cleaned <- clean_heart_data(test_df)

  # 1. Should return a data.frame or tibble
  expect_s3_class(df_cleaned, "data.frame")

  # 2. Should not contain columns that are supposed to be removed
  expect_false(any(c("Patient_ID", "State_Name", "Gender") %in% colnames(df_cleaned)))

  # 3. All columns should be factors
  expect_true(all(sapply(df_cleaned, is.factor)))
})

# Edge case: input is an empty tibble
test_that("clean_heart_data returns empty tibble if given empty tibble", {
  test_df <- make_heart_data(50)
  empty_input <- test_df[0, ]
  df_cleaned <- clean_heart_data(empty_input)

  expect_equal(nrow(df_cleaned), 0)
  expect_equal(ncol(df_cleaned), ncol(test_df) - 3)  # Should retain all columns except 3 removed ones
})

# Error case: input is not a data frame
test_that("clean_heart_data throws error for non-dataframe input", {
  test_df <- make_heart_data(50)
  expect_error(clean_heart_data("not a dataframe"))
  expect_error(clean_heart_data(list(a = 1, b = 2)))
})
