#' Clean Heart Attack Dataset
#'
#' Removes unnecessary columns and converts relevant columns to factors.
#'
#' @param df A data frame of raw heart attack data.
#'
#' @return A cleaned data frame with selected columns and categorical columns converted to factors.
#' @export
clean_heart_data <- function(df) {
  df_clean <- df %>%
    dplyr::select(-Patient_ID, -State_Name, -Gender) %>%
    dplyr::mutate(
      Diabetes = as.factor(Diabetes),
      Hypertension = as.factor(Hypertension),
      Obesity = as.factor(Obesity),
      Smoking = as.factor(Smoking),
      Alcohol_Consumption = as.factor(Alcohol_Consumption),
      Physical_Activity = as.factor(Physical_Activity),
      Air_Pollution_Exposure = as.factor(Air_Pollution_Exposure),
      Family_History = as.factor(Family_History),
      Heart_Attack_History = as.factor(Heart_Attack_History),
      Health_Insurance = as.factor(Health_Insurance),
      Heart_Attack_Risk = as.factor(Heart_Attack_Risk)
    )
  return(df_clean)
}
