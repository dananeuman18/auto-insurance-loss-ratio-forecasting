Auto Insurance Loss Ratio Forecasting

ADS 506 – Group 2 | Time Series Forecasting Project

1. Project Overview

This project focuses on analyzing historical auto insurance data and applying time series forecasting techniques to examine trends in annual insurance loss ratios.

The primary objective is to evaluate historical insurance loss patterns, develop forecasting models, and compare their predictive accuracy to identify the most effective approach for forecasting annual auto insurance loss ratios.

The project uses R and the tidyverts ecosystem to prepare historical insurance datasets, develop forecasting models, evaluate model performance, and communicate findings through statistical analysis and visualizations.

2. Research Objectives

The main objectives of this project are to:

Explore historical annual auto insurance loss ratio trends.
Prepare, clean, and combine historical insurance datasets.
Calculate annual industry-level insurance loss ratios.
Apply different time series forecasting techniques.
Compare manually specified and automatically selected ARIMA models.
Evaluate ETS and TSLM forecasting approaches.
Compare forecasting accuracy using testing data.
Identify insights that support insurance risk assessment and decision-making.
3. Dataset Description

This project uses two historical auto insurance datasets:

Dataset 1: September 2011
Accident years: 1988–1997
Observations: 14,600
Insurance companies: 146
Dataset 2: December 2025
Accident years: 1998–2007
Observations: 13,250
Insurance companies: 143

The datasets contain information about:

Incurred losses
Cumulative paid losses
Earned premiums
Accident years
Development years
Development lags
Insurance company identifiers

The two datasets are standardized and combined to create a historical dataset covering 20 accident years, from 1988 through 2007.

Primary Forecasting Variable

The primary variable is the annual industry-level insurance loss ratio.

The loss ratio is calculated as:

Loss Ratio = (Total Incurred Losses / Total Earned Premiums) × 100

The annual industry loss ratio is calculated using aggregated incurred losses and earned premiums for each accident year.

This approach provides an industry-level measure of incurred losses relative to earned premiums.

4. Research Methodology

The project follows a structured time series forecasting workflow:

Import and inspect the original insurance datasets.
Clean and standardize variable names.
Combine the historical insurance datasets.
Check missing values and duplicate observations.
Aggregate annual incurred losses and earned premiums.
Calculate annual industry insurance loss ratios.
Convert the annual observations into a time series structure.
Explore historical trends and time series characteristics.
Divide the observations into training and testing periods.
Develop forecasting models.
Generate forecasts for the testing period.
Evaluate and compare model performance.
Interpret the results and communicate business insights.
5. Forecasting Models

The project investigates three forecasting approaches.

5.1 ARIMA – Autoregressive Integrated Moving Average

The ARIMA analysis includes:

Manual ARIMA model specification.
Automatic ARIMA model selection.
Examination of time series characteristics.
Forecast generation.
Forecast accuracy evaluation.
5.2 ETS – Exponential Smoothing

The ETS analysis focuses on:

Identifying appropriate error, trend, and seasonal components.
Selecting an appropriate exponential smoothing model.
Generating forecasts.
Evaluating predictive performance.
5.3 TSLM – Time Series Linear Model

The TSLM analysis examines historical trends using regression-based forecasting methods.

The models include:

Linear trend regression.
Quadratic trend regression.
Model diagnostics and residual analysis.
Forecast accuracy evaluation.
Comparison of original-scale and Box-Cox transformed models, where appropriate.
6. Training and Testing Data

The combined dataset contains 20 annual observations covering 1988–2007.

The project uses the following data partition:

Dataset	Accident Years	Observations
Training	1988–2006	19
Testing	2007	1
Total	1988–2007	20

The training dataset is used to estimate forecasting models.

The testing observation for 2007 is reserved for evaluating out-of-sample forecasting performance.

All forecasting approaches will use the same training and testing periods to ensure consistent model comparisons.

7. Forecast Accuracy Evaluation

