rm(list=ls())
library(igraph)
source("./analysis_prop_func.R", chdir = T)


# ================================ Region 1 ==============================
pathIn.ctrl <- "./random_walk/borda/fmri_times_dti/prop_ctrl_times_r1.RData"
pathIn.sla2 <- "./random_walk/borda/fmri_times_dti/prop_sla2_times_r1.RData"
pathIn.sla3 <- "./random_walk/borda/fmri_times_dti/prop_sla3_times_r1.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri_times_dti/analysis/analysis_prop_r1.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")


freq.k = 100

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)



# ================================ Region 2 ==============================
pathIn.ctrl <- "./random_walk/borda/fmri_times_dti/prop_ctrl_times_r2.RData"
pathIn.sla2 <- "./random_walk/borda/fmri_times_dti/prop_sla2_times_r2.RData"
pathIn.sla3 <- "./random_walk/borda/fmri_times_dti/prop_sla3_times_r2.RData"

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri_times_dti/analysis/analysis_prop_r2.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)



# ================================ Region 67 ==============================
pathIn.ctrl <- "./random_walk/borda/fmri_times_dti/prop_ctrl_times_r67.RData"
pathIn.sla2 <- "./random_walk/borda/fmri_times_dti/prop_sla2_times_r67.RData"
pathIn.sla3 <- "./random_walk/borda/fmri_times_dti/prop_sla3_times_r67.RData"

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri_times_dti/analysis/analysis_prop_r67.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)



# ================================ Region 68 ==============================
pathIn.ctrl <- "./random_walk/borda/fmri_times_dti/prop_ctrl_times_r68.RData"
pathIn.sla2 <- "./random_walk/borda/fmri_times_dti/prop_sla2_times_r68.RData"
pathIn.sla3 <- "./random_walk/borda/fmri_times_dti/prop_sla3_times_r68.RData"

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri_times_dti/analysis/analysis_prop_r68.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)
