#' Execution and testing of spectral clust method for community detection problem
#' The test is performed on
#' - Bonferroni corrected t-test-cutted graph
#' - Shortest path + Bonferroni corrected t-test-cutted graph
#' - Shortest path + MST cutted graph
#' To evaluate the result is used a hitmap
#'
#' Author: Alessandro Merola, Emanuele Pesce
library(cluster)
library(infotheo)
library(kernlab)
library(igraph)
library(gplots)
library(ade4)
library(RColorBrewer)

#' Exception for controlling spectal clust errors
#' @param M, input matrix of spectral clustering
tryPam <- function(M,numcenters) {
  out <- tryCatch({ 
    spc <- pam(M, numcenters)
  },
  error=function(cond){
    return(NULL)
  },
  warning=function(cond) {
  },
  finally={    
  }
  )
  return(out)
}


#' Perform spectral clustering on all graphs in a specified directory
#' @param pathIn, input directory path
#' @param pathOut, output directory path
#' @param form, format of the graphs to read
#' @param type_weights, weights of the graph to use
#' @param verbose, if TRUE print check are enabled
#' @return  save the results in a csv file where on the first column there are
#'          the index of the vertices, on the second column there are the names
#'          of the corresponding roi regions, and after for each file the result
#'          of the clustering.
specc_dir <- function(pathIn, pathOut, form = "graphml", centers = 10,
                      type_weights = "fmri",  verbose = TRUE) {
  
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
    ugm <- as.undirected(g, "collapse", edge.attr.comb = "mean")
    # get adjacency matrix and turn it into a matrix format
    MA <- get.adjacency(ugm, attr = type_weights)
    M <- as.matrix(MA)
    M <- 1 - M
    M <- as.dist(M)
    
    # append in list names
    listNames <- c(listNames, files[i])
    
    # run spectral clust
    repeat{
      res <- tryPam(M,numcenters = centers)
      if(!is.null(res)){
        break
      } 
    }
    
    res_cl <- res$clustering
    # the first time attach roi name and index vertex
    if(i <= 1) {
      names <- V(g)
      roiNames <- V(g)$roiName
      outp <- cbind(names, roiNames)
      outp <- cbind(outp, res_cl)
    }
    # attach only the result
    else {
      outp <- cbind(outp, res_cl)
    }    
  }
  
  # save output
  colnames(outp) <- listNames
  write.csv(outp, pathOut, row.names = F)
  
  return(outp)
}