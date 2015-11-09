library(igraph)
library(RColorBrewer)
library(ggplot2)
library(scales)


plot_times <- function(ex.graph, v.weights, seed, v.size = 10, edges.info,
                       main = "Region 1"){
  
  # get coordinates
  x <- V(g)$cx
  y <- V(g)$cy
  z <- V(g)$cz
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
  
  # 2d projection plot
#   jpeg(filename = pathOut2d, width = 1000, height = 1000)
#   plot(g, vertex.color = hcc, vertex.size = 10, edge.arrow.mode = 0, layout = coords[,-3])
#   dev.off()
  
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

## examples
p.g <- "./../../data/results/borda_example_graph.graphml"
g <- read.graph(p.g, format= "graphml")
p.data <- "./../../data/results/propagation/random_walk/borda/fmri/analysis_prop_1.RData"
load(p.data)
v.times <- rescale(analysis.prop$time.regions$Controls)
seed <- 1

edges.s <- analysis.prop$freq.topK.id[[1]]$Area_From
edges.t <- analysis.prop$freq.topK.id[[1]]$Area_To
val <- analysis.prop$freq.topK.id[[1]]$Value
edges <- cbind(edges.s, edges.t, val)

plot_times(g, v.times, seed, 10, edges.info = edges,"Controls Fmri")
