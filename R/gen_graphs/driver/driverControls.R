#' driverControls
#' 
#' create and save graphs, integrating information: dti, dti_inverse, fmri, 
#' roiNames, coordinates 
#'
#' Author: Emanuele Pesce
rm(list = ls())
source("./../attachStructural.R", chdir = TRUE)
source("./../attachFunctional.R", chdir = TRUE)
source("./../attachNames.R", chdir = TRUE)
source("./../attachCoordinates.R", chdir = TRUE)

# --------------------------- Initialization ----------------------------------
# ------- paths ----------
# data
p_dtiIn <- "./../../../data/structural/naive/Controls/"
p_fmriIn <- "./../../../data/functional/naive/Controls/"

p_graphsOut <- "./../../../data/graphs_integration/full_connected/Controls/"


# names 
p_names <- "./../../../data/utils/aalLABELS.txt"
p_coords <- "./../../../data/utils/aalCOG.txt"


# ------- globals -------
m <- read.table(p_names, header=FALSE)
roiNames <- as.matrix(m)

m <- read.table(p_coords, header=FALSE)
coords <- as.matrix(m)

verbose <- "1"


# --------------------------- Definition ----------------------------------

#' Attach attributes to a graph
#' @param graph a graph in igraph format
#' @param filename the name of the file of a subject
#' @return graph a graph with several attributes
#' @examples
#' M <-  m <- genMatrix("./../../data/toyData/controls/")
attachStuff <- function(graph, filename){
  # name
  graph <- set.graph.attribute(graph, "subject", gsub(".txt", "", filename))
  
  # dti and inverse dti
  p_tmp <- paste(p_dtiIn, filename, sep = "")
  dti <- getMatrixFromFile(p_tmp)
  graph <- attachDtiToGraph(graph, dti) 
  graph <- attachDtiInverseToGraph(graph, dti)
  
  # fmri
  p_tmp <- paste(p_fmriIn, filename, sep = "")
  fmri <- getMatrixFromFile(p_tmp, sep = ",")
  graph <- attachFmriToGraph(graph, fmri)
  
  # roiNames
  graph <- attachRoiNames(graph, roiNames)
  
  # coordinates
  graph <- attachCoordinates(graph, coords)
  
  # return 
  return(graph)
}


# --------------------------- Running ----------------------------------
if(interactive()){
  ptm <- proc.time()
  
  # get all filenames
  filenames <- list.files(path = p_dtiIn, pattern = "*.txt") 
  
  # attach attributes to each file
  for(i in 1:length(filenames)){ #for each file
    
    if(verbose > 0){
      print(filenames[i])
    }
    
    # generate graph
    g <- make_full_graph(90, TRUE, TRUE)
    
    #attach attributes
    g <- attachStuff(g, filenames[i])
    
    # save
    filename_out <- gsub(".txt", ".graphml", filenames[i])
    p_out <- paste(p_graphsOut, filename_out, sep = "")
    write.graph(g, p_out, format = "graphml")
    
  }
  
  t <- proc.time() - ptm
  print(t)
}
