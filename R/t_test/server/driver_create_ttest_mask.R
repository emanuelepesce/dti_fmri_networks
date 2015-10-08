#'  Driver for creating ttest mask
#' 
#'  Cut edges using t_test and bonferroni correction. 
#'  Create a mask for each dataset (controls, sla2, sla3)
#'  Unify masks.
rm(list = ls())
source("./t_test_mask.R", chdir = T)
library(igraph)

# ------------------------ Initialization --------------------------------------
pathIn_controls <- "./../../../data/graphs_integration/full_connected/Controls/"
pathIn_sla2 <- "./../../../data/graphs_integration/full_connected/SLA2/"
pathIn_sla3 <- "./../../../data/graphs_integration/full_connected/SLA3/"

tmu = 0
threshold = 0.05



## save lists of graphs
# list_graph_c <- get_list_graphs(pathIn_controls)
# list_graph_s2 <- get_list_graphs(pathIn_sla2)
# list_graph_s3 <- get_list_graphs(pathIn_sla3)
# save.image("lists_graphs.RData")



# ------------------------ Running ---------------------------------------------
load("./lists_graphs.RData")
res_controls <- t_test_edges_cutting1(pathIn_controls, list_graphs = list_graph_c)
save(res_controls, file = "res_controls.RData")
res_sla2 <- t_test_edges_cutting1(pathIn_sla2, list_graphs = list_graph_s2)
save(res_sla2, file = "res_sla2.RData")
res_sla3 <- t_test_edges_cutting1(pathIn_sla3, list_graphs = list_graph_s3)
save(res_sla3, file = "res_sla3.RData")

save.image("results_lists_graphs.RData")

