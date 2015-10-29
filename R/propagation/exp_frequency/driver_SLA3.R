source("./../rand_walk_weighted.R", chdir = T)

# --------------------------- Initialization -----------------------------------
pathIn <- "./../../../data/graphs_integration/borda_sw_004/SLA3/"

# --------------------------- Running ------------------------------------------

resS3 <- rand_walk_weighted_dir(pathIn, pathOut, form, times, maxiter, seed)
  
  
