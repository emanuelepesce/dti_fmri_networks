library(igraph)

#' Attach cordinates attribute to each vertex of the graph
#' @param graph the graph in igraph format
#' @param coordinates list of region of interest names
#' @return graph with coordinates attributes attached at each vertex
#' @example
#' path_names <- "./../../data/utils/aalCOG.txt"
#' m <- read.table(path_names, header=FALSE)
#' coords <- as.matrix(m)
#' g <- attachCoordinates(g, coordinates = coords)
attachCoordinates <- function(graph, coordinates, nvertices = 90, numDimensions = 3){
  
  # safe size check
  if ( !identical(dim(coordinates), as.integer(c(nvertices, numDimensions))) ){
    return(-1)
  }
  if (vcount(graph) != nvertices){
    return(-1)
  }
  
  # create and inizialize attribute coordinates
  graph <- set.vertex.attribute(graph, "cx", index = V(graph), NULL)
  graph <- set.vertex.attribute(graph, "cy", index = V(graph), NULL )
  graph <- set.vertex.attribute(graph, "cz",  index = V(graph), NULL)
  
  # set cx, cy, cz attributes with the values of coordinates
  for(i in 1:vcount(graph)){
    graph <- set.vertex.attribute(graph, "cx", index=V(graph)[i], coordinates[i,1])
    graph <- set.vertex.attribute(graph, "cy", index=V(graph)[i], coordinates[i,2])
    graph <- set.vertex.attribute(graph, "cz", index=V(graph)[i], coordinates[i,3])
  }
  
  #return
  return(graph)
}

