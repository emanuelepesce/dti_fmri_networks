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
    g <- read.graph(cfile, format = form)    # Recupero il grafo di questo file
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
        tt <- t.test(unlist(l_dti_values), mu = tmu)
        l_pvalues[kp] <- tt$p.value
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



# Compute the mask's union
makeUnion <- function(ctrl, pznt) {
  
  unionList <- matrix(nrow = 0, ncol = 2)
  k <- 1
  for (i in 1:dim(ctrl)[1]) {
    vs <- ctrl[i,1]
    vt <- ctrl[i,2]
    unionList <- insertRow(unionList, k, c(vs, vt))
    k <- k + 1
  }
  
  for (i in 1:dim(pznt)[1]) {
    vs_p <- pznt[i,1]
    vt_p <- pznt[i,2]
    catched <- 0
    for (j in 1:dim(ctrl)[1]) {
      vs_c <- ctrl[j,1]
      vt_c <- ctrl[j,2]
      if((vs_p==vs_c) && (vt_p==vt_c)){
        catched <- 1
        break
      }
    }
    if(catched == 0){
      unionList <- insertRow(unionList, k, c(vs_p, vt_p))
      k <- k + 1
    }
  }
  return (unionList)
  
}

# Applica la maschera al grafo
applyMask <- function(graph, mask) {
  
  # inizialize
  g <- graph
  e_list <- get.edgelist(g)
  n_edges <- dim(e_list)[1]
  m_edges <- dim(mask)[1]
  
  # remove all edges from g
  for(i in 1:n_edges){
    v1 <- e_list[i,1]
    v2 <- e_list[i,2]
    g[v1, v2] <- FALSE
  }
  
  # add weights of edges in the mask
  for(i in 1:m_edges) {
    v1 <- mask[i,1]
    v2 <- mask[i,2]
    w <- graph[v1, v2]
    if (is.finite(w)){
      if (w <= 0) {
        g[v1, v2, attr = "weight"] <- 1e-05
      }
      else{
        g[v1, v2, attr="weight"] <- w
      }
    }
    g[v1, v2, attr="inverse"] <- 1 - w
  }
  
  return(g)
}


# Applica la maschera a tutti i grafi nella directory
applyMaskDirectory <- function(pathIn, pathOut, pathMask = "./../../data/toyData/results/1_maskUnion/edgesMask.csv"){
  
  # get the mask
  mask <- read.csv(file = pathMask)
  mask <- as.matrix(mask)
  
  files <- list.files(path = pathIn) # take all files in pathIn
  for(i in 1:length(files)){ # for each file
    # take path + name and apply the mask
    cfile <- paste(pathIn, files[i], sep="")
    if(grepl(cfile, pattern = "*.gml")){
      print(cfile)
      g <- read.graph(cfile, format="gml")
      gm <- applyMask(g,mask)
      # write the output
      outfile <- paste(pathOut, files[i], sep="")
      write.graph(gm, outfile, format="gml")
    }
  }
  
}