rm(list = ls())
source("./../rand_walk_weighted.R", chdir = T)


# --------------------------- Initialization -----------------------------------
pathIn <- "./../../../data/graphs_integration/borda_sw_004/SLA3/"

form = "graphml"
times = 1
toTel = 20
seed = 69

# --------------------------- Running ------------------------------------------

res <- rand_walk_weighted_dir(pathIn, pathOut, form, times, toTel, seed)
  
  
