library(igraph)

#' Get a list' t of strong edges
#' A strong edge is an adges which is in the set of minimum spanning tree
#' @param Res: result of "pruning edges" function
#' @return l_edges: list of strong edges
#' @examples
#' RC <- sw_cutting(g, threshold = 0.05, flow = 0)
#' controlsLabels <- getLabels(RC)
getLabels <- function(Res){
  # get strong edges 
  g <- Res$v_strong
  l_edges = matrix(nrow = Res$n_strong, ncol = 2)
  
  # create list of utils edges
  k = 1
  for( i in 1:length(g)){
    if (length(g[[i]]) > 1){
      for (j in 2:length(g[[i]])){ #first element is i    
#         l_edges[k, 1] <- paste("V",toString(i), sep = "")
#         l_edges[k, 2] <- paste("V",toString(g[[i]][j]), sep = "")
        l_edges[k, 1] <- i 
        l_edges[k, 2] <- g[[i]][j]
        k = k + 1
      }
    }
  }
  
  return(l_edges)
}

#' Attach labels ("strong" label) to a graph
#' @param g graph (igraph)
#' @param labels matrix of labels
#' @param set TRUE: labels needs to be inizialed. Use this the first time is called
#' @return g graph with strong label
#' @examples
#' g <- read.graph(file = "./../../data/toyData/cutted_controls/CTRL_amore.gml", format="gml")
#' gl <- attachLabels(g, controlsLabels, set = TRUE) 
attachLabels <- function(g, labels, set = FALSE){
  # set strong to 0
  if(set == TRUE){
    g <- set.edge.attribute(g, name="strong", index=E(g), value = 0)
  }
  
  # attach labels strong = 1 if an edge is in a labels
  for(i in 1:dim(labels)[1]){
    v1 <- labels[i,1]
    v2 <- labels[i,2]
    g[v1, v2, attr="strong"] <- 1
  }
  
  return(g)
}

#' Apply labels at all file in pathIn
#' @param pathIn path where there are graphs which needs to be applied labels
#' @param pathOut path where graph awill be saved after label attachment
#' @param label1 set of label Controls
#' @param label2 set of label SLA2
#' @param label3 set of label SLA3
applyAttachLabel <- function(pathIn, pathOut, label1, label2, label3, form= "graphml"){
    
  files <- list.files(path = pathIn) #take all files in pathIn
  for(i in 1:length(files)){ #for each file
    # take path + name and apply the mask
    cfile <- paste(pathIn, files[i], sep="")
    patt <- paste("*.", form, "", sep = "")
    if(grepl(cfile, pattern = patt)){
      print(cfile)
      g <- read.graph(cfile, format=form)
      g <- attachLabels(g, label1, set = TRUE)
      g <- attachLabels(g, label2, set = FALSE)
      g <- attachLabels(g, label3, set = FALSE)
      # write the output
      outfile <- paste(pathOut, files[i], sep="")
      write.graph(g, outfile, format=form)
    }
  }
}