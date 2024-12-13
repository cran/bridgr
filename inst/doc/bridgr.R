## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE, warning=FALSE, fig.pos="center", fig.alt = "Visualizing the data"----
# Load libraries
library(bridgr)
library(tsbox)

# Example data
data("gdp")  # Quarterly GDP data
data("baro") # Monthly economic indicator

gdp <- tsbox::ts_pc(gdp) # Calculate growth rate

# Visualize the data
ts_ggplot(
  ts_scale(ts_c(baro, gdp)),
  title = "Quarterly gdp and monthly economic indicator",
  subtitle = "Scaled to mean 0 and variance 1"
  ) +
  theme_tsbox()


## ----estimating, message=T, fig.pos="center"----------------------------------
# Estimate the bridge model
bridge_model <- bridge(
  target = gdp, 
  indic = baro , 
  indic_lags = 1, 
  target_lags=1, 
  h=2 
)


## ----datasets, message=T, fig.pos="center"------------------------------------
# Inspect the datasets
tail(bridge_model$estimation_set)
head(bridge_model$forecast_set)


## ----forecasting, message=F, fig.pos="center", fig.alt = "Forecasted GDP"-----
# Forecasting using the bridge model
fcst <- forecast(bridge_model)

forecast <- data.frame(
  "time" = fcst$forecast_set$time,
  "forecast" = as.numeric(fcst$mean)
)

# Visualize the forecast
ts_ggplot(
  ts_span(ts_tbl(ts_c(gdp, forecast)), start = 2017),
  title = "Forecasted GDP",
  subtitle = "Bridge model forecast"
) +
  theme_tsbox()
  

## ----summary, message=T, fig.pos="center"-------------------------------------
# Summarize the information in the bridge model
summary(bridge_model)
  

