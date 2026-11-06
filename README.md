# auto-insurance-loss-ratio-forecasting
ADS-506 Group 2 – Time series forecasting of auto insurance loss ratios in R.
1. Project Overview
This project focuses on analyzing historical insurance data and applying time series forecasting techniques to examine trends in annual insurance loss ratios.

The primary objective is to evaluate historical insurance loss patterns and compare different forecasting models to determine which approach provides the most accurate predictions.

Our team will use R and the tidyverts ecosystem to prepare the data, develop forecasting models, evaluate model performance, and communicate findings through visualizations and statistical analysis.

2. Research Objectives
The main objectives of this project are to:

Explore historical insurance loss ratio trends.
Prepare and organize insurance datasets for time series analysis.
Apply different time series forecasting methods.
Compare manual and automatically selected ARIMA models.
Evaluate forecasting accuracy using testing data.
Identify insights that can support insurance risk assessment and decision-making.
3. Dataset Description
This project uses two historical insurance datasets:

Dataset 1: September 2011

Accident years: 1988–1997
Observations: 14,600
Insurance companies: 146
Dataset 2: December 2025

Accident years: 1998–2007
Observations: 13,250
Insurance companies: 143
The datasets contain information about incurred losses, cumulative paid losses, earned premiums, accident years, development years, and insurance company identifiers.

The two datasets are combined to develop an annual insurance loss ratio time series covering 1988–2007.

4. Research Methodology
The project follows a structured time series forecasting workflow:

Import and inspect the insurance datasets.
Clean and standardize variable names.
Combine the historical datasets.
Calculate annual insurance loss ratios.
Explore time series patterns and trends.
Divide the data into training and testing periods.
Develop forecasting models.
Evaluate and compare model performance.
Communicate findings through visualizations and reports.
5. Forecasting Models
Our team will investigate three forecasting approaches:

ARIMA (Autoregressive Integrated Moving Average)

Manual ARIMA model specification.
Automatic ARIMA model selection.
Forecast evaluation using testing data.
ETS (Exponential Smoothing)

Model selection based on the characteristics of the historical time series.
Forecast evaluation and comparison.
TSLM (Time Series Linear Model)

Linear regression modeling to examine historical trends.
Forecast evaluation and comparison.
6. Training and Testing Data
The combined dataset covers 20 annual observations.

Training period: 1988–2006 (19 observations).
Testing period: 2007 (1 observation).
The testing period will be used to evaluate the forecasting performance of the models.

7. Tools and Technologies
The project uses the following tools and R packages:

R Programming Language
RStudio / Visual Studio Code
tidyverse
tsibble
feasts
fable
lubridate
GitHub for version control and team collaboration
8. Repository Structure
The repository is organized into the following folders:

data/ – Historical insurance datasets.
R-scripts/ – Data preparation and forecasting scripts.
plots/ – Time series visualizations and forecast plots.
reports/ – Technical analysis and written documentation.
presentation/ – Executive data story presentation.
9. Team Contributions
Each team member will contribute to a different forecasting approach and participate in the overall project development.

Team Member 1: ARIMA modeling and analysis.
Team Member 2: ETS modeling and analysis.
Team Member 3: TSLM modeling and analysis.
All team members will collaborate on data preparation, model comparisons, interpretation of findings, and final project deliverables.

10. Final Deliverables
Deliverable 1 – Executive Data Story Presentation (Module 6)

A presentation communicating the project's major findings, forecasting results, and business insights to an executive audience.

Deliverable 2 – Technical Written Report (Module 7)

A detailed report documenting the dataset, methodology, forecasting models, model evaluation, results, and conclusions.

11. References
Hyndman, R. J., & Athanasopoulos, G. (2021). Forecasting: Principles and Practice (3rd ed.). OTexts. https://otexts.com/fpp3/
