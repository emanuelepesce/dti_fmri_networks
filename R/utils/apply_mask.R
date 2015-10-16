#' apply_mask
#' 
#' Function for applying a mask to graphs
#' 
#' Author: Emanuele Pesce
library(igraph)
source("./../utils/graphUtils.R", chdir = T)

#' Apply a mask to a graph
#' @param graph graph 
#' @param mask containing which edges save in the graph. All other will be removed.
#'        Note: the mask has to be passed in a format matrix.
#' @return graph a graph where there are only edges of the mask    
#' @examples
#'  g <- read.graph("./../../data/graphs_integration/full_connected/Controls/CTRL_amore.graphml", format="graphml")
#'  mask <- read.csv(file = "./../../data/other/borda/borda_mask_ws_cutting_num.csv", sep = "\t")
#'  mask <- as.matrix(mask)
#   gm <- apply_mask(g,mask)
apply_mask <-function(graph, mask){
  mask_dim <- dim(mask)[1]
  
  # apply the mask: remove edges which are not in the mask
  # idea: mask all edges to keep and then remove not marked edges
  
  # create attribute
  graph <- set.edge.attribute(graph, "toKeep", index = E(graph), 0)
  
  # mark edges to keep
  for(i in 1:mask_dim){
    v_s <- mask[i,1]
    v_t <- mask[i,2]
    graph[v_s, v_t, attr="toKeep"] <- 1
  }
  
  # remove edges not marked
  for(i in ecount(graph):1){
    if(get.edge.attribute(graph, "toKeep", i) == 0){
      graph <- delete.edges(graph, i)
    } 
  }
  
  # remove attribute
  graph <- remove.edge.attribute(graph, "toKeep")
  
  # return
  return(graph)
}

#' Apply the mask to all graphs in pathIn and write the output in pathOut.
#' @param pathIn, path of the directory which cointains the input graph files
#' @param pathOut, path of the directory in which the output graphs will be 
#'                 written
#' @param pathMask pathMask, path of the mask to apply
#' @param form, format of the graph to manage
gen_graphs <- function(pathIn, pathOut, pathMask, form = "graphml",
                                header = F){
  # get the mask
  mask <- read.csv(file = pathMask, sep = "\t", header=header)
  mask <- as.matrix(mask)
  
  # take all files in pathIn which have the right format
  patt <- paste("*.", form, sep = "")
  files <- list.files(path = pathIn, pattern = patt) 
  
  for(i in 1:length(files)){ #for each file
    
    # read the graph and apply the mask
    p_file <- paste(pathIn, files[i], sep = "")
    print(p_file)
    g <- read.graph(p_file, format = form)
    gm <- apply_mask(g,mask)
    
    # write the output
    outfile <- paste(pathOut, files[i], sep = "")
    write.graph(gm, outfile, format = form)
  }
}