library(igraph)

#' Attach brain area name attribute to each vertex of the graph
#' @param graph the graph in igraph format
#' @param roiNames list of region of interest names
#' @return graph with roinames at each vertex
#' path_names <- "./../../data/utils/aalLABELS.txt"
#' m <- read.table(path_names, header=FALSE)
#' labels <- as.matrix(m)
#' attachRoiNames(g, labels)
attachRoiNames <- function(graph, roiNames, nvertices = 90){
  
  # safe size check
  if ( length(roiNames) != nvertices){
    return(-1)
  }
  if (vcount(graph) != nvertices){
    return(-1)
  }
  
  # create and inizialize attribute roiName
  graph <- set.vertex.attribute(graph, "roiName", index = V(graph), "null")
  
  # set roiName attributes with the values of roiNames
  for(i in 1:vcount(graph)){
    graph <- set.vertex.attribute(graph, "roiName", index=V(graph)[i], roiNames[i])
  }
  return(graph)
}

