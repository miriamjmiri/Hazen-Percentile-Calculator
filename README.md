# Hazen-Percentile-Calculator

###Outline and background###

This R project provides an analysis framework for reporting against long-term microbial Environmental Reference Standards (ERS) for water quality.
The long term standards are explained in table 5.19 of the ERS.
Monitoring sites are given a grade of "Very Good", "Good", "Fair", "Poor" or "Very Poor" which summarises their water quality performance over time. 
A grade is calculated for samples taken both in general weather, and dry weather only. 
A minimum sample size of 60 samples is required for reporting.
To generate the grades, two components of site water quality, a Microbial Assessment Category (MAC) and a Site Inspection Category (SIC) are compared in a classification matrix derived from the ERS.
A snippet of the classification matrix is in this project, file title "classification_matrix.png".
An explanation of the MAC and the SIC are below.

###Understanding the MAC###
The MAC is a rating which represents a sites bacterial water quality.
It is derived from the 95th percentile (Hazen method) number of enterococci or E. coli per 100ml, from a 60 sample dataset.
This 95th percentile value corresponds to possible MAC categories of "A", "B", "C", "D" or "E".
For example, if the 95th percentile enterococci value of a site was "60", this would correspond to a MAC category of "B" as per the classification matrix in the ERS (refer to figure).

###Understanding the SIC###
SIC is the Sanitary Inspection Category of a site. 
This is a rating of "Very Low", "Low", "Moderate", "High" or "Very High" given to each site based on possible sources of pollution at the site.
The higher the rating, the higher risk profile of a site. 
For example, a Beach Site with 6 stormwater drains discharging onto the beach, and a Sewage Treatment Plant nearby, would receive a higher rating than a site without these possible sources of pollution.
The SIC is generated after a comprehensive field survey of a site, and the filling out of a Sanitary Inspection Survey, which guides the inspector to tally up pollution source risks at a site, to generate the SIC.
Sites are inspected on a regular basis and a current SIC rating of each site is maintained in a SIC dataset used for this analysis. 

###Generating the Grade from the SIC###
SICs and MACs are cross referenced in the classification matrix to generate site grades. 
For example, a MAC of "C" and a SIC of "Moderate" would give a long-term water quality grade of "Poor" for a site.
This allows waterway managers to guide and target intervention for water quality at specific sites.

###What these scripts do###
These scripts carry out the analysis portion of generating long-term grades for monitoring sites.
They do this by:
* Taking a dataset of microbial samples and splitting them into
   - samples taken under any weather conditions
   - samples taken during dry weather conditions
* Performing the 95th percentile hazen calculation on the two datasets
* Undertaking the matrix assessment of the 95th percentile against sanitary inspection category (SIC) to provide dry weather and all weather grades for each site

###Data needed for analysis###
 To undertake the assessment you will need the following data in /input_data:
 - Microbial sample data for each site
 - Sanitary Inspection Category for each site
 - Rainfall data for a gauge near each site
 - A rainfall - gauge linking file listing the site id of each site, and the rain gauge it uses
 
 More detail on each of these data is below:
 
 *Sample Data*
 - Microbial data should be a dataset of E. coli or enterococci results expressed in orgs/100ml
 - There should be a minimum of 60 samples for each site
 - Sample data should be named sample_data.csv and follow the exact structure of this file, with exact column names: site_id, site_name, sample_datetime, result
 - any result expressed as "<10" must be converted to a result of 9
 - any resample data should be removed
 - there should be no nulls
 - datetime should be in format the following format "%d/%m/%Y %H:%M" ideally no time in the datetime is null, if there are nulls, the script will replace datetime == 0 with 9am as default sample time
 - Note: consider issues with timezones in data - daylight savings can cause issues if sample data and rainfall data are not in the same time zone

 *Sanitary Inspection Category Data*
 - This file contains the SIC for each site, along with site_code and site_name information 
 - This file should be named site_inspection_cat.csv and follow the exact structure of this file, with exact column names
 
 *Rainfall Data*
 - These files contain the rainfall data for each site. 
 - Files are structured with the first column as the date in "%d/%m/%Y %H:%M" format, following columns are named for the gauge.
 - Ideally there should be no missing timesteps in the data, and no nulls. Nulls can produce errors during analysis.
 - Note: consider issues with timezones in rainfall data - daylight savings can cause issues if sample data and rainfall data are not in the same time zone

 *Rain Gauges*
 - This file is a link file connecting the rainfall gauge data to site code. 
 - This file should be named rain_gauges.csv and follow the exact structure of this file, with exact column names
 - the syntax in the rain gauge column should exactly match the column name in the rainfall data to link them
 
