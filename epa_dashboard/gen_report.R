gen_report <- function(type, area_sqf, structure_val, sfha_flag, flood_flag) {
  message <- ""
  message <- paste(message, "Your parcel is estimated to have an area of ", as.integer(area_sqf), " square feet.")
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