rm(list = ls())
getwd()
setwd("C:/Users/jlund/Documents/GitHub/epa_dashboard/epa_dashboard")
library(googlesheets)
library(dplyr)
library(revgeo)
library(rgdal)
library(sp)
library(leaflet)
library(rgeos)
library(rbenchmark)
library(readr)
load(".RData")

source("gen_report1.R")


key <- secret_key_finder()

parcel_data2 <- get(load("epa_parcel_data_merged.RData"))


parcel_data$APN[1]


data.shape <- data.shape[data.shape$APN %in% parcel_data2$APN]



total <- merge(parcel_data1, parcel_data2, by="APN", how='inner')

head(total)



#known area and tax assessor recorded structure value, then add a note for SFHA_FLAG which is just that their property is in a Special Flood Hazard Area, and FLOOD_FLAG which is that a garage conversion project runs the risk of exceeding 50% of structure value which may require significant costs to raise the lowest floor of the entire structure to above base flood elevation


parcel_data <- get(load("epa_parcel_data_merged.RData"))

test <- filter(epa_parcel_data@data, address == epa_parcel_data$address[0])$SFHA_FLAG

head(epa_parcel_data_merged)


gen_report <- function(type, area_sqf, structure_val, sfha_flag, flood_flag) {
  message <- ""
  message <- paste(message, "Your parcel is estimated to have an area of ", area_sqf, " square feet.")
  message <- paste(message, " The estimated value of the structure is $", structure_val, ". ")
  if (type == "detached") {
    message <- paste(message, readChar("./messages/detached.txt", file.info("./messages/detached.txt")$size))
  } else if (type == "attached") {
    message <- paste(message, readChar("./messages/attached.txt", file.info("./messages/attached.txt")$size))
  } else {
    message <- paste(message, readChar("./messages/none.txt", file.info("./messages/none.txt")$size))
  }
  
  if (sfha_flag == 1) {
    message <- paste(message, " Your property IS in a Special Flood Hazard Area")
    if (flood_flag == 1) {
      message <- paste(message, ", and a garage conversion project runs the risk of exceeding 50% of structure value which may require significant costs to raise the lowest floor of the entire structure to above base flood elevation.")
    }
    else {
      message <- paste(message, ".")
    }
  }
  
  else {
    message <- paste(message, " Your property IS NOT in a Special Flood Hazard Area. ")
  }
  return(message)
}


