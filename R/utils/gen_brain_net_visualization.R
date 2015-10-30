# Functions which creates files for visualizing networks with brainnet
# Author: Emanuele Pesce

library(igraph)

#' Generate input file for visualizing nodes with brainnet
gen_nodes <- function(x, y, z, v.clustering = -1, v.size = -1, v.name = -1,
                      pathOut = -1){
  if(v.clustering[1] == -1){
    clustering <- rep(1, len = length(x))
  }
  if(v.size[1] == -1){
    v.size <- rep(1, len = length(x))
  } 
  if(v.name[1] == -1){
    v.name <- rep("no_name", len = length(x))
  }
  
  M <- data.frame(x, y, z, v.clustering, v.size, v.name)
  
  if(!(pathOut == -1)){
    write.table(M, file = pathOut, row.names = F, col.names = F, sep = " ")
  }
  
  return(M)
}

#' Generate input file for visualizing edges with brainnet
gen_edges <- function(graph, pathOut, e.attr = e.attr){
  ugm <- as.undirected(graph, "collapse", edge.attr.comb = "mean")
  MA <- get.adjacency(ugm, sparse = F, attr = e.attr)
  write.table(MA, file = pathOut, row.names = F, col.names = F, sep = "\t")
}

#' Generate files for visualizing networks with brain net
#' @param pathIn.graph: path of the graph to plot
#' @param pathIn.membership: path of the file containing the clustering result
#' @param pathOut.node: path where to save the file for visualizing nodes
#' @param pathOut.edge: path where to save the file for visualizing edges
#' @param format: format of the graph to read
gen_all_files_brainnet <- function(pathIn.graph, pathIn.membership,
                                   pathOut.node, pathOut.edge, e.attr,
                                   format = "graphml"){
  
  g <- read.graph(pathIn.graph, format = format)
  v.clust <- read.csv(pathIn.membership, header = F)
  v.clust <- v.clust[,1]
  
  v.x <- V(g)$cx
  v.y <- V(g)$cy
  v.z <- V(g)$cz
  v.name <- V(g)$roiName
  
  # generate nodes input file for brain net
  gen_nodes(v.x, v.y, v.z, v.clust, v.name = v.name, pathOut = pathOut.node)
  
  gen_edges(g, pathOut = pathOut.edge, e.attr = e.attr)
  
}