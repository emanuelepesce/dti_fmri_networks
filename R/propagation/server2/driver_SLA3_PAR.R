rm(list=ls())
library("parallel")
library(igraph)
source("./rand_walk_weighted_2.R", chdir = T)

p_graphs <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA3.RData"
pathOut <- "res_sla3.RData"
load(p_graphs)
graphs <- igraphs_SLA3

myRandWalk <- function(idx){
  
  times = 2
  seed = 1
  maxiter = 4000
  
  graph <- graphs[[idx]]
  w <- abs(E(graph)$fmri)
  f_edge <- rep(0, length = ecount(graph))
  
  
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


# running

# graphs[[1]]
# myRandWalk(1)

ptm <- proc.time()
ng <- 1:length(graphs)

nc <- 3
cl <- makeCluster(nc)

clusterExport(cl, ls())
clusterEvalQ(cl, {  library(igraph)})
data <- clusterApply(cl, ng, myRandWalk)
stopCluster(cl)


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

resSla3 <- list("f_edge" = f_edge, "sbj_history" = sbj_history,
                "sbj_times" = sbj_times, "sbj_order" = sbj_order)


t <- proc.time() - ptm
print(t)

save(resSla3, file = pathOut)
