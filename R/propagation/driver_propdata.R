rm(list=ls())
library(igraph)
source("./analysis_prop_func.R", chdir = T)


# ================================ Initialization ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/fmri/prop_ctrl_fmri_r67.RData"
pathIn.sla2 <- "./random_walk/borda/fmri/prop_sla2_fmri_r67.RData"
pathIn.sla3 <- "./random_walk/borda/fmri/prop_sla3_fmri_r67.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")
g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- "./analysis_complete.RData"

# =============================== Running ======================================
res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

prop_analysys(res.prop, freq.k = 10, g, pathOut.obj)
load(pathOut.obj)
analysis.prop
