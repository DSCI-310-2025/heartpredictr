# R/data_preparation.R

#' Prepare Heart Attack Risk Dataset
#'
#' @description
#' Loads a dataset and performs necessary preprocessing, then splits it into training and test sets
#'
#' @param file_path Path to the data file
#' @param target_col Name of the target variable column
#' @param train_ratio Proportion of data for training (between 0-1)
#' @param random_seed Seed for reproducibility
#'
#' @return A list containing train_data and test_data dataframes
#'
#' @examples
#' data_splits <- prepare_heart_data("data/heart_attack.csv")
#' train_data <- data_splits$train_data
#' test_data <- data_splits$test_data
#'
#' @export
prepare_heart_data <- function(file_path,
                               target_col = "Heart_Attack_Risk",
                               train_ratio = 0.7,
                               random_seed = 123) {
  # Input validation
  if (!file.exists(file_path)) {
    stop("Data file does not exist: ", file_path)
  }

  if (train_ratio <= 0 || train_ratio >= 1) {
    stop("Training ratio must be between 0 and 1")
  }

  # Set random seed
  set.seed(random_seed)

  # Read data
  data <- readr::read_csv(file_path)

  # Check if target column exists
  if (!target_col %in% colnames(data)) {
    stop("Target column '", target_col, "' not found in dataset")
  }

  # Ensure target variable is a factor
  data[[target_col]] <- as.factor(data[[target_col]])

  # Split dataset
  data_split <- caret::createDataPartition(data[[target_col]],
                                           p = train_ratio,
                                           list = FALSE)

  train_data <- data[data_split, ]
  test_data <- data[-data_split, ]

  # Return split data
  return(list(
    train_data = train_data,
    test_data = test_data
  ))
}
