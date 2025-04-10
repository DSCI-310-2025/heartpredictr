
# heartpredictr <img src="https://img.shields.io/badge/version-0.0.0.9000-blue" align="right" />

![R-CMD-check](https://github.com/DSCI-310-2025/heartpredictr/actions/workflows/R-CMD-check.yaml/badge.svg)
[![codecov](https://codecov.io/gh/DSCI-310-2025/heartpredictr/branch/main/graph/badge.svg)](https://codecov.io/gh/DSCI-310-2025/heartpredictr)

> 📦 A helper package for heart attack risk prediction in India

The `heartpredictr` R package provides reusable and tested helper
functions to support data preprocessing, visualization, and variable
selection for building heart attack risk prediction models.

It is designed for modularity, reproducibility, and ease of use in
health data science workflows, particularly focused on epidemiological
modeling in the Indian context.

------------------------------------------------------------------------

## 📦 Installation

Install the development version from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("DSCI-310-2025/heartpredictr")
```

------------------------------------------------------------------------

## 🔧 Main Functions

The package currently includes four key functions:

- `clean_heart_data()` — Cleans raw heart data and converts relevant
  variables to factors.
- `prepare_heart_data()` — Loads and splits data into train/test sets,
  with error handling.
- `create_correlation_heatmap()` — Generates a correlation heatmap from
  numeric/factor data.
- `get_significant_variables()` — Returns significant predictors based
  on logistic regression.

Each function handles errors gracefully and has been tested using
`testthat`.

------------------------------------------------------------------------

## 💻 Usage Example

``` r
library(heartpredictr)

# Load and prepare sample heart data
data_path <- "data/heart_attack.csv"
splits <- prepare_heart_data(data_path, target_col = "Heart_Attack_Risk", train_ratio = 0.7)

# Clean the training data
train_clean <- clean_heart_data(splits$train_data)

# Visualize correlation
create_correlation_heatmap(train_clean)

# Get significant variables
get_significant_variables(train_clean, target = "Heart_Attack_Risk", p_thresh = 0.05)
```

------------------------------------------------------------------------

## 📊 Background

This package was developed as part of the DSCI 310 course at UBC to
support our group project on heart attack risk prediction in India,
based on [this Kaggle
dataset](https://www.kaggle.com/datasets/ankushpanday2/heart-attack-risk-and-prediction-dataset-in-india).

------------------------------------------------------------------------

## ✅ Testing and CI

- All functions include unit and integration tests using `testthat`.
- GitHub Actions are configured to automatically run these tests on each
  push (CI).

------------------------------------------------------------------------

## 📄 License

This project is licensed under the [MIT License](LICENSE.md).

------------------------------------------------------------------------

## 🙌 Contributors

- Chengyou Xiang  
- Junhao Wen  
- Peng Zhong  
- ZiXun Fang
