#' Create a correlation heatmap from a data frame
#'
#' This function converts factor columns to numeric if needed, calculates
#' the correlation matrix, and returns a heatmap plot.
#'
#' @param df A data frame with numeric and/or factor columns
#' @return A ggplot object representing the correlation heatmap
#' @export
#' @importFrom dplyr mutate across
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot aes geom_tile geom_text scale_fill_distiller labs theme_minimal theme element_text
#' @importFrom stats cor
create_correlation_heatmap <- function(df) {
  df_numeric <- dplyr::mutate(df, dplyr::across(where(is.factor), as.numeric))

  cor_matrix <- stats::cor(df_numeric, use = "pairwise.complete.obs")
  cor_data <- tibble::as_tibble(cor_matrix, rownames = "var1") |>
    tidyr::pivot_longer(-var1, names_to = "var2", values_to = "corr")

  ggplot2::ggplot(cor_data, ggplot2::aes(x = var1, y = var2, fill = corr)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::geom_text(ggplot2::aes(label = round(corr, 2)), color = "black", size = 3) +
    ggplot2::scale_fill_distiller(palette = "YlOrRd", direction = 1, limits = c(-1, 1)) +
    ggplot2::labs(title = "Correlation Heatmap", x = "", y = "") +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}
