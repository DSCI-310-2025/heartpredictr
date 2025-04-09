#' Get significant variables from logistic regression model
#'
#' This function trains a logistic regression model and returns the names of variables
#' whose p-values are below a specified threshold.
#'
#' @param data A data frame with predictor variables and a binary target variable.
#' @param target Name of the binary outcome column (as a string).
#' @param p_thresh Significance threshold for p-values (default = 0.15)
#'
#' @return A character vector of significant variable names.
#' @export
get_significant_variables <- function(data, target = "Heart_Attack_Risk", p_thresh = 0.15) {
  if (!is.data.frame(data)) stop("Input must be a data frame.")
  if (!(target %in% names(data))) stop("Target column not found in data.")
  if (!is.numeric(p_thresh) || p_thresh <= 0 || p_thresh >= 1) stop("p_thresh must be between 0 and 1.")

  formula <- as.formula(paste(target, "~ ."))
  model <- glm(formula, data = data, family = binomial)

  sig_vars <- broom::tidy(model) |>
    dplyr::filter(term != "(Intercept)" & p.value < p_thresh) |>
    dplyr::pull(term)

  return(sig_vars)
}
