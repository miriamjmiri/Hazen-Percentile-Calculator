# This script tallys rainfall in the x number of hours before each sample was taken
# It then categorises samples as WET or DRY based on how much rain there was before sampling. 

#link samples to  rain gauge
with_gauge <- merge(gauge, recent_samples, by.recent_samples = `Site ID`,all=TRUE)

#define hours before sample we are looking for rain 
time_hours <- 24

#for loop which looks at time_hours before sample was taken and sums rainfall in this period
#notes: round date vs. ceiling date depending on preference

for (i in 1:nrow(with_gauge)) {
  
  date_ <- with_gauge[i, "sample_datetime"]
  date_ <- ceiling_date(date_, "hour")
  gauge_var <- with_gauge[i, "gauge"]
  
  if (gauge_var == "geelong_rc") {
    rainfall_data <-  rainfall_mm_geelong_rc
  } else {
    rainfall_data <-  rainfall_mm_MW
  }
  
  rain_subset <- rainfall_data[c("datetime",gauge_var)] %>% filter( rainfall_data$datetime <= date_ & rainfall_data$datetime >= date_-hours(time_hours))
  rain_sum <- sum(rain_subset[,gauge_var])
  with_gauge$rain_sum[i] <- rain_sum
  
}

#subset dry data
with_gauge$weather_condition <- ifelse(with_gauge$rain_sum >= 1, 'WET','DRY')
dry_data <- subset(with_gauge, weather_condition == "DRY")
