#' Author: Emanuele Pesce
library(igraph)
source("./../../utils/graphUtils.R", chdir = T)

#' Calculate threshold used in sw_cutting algorithm.
#' A threshold of a node v is the fraction of the strong edges near v on all
#' neighbors of v.
#' @param graph, a graph in igraph format
#' @return v_thresholds, a vector of thresholds for each node
thresholds_vertices <- function(graph, invert = FALSE, flow=0){
  
  ### normalization and invert the values in order to calculate max flow with
  ### shortest path
  ### it only works if invert is equal to FALSE
  if(invert==TRUE){
    e_weights <- E(graph)$weight 
    ne_weights <- (e_weights-min(e_weights))/(max(e_weights)-min(e_weights))
    E(graph)$weight  <- 1 - ne_weights
  }
  
  ### inizialize list of edges
  v_util <- list()
  for (i in 1:vcount(graph)){
    v_util[[i]] <- i
  }
  
  
  
  ### put in v_util all edges which are part of a shortest path
  for (v in V(graph)){ #for each vertex v
    # all shortest paths from v
    sp <- get.all.shortest.paths(graph, from = v, to = V(graph), mode = "out", weights = E(graph)$weight)
    # updates utils
    for(i in 1:length(sp$res)){ # for each target (path v-i) vertex i
      if( length(sp$res[[i]])>1){ # if the list has more than an element
        for (j in 1:(length(sp$res[[i]])-1)){ # for each vertex j in path v-i
          if(!is.na(sp$res[[i]][j+1])){ # if j + 1 exist
            # edge vj-vk is to add to the list
            vj <- sp$res[[i]][j]
            vk <- sp$res[[i]][j+1]
            if (!( vk %in% v_util[[vj]] )){ # check if vk is the list of vj
              v_util[[vj]] <- c(v_util[[vj]], vk)
            }
          }
        } # end j
      } 
    } #end i
  } # end v
  
  v_thresholds <- as.vector(0)
  
  ### Algorithm with no flow
  if(flow == 0){
    for (i in 1:vcount(graph)){
      for (j in 1:vcount(graph)){
        # check if ij is in v_util
        if (!(j %in% v_util[[i]])){ # if i-j is not in util
          # number of neighbors of i and j
          ni <- length(v_util[[i]]-1) 
          nj <- length(v_util[[j]]-1)
          f <- (ni+nj)/(2*vcount(graph)) # fraction of neighbors in util
          
          v_thresholds[i] <- f
        }
      } #j
    } #i
  }
 
  return(v_thresholds)
}

# example
# if(interactive()){
#   g <- i_adjacencyFromFile("./../../data/toyData/extract/bordaMatrixControls.txt")

# }