library(dplyr)
library(readr)
library(lubridate)

GeelongRC <- read_csv("Raw_data/BOM/HD01D_Data_087184_9999999910608639.txt")

GeelongRC$datetime <- as.POSIXct(paste0(GeelongRC$`Year Month Day Hour Minutes in YYYY...3`,"-", GeelongRC$MM...4, "-", GeelongRC$DD...5, " ",GeelongRC$HH24...6,":",GeelongRC$`MI format in Local time`), format="%Y-%m-%d %H:%M", tz = "Australia/Victoria")


GeelongRC1 <- data.frame(datetime = GeelongRC$datetime, precip = GeelongRC$`Total precipitation in last 30 minutes in mm where observations count >= 3`)

# create grouped column
GeelongRC1$grouped_time = lubridate::floor_date(GeelongRC1$datetime, unit = "hour")

# sum by group
GeelongRCfinal <- GeelongRC1 %>%
  group_by(grouped_time) %>%
  summarize(precip = sum(precip))


tz(GeelongRCfinal$grouped_time) <- "Australia/Victoria"


write.csv(GeelongRCfinal, "GeelongRC_precip.csv")

