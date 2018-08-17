gen_report <- function(type) {
  if (type == "detached") {
    return(readChar("./messages/detached.txt", file.info("./messages/detached.txt")$size))
  } else if (type == "attached") {
    return(readChar("./messages/attached.txt", file.info("./messages/attached.txt")$size))
  } else {
    return(readChar("./messages/none.txt", file.info("./messages/none.txt")$size))
  }
  
  
}