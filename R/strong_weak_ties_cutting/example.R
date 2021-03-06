source("./sw_cutting.R", chdir = T)

if(interactive()){
  ptm <- proc.time()
  g <- i_adjacencyFromFile("./../../data/other/borda/borda_matrix_controls.txt")

  R <- sw_cutting(g, threshold = 0.05, flow = 0)
  
  print("Number of edges before cutting")
  print(length(E(g)))
  
  print("Number of edges after cutting:")
  print(R$n_residualEdges)
  
  print("Number of cutted edges:")
  print(R$n_cuttedEdges)
  
  print("Number of utils edges:") 
  print(R$n_strong)

  time  <- proc.time() - ptm
  print(time)
}