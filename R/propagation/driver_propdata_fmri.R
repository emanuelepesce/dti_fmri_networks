rm(list=ls())
library(igraph)
source("./analysis_prop_func.R", chdir = T)


# ================================ Region 1 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/fmri/prop_ctrl_fmri_r1.RData"
pathIn.sla2 <- "./random_walk/borda/fmri/prop_sla2_fmri_r1.RData"
pathIn.sla3 <- "./random_walk/borda/fmri/prop_sla3_fmri_r1.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri/analysis_prop_r1.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")

freq.k = 100

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

prop_analysys(res.prop, freq.k = freq.k, g, pathOut.obj)
load(pathOut.obj)
save(analysis.prop, file = pathOut.save)
analysis.prop


# ================================ Region 2 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/fmri/prop_ctrl_fmri_r2.RData"
pathIn.sla2 <- "./random_walk/borda/fmri/prop_sla2_fmri_r2.RData"
pathIn.sla3 <- "./random_walk/borda/fmri/prop_sla3_fmri_r2.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri/analysis_prop_r2.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

prop_analysys(res.prop, freq.k = freq.k, g, pathOut.obj)
load(pathOut.obj)
save(analysis.prop, file = pathOut.save)
analysis.prop


# ================================ Region 67 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/fmri/prop_ctrl_fmri_r67.RData"
pathIn.sla2 <- "./random_walk/borda/fmri/prop_sla2_fmri_r67.RData"
pathIn.sla3 <- "./random_walk/borda/fmri/prop_sla3_fmri_r67.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri/analysis_prop_r67.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

prop_analysys(res.prop, freq.k = freq.k, g, pathOut.obj)
load(pathOut.obj)
save(analysis.prop, file = pathOut.save)
analysis.prop


# ================================ Region 68 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/fmri/prop_ctrl_fmri_r68.RData"
pathIn.sla2 <- "./random_walk/borda/fmri/prop_sla2_fmri_r68.RData"
pathIn.sla3 <- "./random_walk/borda/fmri/prop_sla3_fmri_r68.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/fmri/analysis_prop_r68.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

prop_analysys(res.prop, freq.k = freq.k, g, pathOut.obj)
load(pathOut.obj)
save(analysis.prop, file = pathOut.save)
analysis.prop