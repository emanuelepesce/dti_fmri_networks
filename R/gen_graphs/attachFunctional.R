library(igraph)
source("./../utils/graphUtils.R")


#' Attach fmri (functional) values to the edges of a graph 
#' @param graph the graph in igraph format
#' @param mat matrix of dti values
#' @return graph a graph with "fmri" edge attribute
#' m <- getMatrixFromFile("./../../data/structural/naive/Controls/CTRL_amore.txt")
#' g <- make_full_graph(90, TRUE, TRUE)
#' gr <- attachFmriToGraph(g, m)
attachFmriToGraph <- function(graph, mat, nvertices = 90){
  
  # safe size check
  if ( !identical(dim(mat), as.integer(c(nvertices, nvertices))) ){
    return(-1)
  }
  if (vcount(graph) != nvertices){
    return(-1)
  }
  
  # create and inizialize attribute FMRI (1e-05 because the noise)
  graph <- set.edge.attribute(graph, "fmri", index=E(graph), 1e-05)
  
  # set fmri attributes with the values of matrix m 
  for(i in 1:nvertices){
    for(j in 1:nvertices){
      graph[i,j, attr = "fmri"] <- mat[i,j]
    }
  } 
  #return
  return(graph)
}
