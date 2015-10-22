#' driver_controls
#' 
#' spectral clustering on borda controls
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./../fanny_cl.R", chdir = T)
source("./../../generics/coOccurence.R", chdir = T)
source("./../../generics/make_heatmap.R", chdir = T)
source("./../../generics/plot_clust.R", chdir = T)

# --------------------------- Initialization -----------------------------------
# number of clusters
kmin <- 6
kmax <- 11
for(nc in kmin:kmax){
  print("#######################################################")
  print(nc)
  pathIn_graphs <- "./../../../../data/graphs_integration/borda_sw_004/Controls/"
  pathIn_exampleGraph <- "./../../../../data/results/borda_example_graph.graphml"
  
  pathOut_base <- paste("./../../../../data/results/fanny/", nc, "/borda_sw_004/", sep ="")
  
  pathOut_mem <- paste(pathOut_base, "membership_controls.csv", sep ="")
  pathOut_heat <- paste(pathOut_base, "heatmap_controls.jpeg", sep ="")
  pathOut_graph3D <- paste(pathOut_base, "graph3d_controls.jpeg", sep ="")
  pathOut_graph2D <- paste(pathOut_base, "graph2d_controls.jpeg", sep ="")
  
  tmain = "Heatmap Controls"
  
  # --------------------------- Definition ---------------------------------------
  mem_matrix <- specc_dir(pathIn_graphs, pathOut_mem, centers=nc)
  
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
  plot_clust(coOc_m, nc, g, pathOut_graph2D, pathOut_graph3D)
  
}



