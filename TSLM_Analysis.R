
# ============================================================
# ADS 506 FINAL TEAM PROJECT
# INSURANCE LOSS RATIO FORECASTING
#
# TEAM MEMBER 3: TSLM ANALYSIS
# DATA: COMBINED INSURANCE DATASETS (1988-2007)
# MODEL VARIABLE: IncurredLosses
# TRAINING PERIOD: 1988-2003
# TESTING PERIOD: 2004-2007
# VISUALIZATION: DOLLARS IN MILLIONS
# ============================================================


# ============================================================
# 1. LOAD REQUIRED PACKAGES
# ============================================================

required_packages <- c(
  "tidyverse",
  "fpp3",
  "scales"
)

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(tidyverse)
library(fpp3)
library(scales)

# Create Desktop folder for final plots

desktop_plot_dir <- "C:/Users/newer/OneDrive/Desktop/ADS506_Plots"

dir.create(
  desktop_plot_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

# ============================================================
# 2. PROJECT WORKING DIRECTORY
# ============================================================

# Run from the repository root.
# If necessary, change this path to your local project folder.





# Define output folders

output_dir <- "outputs"
plot_dir <- file.path(output_dir, "plots")

dir.create(
  output_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

dir.create(
  plot_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

cat("\nPROJECT DIRECTORY:\n")
print(getwd())


# ============================================================
# 3. IMPORT ORIGINAL DATASETS
# ============================================================

file1_path <- "ppauto_pos_Sep_2011.csv"
file2_path <- "ppauto_pos98-07_Dec_2025.csv"

if (!file.exists(file1_path)) {
  stop("First dataset not found: ", file1_path)
}

if (!file.exists(file2_path)) {
  stop("Second dataset not found: ", file2_path)
}

file1 <- readr::read_csv(
  file1_path,
  show_col_types = FALSE
)

file2 <- readr::read_csv(
  file2_path,
  show_col_types = FALSE
)

cat("\n========== DATASET 1 ==========\n")
print(dim(file1))
print(names(file1))

cat("\n========== DATASET 2 ==========\n")
print(dim(file2))
print(names(file2))



# ============================================================
# 4. STANDARDIZE INCURRED LOSSES
# ============================================================

required_file1 <- c(
  "GRCODE",
  "GRNAME",
  "AccidentYear",
  "DevelopmentYear",
  "DevelopmentLag",
  "IncurLoss_B"
)

required_file2 <- c(
  "GRCODE",
  "GRNAME",
  "AccidentYear",
  "DevelopmentYear",
  "DevelopmentLag",
  "IncurredLosses"
)

if (!all(required_file1 %in% names(file1))) {
  stop("Dataset 1 is missing required columns.")
}

if (!all(required_file2 %in% names(file2))) {
  stop("Dataset 2 is missing required columns.")
}

file1_clean <- file1 %>%
  transmute(
    GRCODE,
    GRNAME,
    AccidentYear,
    DevelopmentYear,
    DevelopmentLag,
    IncurredLosses = IncurLoss_B
  )

file2_clean <- file2 %>%
  transmute(
    GRCODE,
    GRNAME,
    AccidentYear,
    DevelopmentYear,
    DevelopmentLag,
    IncurredLosses
  )

# ============================================================
# 5. COMBINE DATASETS: 1988-2007
# ============================================================

combined_data <- bind_rows(
  file1_clean,
  file2_clean
) %>%
  filter(
    AccidentYear >= 1988,
    AccidentYear <= 2007
  )

cat("\n========== COMBINED DATASET ==========\n")

print(dim(combined_data))

cat(
  "\nAccident years:",
  min(combined_data$AccidentYear, na.rm = TRUE),
  "to",
  max(combined_data$AccidentYear, na.rm = TRUE),
  "\n"
)


# ============================================================
# 6. CHECK MISSING VALUES AND DUPLICATES
# ============================================================

cat("\n========== MISSING VALUES ==========\n")

print(colSums(is.na(combined_data)))

cat("\n========== DUPLICATE OBSERVATIONS ==========\n")

print(sum(duplicated(combined_data)))


# ============================================================
# 7. AGGREGATE ANNUAL INDUSTRY INCURRED LOSSES
# ============================================================

latest_company_losses <- combined_data %>%
  group_by(GRCODE, AccidentYear) %>%
  filter(
    DevelopmentYear == max(DevelopmentYear)
  ) %>%
  ungroup()

annual_industry_losses <- latest_company_losses %>%
  group_by(AccidentYear) %>%
  summarise(
    IncurredLosses = sum(
      IncurredLosses,
      na.rm = TRUE
    ),
    .groups = "drop"
  ) %>%
  arrange(AccidentYear)

write_csv(
  annual_industry_losses,
  file.path(output_dir, "annual_industry_losses.csv")
)

# ============================================================
# 8. CONVERT DATA INTO A TSIBBLE
# ============================================================

ts_data <- annual_industry_losses %>%
  as_tsibble(index = AccidentYear)

cat("\n========== TIME SERIES DATA ==========\n")

print(ts_data)

cat(
  "\nTotal annual observations:",
  nrow(ts_data),
  "\n"
)

# Confirm 20 annual observations

if (nrow(ts_data) != 20) {
  stop(
    "Expected 20 annual observations for 1988-2007. ",
    "Please check the combined datasets."
  )
}


# ============================================================
# 9. SPLIT DATA: TRAINING AND TESTING
# ============================================================

# Training: 1988-2003 (16 observations)
# Testing: 2004-2007 (4 observations)

train_data <- ts_data %>%
  filter(AccidentYear <= 2003)

test_data <- ts_data %>%
  filter(AccidentYear >= 2004)

cat("\n========== TRAINING DATA ==========\n")

print(range(train_data$AccidentYear))
print(nrow(train_data))

cat("\n========== TESTING DATA ==========\n")

print(range(test_data$AccidentYear))
print(nrow(test_data))



# ============================================================
# 10. HISTORICAL INDUSTRY INCURRED LOSSES
# ============================================================

# Convert incurred losses to millions for visualization.
# Original IncurredLosses remains unchanged.

plot_data <- ts_data %>%
  mutate(
    IncurredLosses_Millions = IncurredLosses / 1000000
  )

p1 <- ggplot(
  plot_data,
  aes(
    x = AccidentYear,
    y = IncurredLosses_Millions
  )
) +
  geom_line(
    color = "blue",
    linewidth = 1
  ) +
  geom_point(
    color = "red",
    size = 2
  ) +
  scale_y_continuous(
    labels = scales::label_dollar(
      prefix = "$",
      suffix = "M"
    )
  ) +
  labs(
    title = "Historical Annual Industry Incurred Losses",
    subtitle = "Combined Insurance Data, 1988-2007",
    x = "Accident Year",
    y = "Incurred Losses ($ Millions)"
  ) +
  theme_gray()

print(p1)

ggsave(
  file.path(plot_dir, "historical_losses_millions.png"),
  plot = p1,
  width = 10,
  height = 6,
  dpi = 300
)



# ============================================================
# 11. VISUALIZE TRAINING AND TESTING DATA
# ============================================================

plot_data <- plot_data %>%
  mutate(
    Dataset = if_else(
      AccidentYear <= 2003,
      "Training Data",
      "Testing Data"
    )
  )

p2 <- ggplot(
  plot_data,
  aes(
    x = AccidentYear,
    y = IncurredLosses_Millions,
    color = Dataset
  )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c(
      "Training Data" = "blue",
      "Testing Data" = "red"
    )
  ) +
  scale_y_continuous(
    labels = scales::label_dollar(
      prefix = "$",
      suffix = "M"
    )
  ) +
  labs(
    title = "Training and Testing Data",
    subtitle = "1988-2003 Training; 2004-2007 Testing",
    x = "Accident Year",
    y = "Incurred Losses ($ Millions)",
    color = "Dataset"
  ) +
  theme_gray()

print(p2)

ggsave(
  file.path(plot_dir, "training_testing_millions.png"),
  plot = p2,
  width = 10,
  height = 6,
  dpi = 300
)



# ============================================================
# 12. FIT LINEAR AND QUADRATIC TSLM MODELS
# ============================================================

tslm_models <- train_data %>%
  model(
    Linear_TSLM = TSLM(
      IncurredLosses ~ trend()
    ),
    
    Quadratic_TSLM = TSLM(
      IncurredLosses ~ trend() + I(trend()^2)
    )
  )

cat("\n========== TSLM MODELS ==========\n")

report(tslm_models)


# ============================================================
# 13. MODEL SUMMARIES
# ============================================================

linear_model_only <- train_data %>%
  model(
    Linear_TSLM = TSLM(
      IncurredLosses ~ trend()
    )
  )

quadratic_model_only <- train_data %>%
  model(
    Quadratic_TSLM = TSLM(
      IncurredLosses ~ trend() + I(trend()^2)
    )
  )

cat("\n========== LINEAR MODEL ==========\n")

report(linear_model_only)

cat("\n========== QUADRATIC MODEL ==========\n")

report(quadratic_model_only)


# ============================================================
# 14. GENERATE TSLM FORECASTS
# ============================================================

forecasts <- tslm_models %>%
  forecast(
    new_data = test_data
  )

cat("\n========== FORECAST RESULTS ==========\n")

print(forecasts)


# ============================================================
# 15. FORECAST ACCURACY
# ============================================================

accuracy_results <- forecasts %>%
  accuracy(test_data)

cat("\n========== FORECAST ACCURACY ==========\n")

print(accuracy_results)

write_csv(
  accuracy_results,
  file.path(output_dir, "tslm_accuracy.csv")
)


# ============================================================
# 16. COMPARE MAE, RMSE, AND MAPE
# ============================================================

model_comparison <- accuracy_results %>%
  select(
    .model,
    MAE,
    RMSE,
    MAPE
  ) %>%
  arrange(RMSE)

cat("\n========== MODEL COMPARISON ==========\n")

print(model_comparison)

write_csv(
  model_comparison,
  file.path(output_dir, "tslm_model_comparison.csv")
)


# ============================================================
# 17. SELECT BEST MODEL BASED ON RMSE
# ============================================================

best_model <- model_comparison %>%
  slice_min(
    order_by = RMSE,
    n = 1,
    with_ties = TRUE
  )

cat("\n========== BEST TSLM MODEL ==========\n")

print(best_model)

write_csv(
  best_model,
  file.path(output_dir, "best_tslm_model.csv")
)


# ============================================================
# 18. PREPARE FORECAST VALUES IN MILLIONS
# ============================================================

forecast_plot_data <- forecasts %>%
  as_tibble() %>%
  mutate(
    Forecast_Millions = .mean / 1000000
  )

actual_plot_data <- ts_data %>%
  as_tibble() %>%
  mutate(
    Actual_Millions = IncurredLosses / 1000000
  )

write_csv(
  forecasts %>% as_tibble(),
  file.path(output_dir, "forecasts.csv")
)




# ============================================================
# 19. ACTUAL VS FORECAST VISUALIZATION
# ============================================================

p3 <- ggplot() +

  # Actual incurred losses
  geom_line(
    data = actual_plot_data,
    aes(
      x = AccidentYear,
      y = Actual_Millions,
      color = "Actual"
    ),
    linewidth = 1
  ) +

  geom_point(
    data = actual_plot_data,
    aes(
      x = AccidentYear,
      y = Actual_Millions
    ),
    color = "black",
    size = 2
  ) +

  # Forecast values
  geom_line(
    data = forecast_plot_data,
    aes(
      x = AccidentYear,
      y = Forecast_Millions,
      color = .model,
      group = .model
    ),
    linewidth = 1
  ) +

  geom_point(
    data = forecast_plot_data,
    aes(
      x = AccidentYear,
      y = Forecast_Millions,
      color = .model
    ),
    size = 2
  ) +

  # Model colors
  scale_color_manual(
    values = c(
      "Actual" = "black",
      "Linear_TSLM" = "blue",
      "Quadratic_TSLM" = "red"
    ),
    labels = c(
      "Actual" = "Actual Losses",
      "Linear_TSLM" = "Linear TSLM",
      "Quadratic_TSLM" = "Quadratic TSLM"
    )
  ) +

  # Display values in millions
  scale_y_continuous(
    labels = scales::label_dollar(
      prefix = "$",
      suffix = "M"
    )
  ) +

  labs(
    title = "Actual vs Forecast Incurred Losses",
    subtitle = "Linear and Quadratic TSLM Models (2004-2007)",
    x = "Accident Year",
    y = "Incurred Losses ($ Millions)",
    color = "Model"
  ) +

  theme_gray()

# Display visualization
print(p3)

# Save visualization
ggsave(
  file.path(plot_dir, "forecast_comparison_millions.png"),
  plot = p3,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 20. RESIDUAL DIAGNOSTICS
# ============================================================

# Residual diagnostics are fitted separately
# to avoid the multiple-model gg_tsresiduals() error.

# ------------------------------------------------------------
# LINEAR TSLM RESIDUALS
# ------------------------------------------------------------

linear_residuals <- augment(
  linear_model_only
) %>%
  as_tibble()

residual_plot_linear <- ggplot(
  linear_residuals,
  aes(
    x = AccidentYear,
    y = .resid / 1000000
  )
) +
  geom_hline(
    yintercept = 0,
    color = "red",
    linetype = "dashed"
  ) +
  geom_line(
    color = "steelblue",
    linewidth = 1
  ) +
  geom_point(
    color = "steelblue",
    size = 2
  ) +
  labs(
    title = "Linear TSLM Residual Diagnostics",
    x = "Accident Year",
    y = "Residuals ($ Millions)"
  ) +
  theme_gray()

print(residual_plot_linear)

ggsave(
  file.path(plot_dir, "Linear_TSLM_Residuals.png"),
  plot = residual_plot_linear,
  width = 10,
  height = 6,
  dpi = 300
)


# ------------------------------------------------------------
# QUADRATIC TSLM RESIDUALS
# ------------------------------------------------------------

quadratic_residuals <- augment(
  quadratic_model_only
) %>%
  as_tibble()

residual_plot_quadratic <- ggplot(
  quadratic_residuals,
  aes(
    x = AccidentYear,
    y = .resid / 1000000
  )
) +
  geom_hline(
    yintercept = 0,
    color = "red",
    linetype = "dashed"
  ) +
  geom_line(
    color = "darkgreen",
    linewidth = 1
  ) +
  geom_point(
    color = "darkgreen",
    size = 2
  ) +
  labs(
    title = "Quadratic TSLM Residual Diagnostics",
    x = "Accident Year",
    y = "Residuals ($ Millions)"
  ) +
  theme_gray()

print(residual_plot_quadratic)

ggsave(
  file.path(plot_dir, "Quadratic_TSLM_Residuals.png"),
  plot = residual_plot_quadratic,
  width = 10,
  height = 6,
  dpi = 300
)

# Check original losses
summary(train_data$IncurredLosses)

# Check transformed losses
summary(transformed_data$TransformedLosses)

# Count zero values
sum(transformed_data$TransformedLosses == 0, na.rm = TRUE)

# Check missing values
sum(is.na(transformed_data$TransformedLosses))



# ============================================================
# BOX-COX TRANSFORMED SERIES
# ============================================================

p4_boxcox <- ggplot(
  transformed_data,
  aes(
    x = AccidentYear,
    y = TransformedLosses / 1000000000
  )
) +
  geom_line(
    color = "blue",
    linewidth = 1
  ) +
  geom_point(
    color = "red",
    size = 2
  ) +
  scale_y_continuous(
    labels = scales::label_number(
      accuracy = 0.1
    )
  ) +
  labs(
    title = "Box-Cox Transformed Annual Industry Losses",
    subtitle = paste(
      "Estimated Lambda =",
      round(lambda, 4)
    ),
    x = "Accident Year",
    y = "Transformed Losses (Billions, Box-Cox Scale)"
  ) +
  theme_gray()

print(p4_boxcox)

# Save to project plot folder
ggsave(
  "boxcox_transformed_losses.png",
  plot = p4_boxcox,
  path = plot_dir,
  width = 10,
  height = 6,
  dpi = 300
)

# Save to Desktop
ggsave(
  "boxcox_transformed_losses.png",
  plot = p4_boxcox,
  path = desktop_plot_dir,
  width = 10,
  height = 6,
  dpi = 300
)

# ============================================================
# 22. TRANSFORMED QUADRATIC TSLM
# ============================================================

# Convert transformed training data into a tsibble

transformed_ts <- transformed_data %>%
  select(AccidentYear, TransformedLosses) %>%
  as_tsibble(index = AccidentYear)

# Fit quadratic TSLM to transformed data

transformed_model <- transformed_ts %>%
  model(
    Quadratic_BoxCox = TSLM(
      TransformedLosses ~ trend() + I(trend()^2)
    )
  )

# Display model parameters

cat("\n========== BOX-COX QUADRATIC TSLM ==========\n")

report(transformed_model)

# Generate forecasts for the testing period

transformed_forecast <- transformed_model %>%
  forecast(
    new_data = test_data
  )

print(transformed_forecast)

# ============================================================
# 23. FINAL PROJECT SUMMARY
# ============================================================

cat("\n")
cat("====================================================\n")
cat("ADS 506 FINAL PROJECT - TSLM ANALYSIS COMPLETED\n")
cat("====================================================\n")

cat("\nDataset: Combined insurance data (1988-2007)")

cat("\nTraining period: 1988-2003")

cat("\nTesting period: 2004-2007")

cat("\nTotal annual observations:", nrow(ts_data))

cat("\nTraining observations:", nrow(train_data))

cat("\nTesting observations:", nrow(test_data))

cat("\n\nMODEL ACCURACY COMPARISON:\n")

print(model_comparison)

cat("\nBEST MODEL BASED ON RMSE:\n")

print(best_model)

cat("\nOUTPUT DIRECTORY:", output_dir)

cat("\nPLOT DIRECTORY:", plot_dir)

cat("\n====================================================\n")
cat("END OF TSLM ANALYSIS\n")
cat("====================================================\n")


# ============================================================
# 24. BACK-TRANSFORM FORECASTS
# ============================================================

transformed_predictions <- transformed_forecast %>%
  mutate(
    Forecast_Original = inv_box_cox(
      .mean,
      lambda
    )
  )

actual_test <- test_data %>%
  as_tibble()

comparison_transformed <- transformed_predictions %>%
  as_tibble() %>%
  select(
    AccidentYear,
    Forecast_Original
  ) %>%
  left_join(
    actual_test,
    by = "AccidentYear"
  ) %>%
  mutate(
    Error = IncurredLosses - Forecast_Original,
    Absolute_Error = abs(Error),
    Squared_Error = Error^2,
    Percentage_Error =
      abs(Error / IncurredLosses) * 100
  )

transformed_accuracy <- comparison_transformed %>%
  summarise(
    MAE = mean(Absolute_Error),
    RMSE = sqrt(mean(Squared_Error)),
    MAPE = mean(Percentage_Error)
  )


# ============================================================
# 25. TRANSFORMED MODEL FORECAST VISUALIZATION
# ============================================================

fitted_values <- transformed_model %>%
  augment() %>%
  mutate(
    Fitted_Original = inv_box_cox(
      .fitted,
      lambda
    )
  )

p5 <- ggplot() +

  geom_line(
    data = train_data %>% as_tibble(),
    aes(
      x = AccidentYear,
      y = IncurredLosses,
      color = "Training Data"
    ),
    linewidth = 1
  ) +

  geom_line(
    data = fitted_values,
    aes(
      x = AccidentYear,
      y = Fitted_Original,
      color = "Fitted Values"
    ),
    linewidth = 1
  ) +

  geom_line(
    data = comparison_transformed,
    aes(
      x = AccidentYear,
      y = Forecast_Original,
      color = "Box-Cox Forecast"
    ),
    linewidth = 1
  ) +

  geom_point(
    data = comparison_transformed,
    aes(
      x = AccidentYear,
      y = IncurredLosses,
      color = "Actual Test Data"
    ),
    size = 2
  ) +

  scale_color_manual(
    values = c(
      "Training Data" = "black",
      "Fitted Values" = "blue",
      "Box-Cox Forecast" = "red",
      "Actual Test Data" = "darkgreen"
    )
  ) +

  scale_y_continuous(
    labels = scales::label_dollar()
  ) +

  labs(
    title = "Box-Cox Quadratic TSLM Forecast",
    subtitle = "Actual, fitted, and forecast incurred losses",
    x = "Accident Year",
    y = "Incurred Losses ($)",
    color = "Series"
  ) +

  theme_gray()

print(p5)

ggsave(
  file.path(
    plot_dir,
    "boxcox_forecast_comparison.png"
  ),
  plot = p5,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 26. FINAL MODEL COMPARISON
# ============================================================

final_comparison <- bind_rows(

  model_comparison %>%
    filter(.model == "Quadratic_TSLM") %>%
    transmute(
      Model = "Original Quadratic TSLM",
      MAE,
      RMSE,
      MAPE
    ),

  transformed_accuracy %>%
    mutate(
      Model = "Box-Cox Quadratic TSLM"
    ) %>%
    select(
      Model,
      MAE,
      RMSE,
      MAPE
    )

) %>%
  arrange(RMSE)

print(final_comparison)

write_csv(
  final_comparison,
  file.path(
    output_dir,
    "original_vs_boxcox_comparison.csv"
  )

)
cat("\n========== BOX-COX TRANSFORMATION RESULTS ==========\n")

cat("\nEstimated Lambda:", round(lambda, 4))

cat("\n\nTransformed Model Accuracy:\n")

print(transformed_accuracy)

cat("\n\nFinal Model Comparison:\n")

print(final_comparison)

# ============================================================
# 26. ORIGINAL VS. BOX-COX MODEL ACCURACY
# ============================================================

accuracy_plot_data <- final_comparison %>%
  tidyr::pivot_longer(
    cols = c(MAE, RMSE, MAPE),
    names_to = "Measure",
    values_to = "Accuracy"
  ) %>%
  mutate(
    Accuracy = if_else(
      Measure %in% c("MAE", "RMSE"),
      Accuracy / 1000000,
      Accuracy
    )
  )

p6 <- ggplot(
  accuracy_plot_data,
  aes(
    x = Model,
    y = Accuracy,
    fill = Model
  )
) +
  geom_col(position = "dodge") +
  facet_wrap(
    ~ Measure,
    scales = "free_y"
  ) +
  labs(
    title = "Original vs. Box-Cox TSLM Accuracy",
    subtitle = "Comparison of MAE, RMSE, and MAPE",
    x = "Model",
    y = "Error Measure (Dollars in Millions or Percentage)",
    fill = "Model"
  ) +
  theme_gray() +
  theme(
    axis.text.x = element_text(
      angle = 15,
      hjust = 1
    )
  )

print(p6)

ggsave(
  file.path(
    desktop_plot_dir,
    "06_original_vs_boxcox_accuracy.png"
  ),
  plot = p6,
  width = 10,
  height = 6,
  dpi = 300
)
# Display the latest plot
print(p4_boxcox)

# Save/overwrite the existing file
ggsave(
  filename = "boxcox_transformed_losses.png",
  plot = p4_boxcox,
  path = plot_dir,
  width = 10,
  height = 6,
  dpi = 300
)
ggsave(
  filename = "boxcox_transformed_losses.png",
  plot = p4_boxcox,
  path = desktop_plot_dir,
  width = 10,
  height = 6,
  dpi = 300
)
file.exists(
  file.path(plot_dir, "boxcox_transformed_losses.png")
)

file.exists(
  file.path(desktop_plot_dir, "boxcox_transformed_losses.png")
)

