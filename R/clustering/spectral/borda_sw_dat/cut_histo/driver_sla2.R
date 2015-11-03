#' spectral clustering on borda sla2
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./../spec_clust.R", chdir = T)
source("./../../generics/coOccurence.R", chdir = T)
source("./../../generics/make_heatmap.R", chdir = T)
source("./../../generics/plot_clust.R", chdir = T)

# --------------------------- Initialization -----------------------------------
# number of clusters
nc = 10

print("#######################################################")
print(nc)
pathIn_graphs <- "./../../../../data/graphs_integration/borda_sw_004/SLA2/"
pathIn_exampleGraph <- "./../../../../data/results/borda_example_graph.graphml"

pathOut_base <- "./../../../../data/results/spec_clust/cut_histo/borda_sw_004/"

pathOut_coOc <- paste(pathOut_base, "coOc_sla2.csv", sep ="")
pathOut_heat <- paste(pathOut_base, nc, "/heatmap_sla2.jpeg", sep ="")

tmain = "Heatmap sla2"

# --------------------------- Definition ---------------------------------------
mem_matrix <- specc_dir(pathIn_graphs, pathOut_coOc, centers=nc)

# remove the first two columns (vertices and roiNames values)
m <- mem_matrix[,-(1:2)]
m <- as.matrix(m) 
class(m) <- "numeric"

# calculate coOccurence matrix
coOc_m<- coOccurrence(m)

# heatmap
H <- makeHeatmap(coOc_m, pathOut = pathOut_heat, tmain = tmain)

# plot graphs
g <- read.graph(pathIn_exampleGraph, format = "graphml")

for (nc in 6:11){  
  pathOut_mem <- paste(pathOut_base, nc, "/membership_sla2.csv", sep ="")
  pathOut_graph3D <- paste(pathOut_base, nc, "/graph3d_sla2.jpeg", sep ="")
  pathOut_graph2D <- paste(pathOut_base, nc, "/graph2d_sla2.jpeg", sep ="")
  
  plot_clust(coOc_m, nc, g, pathOut_graph2D, pathOut_graph3D, pathOutMem = pathOut_mem )
}