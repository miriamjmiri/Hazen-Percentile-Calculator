# this script defines hazen function and applies it to the data

# Hazen function:
# Formals - percentile to use (eg. 25, 50, 95), and a vector of samples, returns the percentile value
hazen_apply <- function(percentile, sample_vector) {
  sample_vector <- sort(sample_vector, decreasing = FALSE)
  n <- length(sample_vector)
  rank<- 0.4375+(percentile/100)*(n+0.125)
  rankint <- as.integer(rank)
  rankmod <- rank-rankint
  percentile_value <- 10^((1 - rankmod)*log10(sample_vector[rankint])+rankmod*log10(sample_vector[rankint+1]))
  percentile_value <- round(percentile_value)
  }

# Apply hazen all data, calculate MACs  
hazen_all_data <- recent_samples %>%
  group_by(site_name , site_id ) %>%
  summarise( hazen_all_data = hazen_apply(95, result), all_weather_n = n())%>%
  mutate(all_mac = cut(hazen_all_data, breaks=c(0, 40, 200, 500,Inf), labels=c("A","B","C","D"), include.lowest=TRUE, right=TRUE))


# Apply hazen to dry data, calculate MACS
hazen_dry_data <- dry_data %>%
  group_by(site_name, site_id) %>%
  summarise(hazen_dry_data = hazen_apply(95, result ), dry_n = n()) %>%
  mutate(dry_mac = cut(hazen_dry_data, breaks=c(0, 40, 200, 500,Inf), labels=c("A","B","C","D"),include.lowest=TRUE,right=TRUE))
