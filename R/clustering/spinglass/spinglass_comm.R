#' Execution and testing of spectral clust method for community detection problem
#' The test is performed on
#' - Bonferroni corrected t-test-cutted graph
#' - Shortest path + Bonferroni corrected t-test-cutted graph
#' - Shortest path + MST cutted graph
#' To evaluate the result is used a hitmap
#'
#' Author: Alessandro Merola, Emanuele Pesce

library(infotheo)
library(kernlab)
library(igraph)
library(gplots)
library(ade4)
library(RColorBrewer)

#' Perform spinglass  on all graphs in a specified directory
#' @param pathIn, input directory path
#' @param pathOut, output directory path
#' @param form, format of the graphs to read
#' @param type_weights, weights of the graph to use
#' @param verbose, if TRUE print check are enabled
#' @return  save the results in a csv file where on the first column there are
#'          the index of the vertices, on the second column there are the names
#'          of the corresponding roi regions, and after for each file the result
#'          of the clustering.
spinglass_dir <- function(pathIn, pathOut, form = "graphml", type_weights = "fmri",
                        maxSpins = 11, verbose = TRUE) {
  
  # initialization
  listNames <- c("vertices", "names")
  k <- 0
  patt = paste("*.", form, sep = "") # pattern to match
  
  # sometimes list.files don't find files :\
  repeat{
    files <- list.files(path = pathIn, pattern = patt) # take all files in pathIn
    if(!is.na(files[1])){
      break
    }
  }

  for(i in 1:length(files)) {
    cfile <- paste(pathIn, files[i], sep="")
    
    # check print
    if (verbose) {
      print ("Subject:")
      print (cfile)
    }
    
    # read the graph and turn it into a undirected graph
    g <- read.graph(cfile, format = form) 
    
    # infomap clustering
    w <- get.edge.attribute(graph = g, name = type_weights, index = E(g))
    info <- spinglass.community(graph = g, weights = w,  spins = maxSpins, 
                                     implementation = "neg")
    
    # membership
    member <- as.vector(membership(info))
    
    # append in list names
    listNames <- c(listNames, files[i])
    
    # the first time attach roi name and index vertex
    if(i <= 1) {
      names <- V(g)
      roiNames <- V(g)$roiName
      outp <- cbind(names, roiNames)
      outp <- cbind(outp, member)
    }
    # attach only the result
    else {
      outp <- cbind(outp, member)
    } 
  }
  
  # save output
  colnames(outp) <- listNames
  write.csv(outp, pathOut, row.names = F)
  
  return(outp)
}