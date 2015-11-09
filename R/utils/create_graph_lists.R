library(igraph)
create_lists <- function(pathIn, form = "graphml", verbose = T){
  
  # pattern to match
  patt = paste("*.", form, sep = "") 
  
  # take all files in pathIn
  files <- list.files(path = pathIn, pattern = patt) 
  
  graphs <- list(length = length(files))
  
  for(i in 1:length(files)) {
    
    cfile <- paste(pathIn, files[i], sep="")
    
    # check print
    if (verbose) {
      print ("Subject:")
      print (cfile)
    }
    
    # read the graph 
    g <- read.graph(cfile, format = form) 
    graphs[[i]] <- g
  } # end for i
  
  return(graphs)
}# end function
