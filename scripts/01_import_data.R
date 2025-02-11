###############This script imports the four data files needed for analysis##############################################

#load packages
library(tidyverse)

##############import sample data#####################################################################################
sample_data <- read_csv("Beaches/input_data/sample_data.csv", col_types = cols(
  site_id = col_character(), 
  site_name = col_character(),
  sample_datetime = col_datetime(format = "%d/%m/%Y %H:%M"), 
  result = col_double()
))

tz(sample_data$sample_datetime) <- "Australia/Victoria"

sample_data <- na.omit(sample_data)

#subset data to time period of interest - usually last five years
recent_samples <- subset(sample_data, sample_datetime > as.Date("2019-12-01") & sample_datetime < as.Date("2024-03-13"))

#Summer only

#change time of sampling to default 9am if hour is 00 
hour(recent_samples$sample_datetime) <- replace(hour(recent_samples$sample_datetime), hour(recent_samples$sample_datetime) == 00, 09)

##############import rainfall data#####################################################################################

#Melbourne water
rainfall_mm_MW <- read_csv("Beaches/input_data/rainfall_mm_MW.csv", col_types = cols(
  datetime = col_datetime(format = "%d/%m/%Y %H:%M") 
))
tz(rainfall_mm_MW$datetime) <- "Australia/Queensland"
#rainfall_mm_MW[is.na(rainfall_mm_MW)] <- 0

#BOM
rainfall_mm_geelong_rc <- read_csv("Beaches/input_data/rainfall_mm_geelong_rc.csv", col_types = cols(
  datetime = col_datetime(format = "%d/%m/%Y %H:%M"),
  geelong_rc = col_double()
))
tz(rainfall_mm_geelong_rc$datetime) <- "Australia/Victoria"
#rainfall_mm_geelong_rc[is.na(rainfall_mm_geelong_rc)] <- 0

##############import sic data#####################################################################################

site_sics <- read_csv("Beaches/input_data/site_sic.csv", col_types = cols(
  site_id = col_character(), 
  site_name = col_character(),
  sic = col_character(),
  sic_review_yr = col_character(),
  sic_score = col_double()
))


##############import gauge data#####################################################################################

gauge <- read_csv("Beaches/input_data/site_gauge.csv", col_types = cols(
  site_id = col_character(), 
  site_name = col_character(),
  gauge = col_character()
))

