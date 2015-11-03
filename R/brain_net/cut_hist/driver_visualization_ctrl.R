#' Generate files for visualizing graphs with brainnet tool
#' 
rm(list=ls())
source("./../../utils/gen_brain_net_visualization.R", chdir = T)
# =========================== borda ===========================================
pathIn.graph <- "./../../../data/results/borda_example_graph.graphml"


path.base <- "./../../../data/results/spec_clust/cut_histo/borda_sw_004/"

# =========================== borda  ===========================================
dirs_1 <-list.files(path.base, pattern = "^.csv")
for(d in dirs_1){
  pathIn.dir <- paste(path.base, d, "/", sep = "")
  pathOut.dir <- paste(path.base ,d, "/brain_net/", sep = "")
  
  
  pathIn.membership <- paste(pathIn.dir, "membership_controls.csv", sep = "")
  pathOut.node <- paste(pathOut.dir, "ctrl_node.node", sep = "")
  
  pathOut.edge <- paste(pathOut.dir, "ctrl_fmri.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "fmri")
  pathOut.edge <- paste(pathOut.dir, "ctrl_dti.edge", sep = "")
  gen_all_files_brainnet(pathIn.graph, pathIn.membership, pathOut.node, 
                         pathOut.edge, e.attr = "dti")  
}