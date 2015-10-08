#' driver_Controls
#' 
#' Attach 'strong' label to all graph in a directory.
#' 
#' If strong == 1 then the edge belongs to strong ties set.
#' This file use the object borda_sw_cut_objects.RData which cointains the 
#' results of SW cutting procedure, done when mask has been extracted.
#' 
#' Author: Emanuele Pesce

rm(list=ls())
source("./../../gen_graphs/sw_labels/attachLabelsSW.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

path_borda_controls <- "./../../../data/other/borda/borda_matrix_controls.txt"
path_borda_sla2 <- "./../../../data/other/borda/borda_matrix_SLA2.txt.txt"
path_borda_sla3 <- "./../../../data/other/borda/borda_matrix_SLA3.txt"

pathIn_data <- "./../../../data/other/t_test_005/t_test_sw_cut_objects.RData"

pathTarget <- "./../../../data/graphs_integration/ttest_005/SLA3/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

# get borda matrix
# g_controls <- i_adjacencyFromFile(path_borda_controls)
# g_sla2 <- i_adjacencyFromFile(path_borda_sla2)
# g_sla3 <- i_adjacencyFromFile(path_borda_sla3)

# load result objects of cutting procedure in order to retrieve the correct set 
# of strong ties
load(pathIn_data)

# get labels
labels <- getLabels(RC)

applyAttachLabel(pathTarget, pathTarget, labels, labels, labels)

# =============== check MST mask ====================
#   cnt <- 0
#   for(i in 1:dim(controlsLabels)[1]){
#     vs_c <- controlsLabels[i,1]
#     vt_c <- controlsLabels[i,2]
#     for (j in 1:dim(patientsLabels)[1]){
#       vs_p <- patientsLabels[j,1]
#       vt_p <- patientsLabels[j,2]
#       if((vs_c == vs_p) && (vt_c == vt_p)){
#         cnt = cnt + 1
#       }
#     }
#   }

# g <- read.graph( "./../../../data/graphs_integration/full_connected/Controls/CTRL_amore.graphml", format="graphml")



time  <- proc.time() - ptm
print(time)
