#' Calculate the occurence matrix
#' @param membership, membership matrix: columns are subjects, rows are the 
#'                    regions
#' @param n, dimension of the occurence matrix
#' @return the occurence matrix, which show for each pair of regions how many
#'          time it appear in the same cluster
coOccurrence <- function(membership, n = 90) {
  
  # initialization
  numRow <- dim(membership)[1]
  k <- 0
  occurrenceMatrix <- matrix(nrow = n, ncol = n, data = 0)
  
  # calculate the occurences
  for (i in 1:numRow) {
    r1 <- membership[i,]
    nr1 <- length(r1)
    for (j in 1:numRow) {
      r2 <- membership[j,]
      for (z in 1:nr1) {
        if(r1[z] == r2[z]) {
          occurrenceMatrix[i,j] <- occurrenceMatrix[i,j] + 1
        }
      }
    }
  }
  
  # normalize matrix 
  maximum <- occurrenceMatrix[1,][1]
  normalizedMatrix <- occurrenceMatrix/maximum
  
  # return 
  return(normalizedMatrix)
}