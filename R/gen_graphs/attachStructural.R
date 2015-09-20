library(igraph)
source("./../utils/graphUtils.R")

#' Attach dti (structural) values to the edges of a graph 
#' @param graph the graph in igraph format
#' @param mat matrix of dti values
#' @return graph a graph with "dti" edge attribute
#' @examples
#' m <- getMatrixFromFile("./../../data/structural/naive/Controls/CTRL_amore.txt")
#' g <- make_full_graph(90, TRUE, TRUE)
#' gr <- attachDtiToGraph(g, m)
attachDtiToGraph <- function(graph, mat, nvertices = 90){
  
  # safe size check
  if ( !identical(dim(mat), as.integer(c(nvertices, nvertices))) ){
    return(-1)
  }
  if (vcount(graph) != nvertices){
    return(-1)
  }
  
  # create and inizialize attribute DTI (1e-05 because the noise)
  graph <- set.edge.attribute(graph, "dti", index=E(graph), 1e-05)
  
  # set dti attributes with the values of matrix m 
  for(i in 1:nvertices){
    for(j in 1:nvertices){
      if (mat[i,j] > 0){
        graph[i,j, attr = "dti"] <- mat[i,j]
      }
    }
  } 
  #return
  return(graph)
}


#' Attach dti (structural) inverse values to the edges of a graph 
#' @param graph the graph in igraph format
#' @param mat matrix of dti values
#' @return graph a graph with "dti_inverse" edge attribute
#' @examples
#' m <- getMatrixFromFile("./../../data/structural/naive/Controls/CTRL_amore.txt")
#' g <- make_full_graph(90, TRUE, TRUE)
#' gr <- attachDtiInverseToGraph(g, m)
attachDtiInverseToGraph <- function(graph, mat, nvertices = 90){
  
  # safe size check
  if ( !identical(dim(mat), as.integer(c(nvertices, nvertices))) ){
    return(-1)
  }
  if (vcount(graph) != nvertices){
    return(-1)
  }
  
  # create and inizialize attribute DTI (1e-05 because the noise)
  graph <- set.edge.attribute(graph, "dtiInverse", index=E(graph), 1e-05)
  
  # set dti attributes with the values of matrix m 
  for(i in 1:nvertices){
    for(j in 1:nvertices){
      if (mat[i,j] < 1){
        graph[i,j, attr = "dtiInverse"] <- 1 - mat[i,j]
      }
    }
  } 
  #return
  return(graph)
}
