#' Perform a T-Test in order to remove noise
#' 
#' Authors: Alessandro Merola, Emanuele Pesce
library(igraph)
library(miscTools)
source("./mysigntest.R")
#' Create a mask of edges using anova and bonferroni correction
#' 
#' @param pathIn: directory containing igraph files
#' @param tmu: mu value to use to use t-test
#' @param tr: threshold to use for cutting using p-values
#' @param verbose: if > 0 enable check prints
#' @param form: format of the graph file to read
#' 
#' @examples
#' pathIn <-  "./../../data/graphs_integration/full_connected/Controls/"
#' res <- t_test_edges_cutting(pathIn)
#' write.table(res$selected_edges, file = pathOut, sep=",", col.names = F, row.names = F)
sign_test_cutting <- function(pathC, pathS2, pathS3, tmu = 0,  tr = 0.05, verbose = 1, 
                                 form = "graphml") {

  l_pvalues <- list() # list containing p values
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
                
        res <- mySIGN.test(unlist(l_dti_values), conf.level=0.95)

        l_pvalues[kp] <- res[[1]]$p.value
        list_edges <- insertRow(list_edges, kp, c(vi,vj))
        kp <- kp + 1
       
       
      } 
    } # end for j
  }# end for i
  
  # apply bonferroni correction
  adj <- p.adjust(unlist(l_pvalues), "bonferroni")
  
  # cut evaluating the threshold 
  toSelect <- which(adj <= tr, arr.ind = T)
  selected_edges <- list_edges[toSelect,]
  
  # return 
  res <- list("adj" = adj, "p_values" = l_pvalues, 
              "selected_edges" = selected_edges);
  
  return(res) 
}

pathInC <- "./../../data/graphs_integration/full_connected/Controls/"
pathInS2 <- "./../../data/graphs_integration/full_connected/SLA2/"
pathInS3 <- "./../../data/graphs_integration/full_connected/SLA3/"

r <- sign_test_cutting(pathInC, pathInS2, pathInS3)



l_pvalues <- r$p_values
adj <- p.adjust(unlist(l_pvalues), "bonferroni")

# cut evaluating the threshold 
toSelect <- which(adj <= 0.01, arr.ind = T)
toSelect
selected_edges <- list_edges[toSelect,]
