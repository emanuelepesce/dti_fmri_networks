rm(list = ls())
library("parallel")
# library("foreach")
# library("doParallel")
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

thresholds <- seq(0.03, 0.05, 0.01)
# thresholds <- 0.6
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
  r_SLA2 <- sw_cutting(g_SLA2, threshold = tr, flow = 0)
  if(verbose > 0){
    print("r_SLA2  complete")
  }
  r_SLA3 <- sw_cutting(g_SLA3, threshold = tr, flow = 0)
  if(verbose > 0){
    print("r_SLA3 complete")
  }
  
  residual_Controls <- r_Controls$residualGraph
  residual_SLA2 <- r_SLA2$residualGraph
  residual_SLA3 <- r_SLA3$residualGraph
  
  # union masks: first compute all masks, then do the union
  # computer all masks
  mask1 <- unionMask(residual_Controls, residual_SLA2)
  mask2 <- unionMask(residual_Controls, residual_SLA3)
  # union
  maskU <- rbind(mask1, mask2)
  maskU <- unique(maskU)
  
  # numeric mask
  new_mask <- matrix(nrow = dim(maskU)[1], ncol = 2)
  for(i in 1:dim(maskU)[1]){
    tmp <- gsub("V","", maskU[i, 1])
    new_mask[i,1] <- as.integer(tmp)
    tmp <- gsub("V","", maskU[i, 2])
    new_mask[i,2] <- as.integer(tmp)
  }
  
  total_edges <- dim(maskU)[1]
  print(total_edges)
  
  # calculate the number of strong ties
  g <- make_full_graph(90, TRUE, TRUE)
  
  # calculate labels
  lab_controls <- getLabels(r_Controls)
  lab_sla2 <- getLabels(r_SLA2)
  lab_sla3 <- getLabels(r_SLA3)
  
  # attach labels
  g <- attachLabels(g, lab_controls, set = TRUE)
  g <- attachLabels(g, lab_sla2, set = FALSE)
  g <- attachLabels(g, lab_sla3, set = FALSE)
  
  strong_edges <- sum(E(g)$strong == 1)
  
  weak_edges <- total_edges - strong_edges
  
  info_edge <- data.frame(threshold = tr, total = total_edges, strong = 
                            strong_edges, weak= weak_edges)
  
  return(info_edge)
}

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

nc <- 2
cl <- makeCluster(nc)

# cl <- makeCluster(detectCores() - s)
# registerDoParallel(cl, cores = detectCores() - s)


clusterExport(cl, ls())

## A bootstrapping example, which can be done in many ways:
clusterEvalQ(cl, {  library(igraph)})

data <- clusterApply(cl, thresholds, calculateEdgesNumber)

stopCluster(cl)

t <- proc.time() - ptm
print(t)

save.image("workspace_exp_threshold_borda_sw_par_good.RData")
