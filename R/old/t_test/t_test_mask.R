#' Perform a T-Test in order to remove noise
#' 
#' Authors: Alessandro Merola, Emanuele Pesce
library(igraph)
library(miscTools)


#' Create a mask of edges using t-test and bonferroni correction
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
t_test_edges_cutting <- function(pathIn, tmu = 0,  tr = 0.05, verbose = 1, 
                                 form = "graphml") {

  l_pvalues <- list() # list containing p values
  list_edges <- matrix(nrow = 0, ncol = 2) # edges list
  
  k <- 1              # counter for edges
  kp <- 1             # counter for l_pvalues
  kr <- 1             # counter for taken edges
  
  verbose = 1
  
  # ---- Create a list of graph objects in pathIn
  list_graphs <- list()
  patt <- paste("*", form, sep = "")
  files_names <- list.files(path = pathIn, pattern = patt) # names of graph files in pathIn
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathIn, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs[[k]] <- g
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
        for(k in 1:length(list_graphs)) {
          g <- list_graphs[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            inx <- inx + 1
          }          
        }
        
        # Performing the t-test on a single edge
        tt <-  try(t.test(unlist(l_dti_values), mu = tmu), silent = TRUE)
        if(!is(tt, "try-error")){
          l_pvalues[kp] <- tt$p.value
          list_edges <- insertRow(list_edges, kp, c(vi,vj))
          kp <- kp + 1
        }
        else{
          l_pvalues[kp] <- 1
          list_edges <- insertRow(list_edges, kp, c(vi,vj))
          kp <- kp + 1
        }
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
