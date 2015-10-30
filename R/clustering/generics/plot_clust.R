library(igraph)

#' Compute result of clustering from a cooccurence matrix
#' First calculate membership matrix from a cooccurence matrix and then save
#' results
#' @param m: cooccurence matrix
#' @param k: number of clusters
#' @param graph: a graph in igraph format
#' @param pathOut2d: path where to save the output in 2d
#' @param pathOut3d: path where to save the output in 3d
#' @param verbose: if TRUE print information for testing
#' @param saveMembership: if TRUE save the membership vector 
#' @param pathOutMem: path where to save memebership vector
plot_clust <- function(m, k = 10, graph, pathOut2d, pathOut3d, verbose = FALSE, 
                       pathOutMem, saveMembership = T) {
  
  # get coordinates
  x <- V(g)$cx
  y <- V(g)$cy
  z <- V(g)$cz
  coords <- cbind(x,y,z)
  
  # rotation
  angle <- pi/2
  M <- matrix( c(cos(angle), -sin(angle), sin(angle), cos(angle)), 2, 2 )
  
  # clustering
  dm <- dist(m)
  hc <- hclust(dm)
  hcc <- cutree(hc, k = k)
  hcc <- as.vector(hcc)
  
  if(saveMembership == T){
    write.table(hcc, pathOutMem, row.names = F, col.names = F)
  }
  
  # colors 
  cl <- brewer.pal(k,name = "RdYlBu")
  hccc <- hcc
  for(i in 1:k){
    hccc <- replace(hccc, hccc == i, cl[i])
  }
  hcc <- hccc
  
  # 2d projection plot
  jpeg(filename = pathOut2d, width = 1000, height = 1000)
  plot(g, vertex.color = hcc, vertex.size = 10, edge.arrow.mode = 0, layout = coords[,-3])
  dev.off()
  
  # 3d projection plot
  jpeg(pathOut3d, width = 1000, height = 1000)
  par(mfrow=c(2,2))
  plot.igraph(g, vertex.color = hcc, edge.arrow.mode = 0, layout=coords[,-3])
  plot.igraph(g, vertex.color = hcc, edge.arrow.mode = 0, layout=coords[,-2])
  zy <- cbind(coords[,3],coords[,2])
  plot.igraph(g, vertex.color = hcc, edge.arrow.mode = 0, layout=zy%*%M)
  pie(rep(1,k), col=cl, main = "Colors")
  dev.off()
  
  # return 
  return(hcc)
}