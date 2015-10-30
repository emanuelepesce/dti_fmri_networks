#' Generate files for visualizing graphs with brainnet tool
#' 

rm(list=ls())
source("./../utils/gen_brain_net_visualization.R", chdir = T)
# =========================== borda ===========================================
pathIn.graph <- "./../../data/results/borda_example_graph.graphml"


path.base <- "./../../data/results/spec_clust/"

# =========================== borda  ===========================================
dirs_1 <-list.files(path.base)
for(d in dirs_1){
  pathIn.dir <- paste(path.base, d, "/borda_sw_004/", sep = "")
  pathOut.dir <- paste(path.base ,d, "/borda_sw_004/brain_net/", sep = "")
  
  
  pathIn.membership <- paste(pathIn.dir, "membership_sla3.csv", sep = "")
  pathOut.node <- paste(pathOut.dir, "sla3_node.node", sep = "")
  
  pathOut.edge <- paste(pathOut.dir, "sla3fmri.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "fmri")
  pathOut.edge <- paste(pathOut.dir, "sla3_dti.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "dti")  
}

# =========================== sign test ========================================
pathIn.graph <- "./../../data/results/signtest_example_graph.graphml"

path.base <- "./../../data/results/spec_clust/"

# =========================== borda  ===========================================
dirs_1 <-list.files(path.base)
for(d in dirs_1){
  pathIn.dir <- paste(path.base, d, "/sign_test/", sep = "")
  pathOut.dir <- paste(path.base ,d, "/sign_test/brain_net/", sep = "")
  
  
  pathIn.membership <- paste(pathIn.dir, "membership_sla3.csv", sep = "")
  pathOut.node <- paste(pathOut.dir, "sla3_node.node", sep = "")
  
  pathOut.edge <- paste(pathOut.dir, "sla3_fmri.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "fmri")
  pathOut.edge <- paste(pathOut.dir, "sla3_dti.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "dti")  
}