#' Author: Emanuele Pesce
rm(list = ls())
source("./../k_means.R", chdir = T)
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
  pathIn_graphs <- "./../../../../data/graphs_integration/sign_test/SLA3/"
  pathIn_exampleGraph <- "./../../../../data/results/signtest_example_graph.graphml"
  
  pathOut_base <- paste("./../../../../data/results/k_means/", nc, "/sign_test/", sep ="")
  
  pathOut_coOc <- paste(pathOut_base, "coOc_sla3.csv", sep ="")
  pathOut_mem <- paste(pathOut_base, "membership_sla3.csv", sep ="")
  pathOut_heat <- paste(pathOut_base, "heatmap_sla3.jpeg", sep ="")
  pathOut_graph3D <- paste(pathOut_base, "graph3d_sla3.jpeg", sep ="")
  pathOut_graph2D <- paste(pathOut_base, "graph2d_sla3.jpeg", sep ="")
  
  tmain = "Heatmap sla3"
  
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
  plot_clust(coOc_m, nc, g, pathOut_graph2D, pathOut_graph3D, pathOutMem = pathOut_mem )
}
