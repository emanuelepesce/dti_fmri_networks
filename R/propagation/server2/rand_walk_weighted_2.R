library(igraph)
library(miscTools)

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
#' @example 
#' p_graph <- "./../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"
#' g <- read.graph(p_graph, format= "graphml")
#' w <- abs(E(g)$fmri)
#' res <- rand_walk_weighted(g, w, 19, maxiter = 2000)
rand_walk_weighted <- function(graph, weights, seed, maxiter = 3000){

  v_visited <- vector()   # visited vertices
  v_history <- vector()   # sequence of visited vertices
  f_edge <- rep(0, length = ecount(graph))
  
  nv <- vcount(graph)
  walker <- seed 
  
  # check if length of weights is ok
  if(length(weights) != ecount(graph)){
    return(-1)
  }
  
  # set attribute
  graph <- set.edge.attribute(graph, name = "tmp", index = E(graph), weights)
  
  cnt <- 0 
  while( (length(v_visited) < 90) && (cnt <= maxiter) ){
    cnt <- cnt + 1
    
    # update history
    v_history <- c(v_history, walker)
    
    # check if the walker is a vertex which has never visited before
    if(!(walker %in% v_visited)){
      v_visited <- c(v_visited, walker)
    }
    
    # get neighbors
    neighs <- incident(graph, mode = "out", v = walker)
    n_neighs <- length(neighs)
    
    # if there are no neighbors stop it
    if(n_neighs < 1){
      cnt = maxiter
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
      
      #update frequency
      idx_edge <- get.edge.ids(graph, c(e_next[1],e_next[2]))
      f_edge[idx_edge] <- f_edge[idx_edge] + 1
      
    } # end else
    
  } # end while
  
  toRtrn <- list("v_order" = v_visited,
                 "v_history" = v_history,
                 "f_edge" = f_edge
                 )
  
} # end function



rand_walk_weighted_dir <- function(pathIn, pathOut, form = "graphml", times, 
                                   maxiter, seed, verbose = 1){
  
  # pattern to match
  patt = paste("*.", form, sep = "") 
  
  # take all files in pathIn
  files <- list.files(path = pathIn, pattern = patt) 
  
  toRtrn_steps <- vector(mode = "numeric", length = length(files))
  toRtrn_nvisited <- vector(mode = "numeric", length = length(files))
  
  # get an example graph
  cfile <- paste(pathIn, files[1], sep="")
  g <- read.graph(cfile, format = form) 
  f_edge <- rep(0, length = ecount(g))
  
  sbj_history <- list()
  
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
    v_times <- vector(mode = "numeric", length = times)
    v_order <- vector(mode = "numeric", length = times)
    l_history <- list()
    for (t in 1:times){
      print(t)
      r_tmp <- rand_walk_weighted(g, w, seed, maxiter)
      # lengths of times and orders
      v_times[t] <- length(r_tmp$v_history)
      v_order[t] <- length(r_tmp$v_order)
      # history path
      l_history[[t]] <- r_tmp$v_history
      # frequency
      f_edge <- f_edge + r_tmp$f_edge
      
    } # end for t

  # matrix of times, row = subject, col = run of randomwalk
  if (i == 1){
    sbj_times <- as.matrix(t(v_times))
    
  }
  else{
    sbj_times <- insertRow(sbj_times, i, v_times)
  }
  
  # matrix of orders, row = subject, col = run of randomwalk
  if (i == 1){
    sbj_order <- as.matrix(t(v_order))
    
  }
  else{
    sbj_order <- insertRow(sbj_order, i, v_order)
  }
  
  # list, each element is a subject. For each subject there is a list of paths
  # (a path for every run of randomwalk)
  sbj_history[[i]] <- l_history
    
  } # end for i
  
  
  
  toRtrn <- list("f_edge" = f_edge, "sbj_history" = sbj_history,
                 "sbj_times" = sbj_times, "sbj_order" = sbj_order)
  return(toRtrn)
}# end function

# ==== examples ====
# p_graph <- "./../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"
# g <- read.graph(p_graph, format= "graphml")
# w <- abs(E(g)$fmri)
# res <- rand_walk_weighted(g, w, 19, maxiter = 2000)
# res
# res2 <- rand_walk_weighted_dir(pathIn = "./data_toy/", times = 3, maxiter = 5000, seed = 1)
