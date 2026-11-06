library(tidyverse)
library(forecast)
library(lubridate)
library(knitr)

# Download monthly motor vehicle insurance CPI
url <- paste0(
  "https://fred.stlouisfed.org/graph/fredgraph.csv",
  "?id=CUUR0000SETE"
)

dat <- read.csv(url, na.strings = ".")

# Prepare data
dat <- dat %>%
  rename(date = observation_date,
         cpi = CUUR0000SETE) %>%
  mutate(
    date = as.Date(date),
    cpi = as.numeric(cpi)
  ) %>%
  filter(!is.na(cpi)) %>%
  arrange(date)

# Create monthly time series
y <- ts(
  dat$cpi,
  start = c(year(min(dat$date)), month(min(dat$date))),
  frequency = 12
)

# Fit time series linear model
fit <- tslm(y ~ trend + season)

# Report model summary
summary(fit)

# Display estimated model parameters
parameter_table <- data.frame(
  Parameter = names(coef(fit)),
  Estimate = round(coef(fit), 4)
)

kable(parameter_table,
      caption = "Estimated Time Series Linear Model Parameters")

# Generate 12-month forecast
fc <- forecast(fit, h = 12, level = c(80, 95))

# Forecast table
forecast_table <- data.frame(
  Month = seq(
    max(dat$date) %m+% months(1),
    by = "month",
    length.out = 12
  ),
  Forecast = as.numeric(fc$mean),
  Lower_80 = as.numeric(fc$lower[, "80%"]),
  Upper_80 = as.numeric(fc$upper[, "80%"]),
  Lower_95 = as.numeric(fc$lower[, "95%"]),
  Upper_95 = as.numeric(fc$upper[, "95%"])
)

kable(forecast_table,
      digits = 2,
      caption = "12-Month Motor Vehicle Insurance CPI Forecast")

# Prepare visualization
historical <- tail(dat, 60)

forecast_plot <- forecast_table %>%
  rename(date = Month)

ggplot() +
  geom_line(
    data = historical,
    aes(x = date, y = cpi, color = "Historical"),
    linewidth = 0.8
  ) +
  geom_ribbon(
    data = forecast_plot,
    aes(x = date, ymin = Lower_95, ymax = Upper_95),
    fill = "#9ECAE1",
    alpha = 0.25
  ) +
  geom_ribbon(
    data = forecast_plot,
    aes(x = date, ymin = Lower_80, ymax = Upper_80),
    fill = "#3182BD",
    alpha = 0.25
  ) +
  geom_line(
    data = forecast_plot,
    aes(x = date, y = Forecast, color = "Forecast"),
    linewidth = 1
  ) +
  scale_color_manual(
    values = c(
      "Historical" = "#1F4E79",
      "Forecast" = "#D95F02"
    )
  ) +
  labs(
    title = "Motor Vehicle Insurance CPI: 12-Month Forecast",
    subtitle = "Historical observations and forecast prediction intervals",
    x = "Date",
    y = "Consumer Price Index",
    color = NULL,
    caption = "Source: U.S. Bureau of Labor Statistics via FRED"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold")
  )
