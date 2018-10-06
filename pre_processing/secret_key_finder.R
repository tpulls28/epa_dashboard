#TESTING

secret_key_finder <- function() {
  key <- readChar("C:\\Users\\Derek\\Documents\\CS_work\\Misc\\key_to_erebor.txt", file.info("C:\\Users\\Derek\\Documents\\CS_work\\Misc\\key_to_erebor.txt")$size)
  return(key)
}