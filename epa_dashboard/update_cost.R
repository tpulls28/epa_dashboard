updateCost <- function(arrayOfQuestions) {
  cost <- 0
  cost <- cost + as.integer(arrayOfQuestions[1])
  if (arrayOfQuestions[2] == 1) {
    cost <- cost + 1
  }
  else if (arrayOfQuestions[2] == 2) {
    cost <- cost + 2
  }
  return(cost)
}