Forecasting models will be evaluated using the following accuracy measures:

Mean Absolute Error (MAE)

Measures the average absolute difference between actual and forecast values.

Root Mean Squared Error (RMSE)

Measures the square root of the average squared forecast errors and penalizes larger forecasting errors.

Mean Absolute Percentage Error (MAPE)

Measures the average absolute forecast error as a percentage of actual values.

For all three measures, lower values indicate better forecasting accuracy.

Because the testing period contains only one annual observation, the accuracy measures should be interpreted cautiously. They represent single-year forecast performance rather than evidence of consistent long-term predictive accuracy.

8. Model Comparison

The project will compare the forecasting performance of:

Manual ARIMA
Automatic ARIMA
ETS
Linear TSLM
Quadratic TSLM
Box-Cox transformed TSLM, where appropriate

The final comparison will use consistent testing observations and forecast accuracy measures.

The objective is to identify which forecasting approach produces the most accurate prediction of the 2007 annual industry insurance loss ratio.

9. Tools and Technologies

The project uses the following tools and technologies:

R Programming Language – Statistical analysis and forecasting.
RStudio / Visual Studio Code – Development environments.
tidyverse – Data manipulation and visualization.
tsibble – Time series data structures.
feasts – Time series features and exploratory analysis.
fable – Forecasting models.
fpp3 – Forecasting workflow and supporting functions.
lubridate – Date and time manipulation.
ggplot2 – Data visualization.
GitHub – Version control and team collaboration.
10. Repository Structure

The repository is organized into the following folders:

text
auto-insurance-loss-ratio-forecasting/
│
├── data/
│   ├── ppauto_pos_Sep_2011.csv
│   └── ppauto_pos98-07_Dec_2025.csv
│
├── R-scripts/
│   ├── data_preparation.R
│   ├── ARIMA_analysis.R
│   ├── ETS_analysis.R
│   └── TSLM_analysis.R
│
├── plots/
│   ├── historical_loss_ratio.png
│   ├── training_testing.png
│   ├── ARIMA_forecast.png
│   ├── ETS_forecast.png
│   └── TSLM_forecast.png
│
├── outputs/
│   ├── annual_industry_loss_ratio.csv
│   └── forecast_accuracy_comparison.csv
│
├── reports/
│   └── technical_report.docx
│
├── presentation/
│   └── executive_data_story.pptx
│
└── README.md


Note: The folder and file names above represent the proposed organization. Update them to match the actual repository contents.

11. Team Contributions

Each team member is responsible for a specific forecasting approach while collaborating on the overall project.

Team Member	Responsibility
Team Member 1	ARIMA modeling and analysis
Team Member 2	ETS modeling and analysis
Team Member 3	TSLM modeling and analysis

All team members collaborate on:

Data preparation and validation.
Exploratory data analysis.
Model comparison.
Interpretation of forecasting results.
Final presentation and technical report.
12. Final Deliverables
Deliverable 1 – Executive Data Story Presentation (Module 6)

A presentation communicating the project's major findings, forecasting results, visualizations, and business insights to an executive audience.

Deliverable 2 – Technical Written Report (Module 7)

A detailed technical report documenting:

Dataset description.
Data preparation and methodology.
Annual loss ratio calculation.
Exploratory time series analysis.
Forecasting model development.
Forecast accuracy evaluation.
Model comparison.
Results and interpretation.
Conclusions and recommendations.
13. Project Limitations

The project uses 20 annual observations, with 19 observations for model training and one observation for testing.

The limited sample size presents challenges for identifying long-term patterns and evaluating forecasting performance.

Additionally, a single testing year limits the reliability of model rankings based on forecast accuracy measures.

The findings should therefore be interpreted in the context of the available historical data and forecasting period.

14. References

Hyndman, R. J., & Athanasopoulos, G. (2021). Forecasting: Principles and Practice (3rd ed.). OTexts.

https://otexts.com/fpp3/


