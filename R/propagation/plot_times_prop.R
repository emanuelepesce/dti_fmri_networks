rm(list=ls())
library(igraph)
library(RColorBrewer)
library(ggplot2)
library(scales)


plot_times <- function(ex.graph, v.weights, seed, v.size = 10, edges.info,
                       main = "Region 1", toSave = F, pathOut = ""){
  
  # get coordinates
  x <- V(ex.graph)$cx
  y <- V(ex.graph)$cy
  z <- V(ex.graph)$cz
  coords <- cbind(x,y,z)
  
  # colors
  nc <- 5
  colfunc <-colorRampPalette(c("red","yellow","springgreen","royalblue"))
  v.colors <- colfunc(nc)[as.numeric(cut(v.weights,breaks = nc))]
  
  # shapes
  shapes <- rep("circle", 90)
  shapes[seed] <- "square"
  
  # regions
  regions <- data.frame(V(ex.graph)$roiName)
  
  if(edges.info[1] == FALSE){
    edges.size <- 1
    edges.color <- "grey"

  }
  else{
    edges.size <- rep(0, ecount(ex.graph))
    val <- rescale(edges.info[,3], to = c(1, 15))
    for(i in 1:length(val)){
      edges.info
      id <- get.edge.ids(ex.graph, c(edges.info[i,1], edges.info[i,2]))
      edges.size[id] = val[i]
      edges.color = "black"
    }
  }
  
  if(toSave){
    jpeg(filename = pathOut, width = 1000, height = 1000)
    
    layout(matrix(1:2,ncol=2), width = c(2,1), height = c(1,1))
    
    plot(ex.graph, vertex.color = v.colors, vertex.size = v.size,
         edge.arrow.mode = 0, 
         layout = coords[,-3], vertex.shape = shapes, main = main,
         edge.width=edges.size, edge.color = edges.color)
    
    legend_image <- as.raster(matrix(colfunc(nc), ncol=1))
    ss <- seq(min(v.weights),max(v.weights),l=5)
    plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main = 'Time')
    text(x=1.5, y = ss, labels = ss)
    rasterImage(rev(legend_image), 0, 0, 1,1)
    
    dev.off()
  }  
  else{
    layout(matrix(1:2,ncol=2), width = c(2,1), height = c(1,1))
    
    plot(ex.graph, vertex.color = v.colors, vertex.size = v.size,
         edge.arrow.mode = 0, 
         layout = coords[,-3], vertex.shape = shapes, main = main,
         edge.width=edges.size, edge.color = edges.color)
    
    legend_image <- as.raster(matrix(colfunc(nc), ncol=1))
    ss <- seq(min(v.weights),max(v.weights),l=5)
    plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main = 'Time')
    text(x=1.5, y = ss, labels = ss)
    rasterImage(rev(legend_image), 0, 0, 1,1)
  }

}

save_plot <- function(data.obj, ex.graph, seed, pathOut){
  
  for(group in 1:3){
    v.times <- rescale(analysis.prop$time.regions[[group+1]])
    
    if(group == 2){
      group.name = "Controls"
    }
    if(group == 3){
      group.name = "Sla2"
    }
    if(group == 4){
      group.name = "Sla3"
    }
    pathOut.jpeg <- paste(pathOut, group.name, ".jpeg", sep = "")
    plot_times(ex.graph, v.times, seed, 10, edges.info = FALSE, group.name, 
               toSave = T, pathOut = pathOut.jpeg)
  }
}


path.graph.ex <- "./../../data/results/borda_example_graph.graphml"
seeds <- c(1,2,67,68)
type_edge <- "fmri_times_dti"

ex.graph <- read.graph(path.graph.ex, format = "graphml")
pathOut.base <- paste("./../../data/results/propagation/random_walk/borda/",
                      type_edge, "/analysis/", sep = "")
for(seed in seeds){
  path.data <- paste(pathOut.base, "analysis_prop_r", seed, ".RData",
                     sep = "")
  pathOut.seed <- paste(pathOut.base, seed, "/", sep = "")
  load(path.data) # analysis.prop
  save_plot(analysis.prop, ex.graph, seed, pathOut.seed) 
}




## examples
# p.g <- "./../../data/results/borda_example_graph.graphml"
# 
# g <- read.graph(p.g, format= "graphml")
# p.data <- "./../../data/results/propagation/random_walk/borda/fmri/analysis/analysis_prop_r68.RData"
# load(p.data)
# v.times <- rescale(analysis.prop$time.regions$Controls)
# seed <- 1
# 
# edges.s <- analysis.prop$freq.topK.id[[1]]$Area_From
# edges.t <- analysis.prop$freq.topK.id[[1]]$Area_To
# val <- analysis.prop$freq.topK.id[[1]]$Value
# edges <- cbind(edges.s, edges.t, val)
# 
# plot_times(g, v.times, seed, 10, edges.info = FALSE,"Controls Fmri")
