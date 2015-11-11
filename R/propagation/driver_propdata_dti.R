rm(list=ls())
library(igraph)
source("./analysis_prop_func.R", chdir = T)


# ================================ Region 1 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_dti_complete_r1/"
pathIn.ctrl <- "./random_walk/borda/dti/prop_ctrl_dti_r1.RData"
pathIn.sla2 <- "./random_walk/borda/dti/prop_sla2_dti_r1.RData"
pathIn.sla3 <- "./random_walk/borda/dti/prop_sla3_dti_r1.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/dti/analysis_prop_r1.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")


freq.k <- 100

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)


# ================================ Region 2 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_dti_complete_r2/"
pathIn.ctrl <- "./random_walk/borda/dti/prop_ctrl_dti_r2.RData"
pathIn.sla2 <- "./random_walk/borda/dti/prop_sla2_dti_r2.RData"
pathIn.sla3 <- "./random_walk/borda/dti/prop_sla3_dti_r2.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/dti/analysis_prop_r2.RData"

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

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)



# ================================ Region 67 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_dti_complete_r67/"
pathIn.ctrl <- "./random_walk/borda/dti/prop_ctrl_dti_r67.RData"
pathIn.sla2 <- "./random_walk/borda/dti/prop_sla2_dti_r67.RData"
pathIn.sla3 <- "./random_walk/borda/dti/prop_sla3_dti_r67.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/dti/analysis_prop_r67.RData"

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

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)



# ================================ Region 68 ==============================
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_dti_complete_r68/"
pathIn.ctrl <- "./random_walk/borda/dti/prop_ctrl_dti_r68.RData"
pathIn.sla2 <- "./random_walk/borda/dti/prop_sla2_dti_r68.RData"
pathIn.sla3 <- "./random_walk/borda/dti/prop_sla3_dti_r68.RData"

pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")

pathOut.save <- "./../../data/results/propagation/random_walk/borda/dti/analysis_prop_r68.RData"

g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- "./analysis_complete.RData"

res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

res <- prop_analysys(res.prop, freq.k = freq.k, g, pathOut.save)
