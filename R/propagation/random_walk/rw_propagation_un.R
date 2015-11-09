library("parallel")
library(igraph)
library(miscTools)

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



myRandWalk <- function(idx, graphs, seed, times, maxiter = 4000){
  
  graph <- graphs[[idx]]
  w <- abs(E(graph)$fmri)
  f_edge <- rep(0, length = ecount(graph))
  
  ug <- set.edge.attribute(graph, name = "tmp_att", index = E(graph), value = w)
  ug <- as.undirected(ug, mode = "each", edge.attr.comb = list(tmp_att= "mean", "ignore"))
  graph <- ug
  w <- E(graph)$tmp_att
  
  # run random walk
  v_times <- vector(mode = "numeric", length = times)
  v_order <- vector(mode = "numeric", length = times)
  l_history <- list()
  for (t in 1:times){
    print(t)
    r_tmp <- rand_walk_weighted(graph, w, seed, maxiter)
    # lengths of times and orders
    v_times[t] <- length(r_tmp$v_history)
    v_order[t] <- length(r_tmp$v_order)
    # history path
    l_history[[t]] <- r_tmp$v_history
    # frequency
    f_edge <- f_edge + r_tmp$f_edge
  }
  
  toRtrn <- list("f_edge" = f_edge, "v_times" = v_times,
                 "v_order" = v_order, "l_history" = l_history)
}


driver_exp <- function(cl, seed, times, maxiter, pathIn, group, pathOut){
  load(pathIn)
  res.name <- gsub(".RData", "", pathOut)
  if(group == "c"){
    graphs <- igraphs_controls
  }
  else if(group == "s2"){
    graphs <- igraphs_SLA2
  }
  else if(group == "s3"){
    graphs <- igraphs_SLA3
  }
  
  ng <- 1:length(graphs)
  
#   cl <- makeCluster(nc)
  clusterEvalQ(cl, {library(igraph)})
  clusterEvalQ(cl, {library(miscTools)})
  clusterExport(cl, ls(), envir=environment())
  clusterExport(cl, list("myRandWalk", "rand_walk_weighted"))
  data <- clusterApply(cl, ng, myRandWalk, graphs, seed, times, maxiter)
#   stopCluster(cl)
  
  
  n_sbj <- length(data)
  sbj_history <- list()
  f_edge <- data[[1]]$f_edge
  
  for(i in 1:n_sbj){
    
    f_edge <- f_edge + data[[i]]$f_edge 
    
    # matrix of times, row = subject, col = run of randomwalk
    if (i == 1){
      sbj_times <- as.matrix(t(data[[i]]$v_times))
      
    }
    else{
      sbj_times <- insertRow(sbj_times, i, data[[i]]$v_times)
    }
    
    # matrix of orders, row = subject, col = run of randomwalk
    if (i == 1){
      sbj_order <- as.matrix(t(data[[i]]$v_order))
      
    }
    else{
      sbj_order <- insertRow(sbj_order, i, data[[i]]$v_order)
    }
    
    # list, each element is a subject. For each subject there is a list of paths
    # (a path for every run of randomwalk)
    sbj_history[[i]] <- data[[i]]$l_history
  }
  
  data.prop <- list("info" = res.name, "f_edge" = f_edge, "sbj_history" = sbj_history,
                  "sbj_times" = sbj_times, "sbj_order" = sbj_order)
  
  
  save(data.prop, file = pathOut)
}

pathIn.sla3 <- "./../../../data/graphs_integration/sign_test/igraphs_SLA3.RData"
load(pathIn.sla3)
graph <- igraphs_SLA3[[1]]

w <- abs(E(graph)$fmri)

ug <- set.edge.attribute(graph, name = "tmp_att", index = E(graph), value = w)
ug <- as.undirected(ug, mode = "each", edge.attr.comb = list(tmp_att= "mean", "ignore"))
graph <- ug
w <- E(graph)$tmp_att

rand_walk_weighted(graph, E(graph)$tmp_att, 1, 100)

# cl <- makeCluster(1)
# driver_exp(cl, 1, 1, 1000, pathIn.sla3, "s3", "prova.RData")
# stopCluster(cl)
