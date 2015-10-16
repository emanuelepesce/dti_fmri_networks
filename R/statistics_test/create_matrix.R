rm(list=ls())
library(igraph)
library(miscTools)
create_matrix <- function(pathC, pathS2, pathS3, tmu = 0,  tr = 0.05, verbose = 1, 
                              form = "graphml") {
  
  first <- TRUE
  mat <- matrix()
  list_edges <- matrix(nrow = 0, ncol = 2) # edges list
  
  k <- 1              # counter for edges
  kp <- 1             # counter for l_pvalues
  kr <- 1             # counter for taken edges
  
  patt <- paste("*", form, sep = "")
  
  verbose = 1
  
  # ---- Create a list of Controls graphs
  list_graphs_C <- list()
  files_names <- list.files(path = pathC, pattern = patt) # names of graph files in pathIn
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathC, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_C[[k]] <- g
    k <- k + 1    
  }
  
  
  # ---- Create a list of Sla2 graphs
  list_graphs_S2 <- list()
  files_names <- list.files(path = pathS2, pattern = patt) # names of graph files in pathIn
  k <- 1
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathS2, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_S2[[k]] <- g
    k <- k + 1    
  }
  
  # ---- Create a list of Sla3 graphs
  list_graphs_S3 <- list()
  files_names <- list.files(path = pathS3, pattern = patt) # names of graph files in pathIn
  k <- 1
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathS3, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_S3[[k]] <- g
    k <- k + 1    
  }
  
  
  # ----  Generate all pairs of vertices (edges)
  #       For edge get all dti values of all graphs
  #       Computer t-test
  n_vertices <- vcount(g)
  for(i in 1:n_vertices) {
    vi <- i                     # fist vertex
    for (j in 1:n_vertices) {
      vj <- j                   # second vertex
      l_dti_values <- list()    #inizialize list of dti values for the edge vi-vj
      class_values <- list()
      
      # Check print
      if (verbose > 0) {
        print("Egde:")
        print(vi)
        print(vj)
      }
      
      # If the pair is valid
      if (vi != vj) { 
        
        # For each graph take the dti edge value (vi-vj)
        inx <- 1
        g <- NULL   # security check
        for(k in 1:length(list_graphs_C)) {
          g <- list_graphs_C[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "controls"
            inx <- inx + 1
          }          
        }
        
        for(k in 1:length(list_graphs_S2)) {
          g <- list_graphs_S2[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "sla2"
            inx <- inx + 1
          }          
        }  
        
        
        for(k in 1:length(list_graphs_S3)) {
          g <- list_graphs_S3[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "sla3"
            inx <- inx + 1
          }          
        }
        
#         mat <- insertRow(mat, kp, as.vector(unlist(l_dti_values)))
#         kp = kp + 1
        
        if (first){
          mat <- as.matrix(t(as.vector(unlist(l_dti_values))))
          list_edges <- insertRow(list_edges, kp, c(vi,vj))
          kp = kp +1
          first = FALSE
        }
        else{
          mat <- insertRow(mat, kp, t(as.vector(unlist(l_dti_values))))
          list_edges <- insertRow(list_edges, kp, c(vi,vj))
          kp = kp + 1
        }
        mat
      } 
    } # end for j
  }# end for i

  # return 
  res <- list("mat" = mat, "list_edges" = list_edges);
  return(mat) 
}


pathInC <- "./../../data/graphs_integration/full_connected/Controls/"
pathInS2 <- "./../../data/graphs_integration/full_connected/SLA2/"
pathInS3 <- "./../../data/graphs_integration/full_connected/SLA3/"

r <- create_matrix(pathInC, pathInS2, pathInS3)

save.image("matrix_ws.RData")