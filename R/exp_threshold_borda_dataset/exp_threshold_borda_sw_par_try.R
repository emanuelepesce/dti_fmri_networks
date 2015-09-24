rm(list = ls())
library("parallel")
library("foreach")
library("doParallel")
source("./../utils/graphUtils.R", chdir = T)
source("./../strong_weak_ties_cutting/sw_cutting.R", chdir = T)
source("./../gen_graphs/sw_labels/attachLabelsSW.R", chdir = T)
source("./../borda_sw_mask/borda_extracting_mask.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathBordaControls <- "./../../data/other/borda/borda_matrix_controls.txt"
pathBordaSLA2 <- "./../../data/other/borda/borda_matrix_SLA2.txt"
pathBordaSLA3 <- "./../../data/other/borda/borda_matrix_SLA3.txt"

thresholds <- seq(0.02, 0.04, 0.01)
maxIter <- length(thresholds)

# -------------------------- Running -------------------------------------------
calculateEdgesNumber <- function(tr){
  
  total_edges <- as.vector(1)
  strong_edges <- as.vector(1)
  weak_edges <- as.vector(1)
  
  # import graphs
  g_Controls <- i_adjacencyFromFile(pathBordaControls)
  g_SLA2 <- i_adjacencyFromFile(pathBordaSLA2)
  g_SLA3 <- i_adjacencyFromFile(pathBordaSLA3)

  print(tr)
  
  # compute residuals
  r_Controls <- sw_cutting(g_Controls, threshold = tr, flow = 0)
  if(verbose > 0){
    print("r_Controls complete")
  }
  
  residual_Controls <- r_Controls$residualGraph
  
  # union masks: first compute all masks, then do the union
  # computer all masks
  mask1 <- unionMask(residual_Controls, residual_Controls)
    maskU <- unique(mask1)

  
  total_edges <- dim(maskU)[1]
  print(total_edges)
  
  info_edge <- data.frame(threshold = tr, total = total_edges)
  
  return(info_edge)
}

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl, cores = detectCores() - 1)


clusterExport(cl, ls())

## A bootstrapping example, which can be done in many ways:
clusterEvalQ(cl, {  library(igraph)})

data <- clusterApply(cl, thresholds, calculateEdgesNumber)


# data <- foreach(j = 1:length(thresholds), packages = 'igraph', .combine = rbind) %dopar% {
#     source("./../utils/graphUtils.R", chdir = T)
#     source("./../strong_weak_ties_cutting/sw_cutting.R", chdir = T)
#     source("./../gen_graphs/sw_labels/attachLabelsSW.R", chdir = T)
#     source("./../borda_sw_mask/borda_extracting_mask.R", chdir = T)
#     calculateEdgesNumber(thresholds[j])
# }


stopCluster(cl)

t <- proc.time() - ptm
print(t)

save.image("workspace_exp_threshold_borda_sw.RData")
