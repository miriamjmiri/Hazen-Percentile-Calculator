#this script performs the matrix assessment and outputs result

#merge dry and all MACs
macs <- merge(hazen_dry_data, hazen_all_data, by.y = c("site_name", "site_id"), by.x = c("site_name", "site_id"))


#merge sic and mac data
sic_grades <- merge(site_sics, macs, by.y =  "site_id", by.x = "site_id")

#matrix assessment for sic and mac data to get grades
grades <-  sic_grades %>%
  mutate(dry_grade = case_when(
    sic == "VERY LOW" & dry_mac == "A" ~ "Very good",
    sic == "VERY LOW" & dry_mac == "B" ~ "Very good",
    sic == "VERY LOW" & dry_mac == "C" ~ "Follow up",
    sic == "VERY LOW" & dry_mac == "D" ~ "Follow up",
    sic == "LOW" & dry_mac == "A" ~ "Very good",
    sic == "LOW" & dry_mac == "B" ~ "Good",
    sic == "LOW" & dry_mac == "C" ~ "Follow up",
    sic == "LOW" & dry_mac == "D" ~ "Follow up",
    sic == "MODERATE" & dry_mac == "A" ~ "Good",
    sic == "MODERATE" & dry_mac == "B" ~ "Good",
    sic == "MODERATE" & dry_mac == "C" ~ "Poor",
    sic == "MODERATE" & dry_mac == "D" ~ "Poor",
    sic == "HIGH" & dry_mac == "A" ~ "Good",
    sic == "HIGH" & dry_mac == "B" ~ "Fair",
    sic == "HIGH" & dry_mac == "C" ~ "Poor",
    sic == "HIGH" & dry_mac == "D" ~ "Very poor",
    sic == "VERY HIGH" & dry_mac == "A" ~ "Follow up",
    sic == "VERY HIGH" & dry_mac == "B" ~ "Fair",
    sic == "VERY HIGH" & dry_mac == "C" ~ "Poor",
    sic == "VERY HIGH" & dry_mac == "D" ~ "Very poor",
  )
  )



grades <-  grades %>%
  mutate(all_grade = case_when(
    sic == "VERY LOW" & all_mac == "A" ~ "Very good",
    sic == "VERY LOW" & all_mac == "B" ~ "Very good",
    sic == "VERY LOW" & all_mac == "C" ~ "Follow up",
    sic == "VERY LOW" & all_mac == "D" ~ "Follow up",
    sic == "LOW" & all_mac == "A" ~ "Very good",
    sic == "LOW" & all_mac == "B" ~ "Good",
    sic == "LOW" & all_mac == "C" ~ "Follow up",
    sic == "LOW" & all_mac == "D" ~ "Follow up",
    sic == "MODERATE" & all_mac == "A" ~ "Good",
    sic == "MODERATE" & all_mac == "B" ~ "Good",
    sic == "MODERATE" & all_mac == "C" ~ "Poor",
    sic == "MODERATE" & all_mac == "D" ~ "Poor",
    sic == "HIGH" & all_mac == "A" ~ "Good",
    sic == "HIGH" & all_mac == "B" ~ "Fair",
    sic == "HIGH" & all_mac == "C" ~ "Poor",
    sic == "HIGH" & all_mac == "D" ~ "Very poor",
    sic == "VERY HIGH" & all_mac == "A" ~ "Follow up",
    sic == "VERY HIGH" & all_mac == "B" ~ "Fair",
    sic == "VERY HIGH" & all_mac == "C" ~ "Poor",
    sic == "VERY HIGH" & all_mac == "D" ~ "Very poor",
  )
  )


write.csv(grades, "Beaches/output_data/grades.csv")
