# Right now the Sonoma dashboard will use the EPA analysis done by Jacob as an example. I will have to reverse geocode at some point. 
library(googlesheets)
library(dplyr)

sheet_url <- "https://docs.google.com/spreadsheets/d/1qBAz09Ro3zoqKQRehRM4T8ntjFyaE_-wXuVW88cW45Q/"
parcel_data <- gs_url(sheet_url) %>% gs_read("sonoma_work", range = "A1:N5052")

# Filter out missing data. 
parcel_data <- parcel_data[complete.cases(parcel_data$area_m2),]
save(parcel_data, file = "parcel_data.RData")
