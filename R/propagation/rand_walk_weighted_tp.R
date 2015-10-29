library(igraph)

#' Simulate a weighted random walk on the graph. 
#' Use weights on the edges in order to boost probability to choose a path.
#' It stops when all vertices have been visited.
#' The walker could do a teleport in two cases:
#'  - when the current vertex has no outgoing edges
#'  - after a number of steps in which no one new vertex has been visited
#' @param graph, graph in igraph format
#' @param weights, vector of edge weight values to consider, it has to be the 
#'                 same length of the number of edges
#' @param seed, vertex where the walker has to start
#' @param toTel, number of iteration to do before to teleport in a random vertex
#' @example 
#' p_graph <- "./../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"
#' g <- read.graph(p_graph, format= "graphml")
#' w <- E(g)$fmri
#' res <- rand_walk_weighted(g, w, 1, 50)
rand_walk_weighted_tp <- function(graph, weights, seed, toTel = 45){

  v_visited <- vector()   # visited vertices
  v_history <- vector()   # sequence of visited vertices
  teleports <- 0          # number of teleports 
  
  nv <- vcount(graph)
  walker <- seed 
  
  # check if length of weight is ok
  if(length(weights) != ecount(graph)){
    return(-1)
  }
  
  # set attribute
  graph <- set.edge.attribute(graph, name = "tmp", index = E(graph), weights)
  
  cnt <- 0 
  while(length(v_visited) < 90){    
    # update history
    v_history <- c(v_history, walker)
    
    # check the walker is a vertex which has never visited before
    if(!(walker %in% v_visited)){
      v_visited <- c(v_visited, walker)
    }
    
    # get neighbors
    neighs <- incident(graph, mode = "out", v = walker)
    n_neighs <- length(neighs)
    
    # if there are no neighbors do a teleport
    if(n_neighs < 1){
      walker = sample(1:nv, 1)
      teleports = teleports + 1
    }
    # if there were toTel iteration without finding out new vertices
    else if (cnt >= toTel){
      walker = sample(1:nv, 1)
      teleports = teleports + 1
      cnt = 0
    }
    else{
      # get neighbors weights
      w_neighs <- vector(mode = "numeric", length = n_neighs)
      for(i in 1:n_neighs){
        w_neighs[i] <- get.edge.attribute(graph, name = "tmp", neighs[1])
      }
      
      # turn neighbors weights in probability (their sum is equal to 1)
      p_neighs <- w_neighs/(sum(w_neighs))
      
      # choose where the walker will go at the next step
      r <- runif(1)
      idx_next <- sum(r >= cumsum(c(0, p_neighs)))
      
      # get the endpoints of the choosen edge
      e_next <- ends(graph, neighs[idx_next])
      walker <- e_next[2]
    } # end else
    
  } # end while
  
  toRtrn <- list("visited" = v_visited,
                 "history" = v_history,
                 "teleports" = teleports                
                 )
  
} # end function



rand_walk_weighted_tp_dir <- function(pathIn, pathOut, form, times, toTel, seed,
                                   verbose = 1){
  
  # pattern to match
  patt = paste("*.", form, sep = "") 
  
  # take all files in pathIn
  files <- list.files(path = pathIn, pattern = patt) 
  
  toRtrn_steps <- vector(mode = "numeric", length = length(files))
  
  for(i in 1:length(files)) {
    
    cfile <- paste(pathIn, files[i], sep="")
    
    # check print
    if (verbose) {
      print ("Subject:")
      print (cfile)
    }
    
    # read the graph 
    g <- read.graph(cfile, format = form) 
    w <- abs(E(g)$fmri)
    
    # run random walk
    v_steps <- vector(mode = "numeric", length = times)
    v_teleports <- vector(mode = "numeric", length = times)
    v_visited <- list()
    for (t in 1:times){
      print(t)
      r_tmp <- rand_walk_weighted_tp(g, w, seed, toTel)
      v_steps[t] <- length(r_tmp$history)
      v_teleports[t] <- r_tmp$teleports
      v_visited <- c(v_visited, r_tmp$visited)
    } # end for t
    
    toRtrn_steps[i] <- mean(v_steps)
  } # end for i
  
  return(toRtrn_steps)
}# end function

