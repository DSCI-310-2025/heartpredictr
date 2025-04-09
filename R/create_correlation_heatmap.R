#' Create a correlation heatmap from a data frame
#'
#' This function converts factor columns to numeric if needed, calculates
#' the correlation matrix, and returns a heatmap plot.
#'
#' @param df A data frame with numeric and/or factor columns
#' @return A ggplot object representing the correlation heatmap
#' @export
create_correlation_heatmap <- function(df) {
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  df_numeric <- df %>% mutate(across(where(is.factor), as.numeric))

  cor_matrix <- cor(df_numeric, use = "pairwise.complete.obs")
  cor_data <- as_tibble(cor_matrix, rownames = "var1") %>%
    pivot_longer(-var1, names_to = "var2", values_to = "corr")

  ggplot(cor_data, aes(x = var1, y = var2, fill = corr)) +
    geom_tile(color = "white") +
    geom_text(aes(label = round(corr, 2)), color = "black", size = 3) +
    scale_fill_distiller(palette = "YlOrRd", direction = 1, limits = c(-1,1)) +
    labs(title = "Correlation Heatmap", x = "", y = "") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
