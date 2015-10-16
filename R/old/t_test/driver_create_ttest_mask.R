#'  Driver for creating ttest mask
#' 
#'  Cut edges using t_test and bonferroni correction. 
#'  Create a mask for each dataset (controls, sla2, sla3)
#'  Unify masks.
rm(list = ls())
source("./t_test_mask.R", chdir = T)
library(igraph)

# ------------------------ Initialization --------------------------------------
pathIn_controls <- "./../../data/graphs_integration/full_connected/Controls/"
pathIn_sla2 <- "./../../data/graphs_integration/full_connected/SLA2/"
pathIn_sla3 <- "./../../data/graphs_integration/full_connected/SLA3/"

tmu = 0
threshold = 0.01

# ------------------------ Running ---------------------------------------------
res_controls <- t_test_edges_cutting(pathIn_controls, tr = threshold)
res_sla2 <- t_test_edges_cutting(pathIn_sla2, tr = threshold )
res_sla3 <- t_test_edges_cutting(pathIn_sla3, tr = threshold)
r <- t_test_edges_cutting("./toyData/")