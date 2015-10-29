rm(list=ls())
library("parallel")
library(igraph)
source("./rand_walk_weighted.R", chdir = T)

p_graphs <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA2.RData"
pathOut <- "res_frequency_SLA2.RData"
load(p_graphs)
graphs <- igraphs_controls

myRandWalk <- function(idx){
  
  times = 100
  seed = 19
  maxiter = 4000
  
  graph <- graphs[[idx]]
  w <- abs(E(graph)$fmri)
  
  # run random walk
  v_steps <- vector(mode = "numeric", length = times)
  v_nvisited <- NULL
  v_visited <- list()
  for (t in 1:times){
    print(t)
    r_tmp <- rand_walk_weighted(graph, w, seed, maxiter)
    v_steps[t] <- length(r_tmp$history)
    v_visited <- r_tmp$visited
    v_nvisited <- c(v_nvisited, length(v_visited))
  } # end for t
  
  toRtrn_nvisited <- mean(v_nvisited) 
  toRtrn_steps <- mean(v_steps)
  
  toRtrn <- list("nsteps" = toRtrn_steps, "nvisited" = toRtrn_nvisited)
}


# running


ptm <- proc.time()
ng <- 1:length(graphs)

nc <- 2
cl <- makeCluster(nc)

clusterExport(cl, ls())
clusterEvalQ(cl, {  library(igraph)})
data <- clusterApply(cl, ng, myRandWalk)
stopCluster(cl)

t <- proc.time() - ptm
print(t)

save.image(pathOut)