###File organisation###

hazen_analysis /
  ├── hazen_analysis.Rproj
  ├── scripts/
  │       ├── 01_import_data.R
  │       ├── 02_separate_dry_samples.R
  │       ├── 03_apply_hazen_find_MACs.R
  │       └── 04_find_grades.R
  ├── input_data/
  │   └── site_group/
  │       ├── rain_gauges.csv
  │       ├── site_inspection_cat.csv
  │       ├── sample_data.csv
  │       └── rainfall_data.csv
  └── output_data/
       ├── grades.csv
       └── hazen_inputs.csv

*files will be populated into output_data when the scripts are run

###Running the scripts###

Code has been split into four scripts, to be run sequentially based on the number in front of the script. 

01_import_data.R
 - imports the four data files
 
02_separate_dry_samples.R
 - script uses the data from rainfall and gauge files to create a "rain_sum" with that tallys rainfall at the gauge corresponding to the site in the x number of hours before sampling.
 - the hours before sampling that the script looks at can be changed through the "time_hours" variable
 - it then categorieses samples as WET or DRY based on how much rain there was before sampling. 
 - the default for a WET samples is >1mm of rain in 24 hours, however this can be changed

03_apply_hazen_find_MACs.R

This script defines the Hazen function and applies it to the data

There are a couple of versions of the Hazen method.
 - The interpolation method - which interpolates between two values at the percentile rank
 - The integer method - which takes the exact integer at the percentile rank
 - More information  here: https://splashback.io/2021/05/hazen-percentile/, https://environment.govt.nz/assets/Publications/Files/hazen-percentile-calculator-2-3_0.xls
 - The version that the original SEPP tool that EPA used (developed by EPHM lab) used the interpolation version so this has been kept it consistent here
 - However, code for the integer version is below if needed

Integer version:

Hazen_percentile_integer_version <- function(percentile, enterococci_vector) {
  enterococci_vector <- sort(enterococci_vector, decreasing = FALSE)
  n <- length(enterococci_vector)
  pn <- percentile*(n+0.125)
  pn2 <- pn/100
  rank <- 0.4375+pn2
  percentile_value <- enterococci_vector[rank]
  return(percentile_value)
 }

Interpolation version. Code modified from EPHM labs Visual Basic version for consistency. Function takes a whole number eg. 95, to define percentile and a vector of enterococci results

Hazen_percentile <- function(percentile, sample_vector) {
  sample_vector <- sort(sample_vector, decreasing = FALSE)
  n <- length(sample_vector)
  rank<- 0.4375+(percentile/100)*(n+0.125)
  rankint <- as.integer(rank)
  rankmod <- rank-rankint
  percentile_value <- 10^((1 - rankmod)*log10(sample_vector[rankint])+rankmod*log10(sample_vector[rankint+1]))
  percentile_value <- round(percentile_value)
  return(percentile_value)
}

04_find_grades.R
 - Undertakes the matrix assessment to convert the SIC and MAC into Grades
 
 To do: 
 Functionalising - investigate best place to define the Hazen function
 For Loop - figure out a better way to get the rain sum for each sample
 Tidy the mutate function that does the matrix assessment - there must be a better way to do this


