library(igraph)
# path <- "./../../../data/graphs_integration/t_test/Controls/CTRL_amore.graphml"
# g <- read.graph(path, format = "graphml")
# 
# w  <- abs(E(g)$fmri)
# 
# g <- set.vertex.attribute(g, name = "n_att", index = E(g), value = w)
# ug <- as.undirected(g, mode = "collapse", edge.attr.comb = list(n_att="mean", "ignore"))
# 
# r_tmp <- rand_walk_weighted(ug, w, 1)

check_conn_dir <- function(pathIn.dir){
  graphs.file <- list.files(pathIn.dir, patt = "*.graphml")
  for(i in 1:length(graphs.file)){
    g <- read.graph(paste(pathIn.dir,graphs.file[i], sep=""), format = "graphml")
    w  <- abs(E(g)$fmri)
    
    g <- set.vertex.attribute(g, name = "n_att", index = E(g), value = w)
    ug <- as.undirected(g, mode = "collapse", edge.attr.comb = list(n_att="mean", "ignore"))
    
    print(is.connected(ug, "strong"))
  }
}

check_conn_dir("./../../../data/graphs_integration/t_test/SLA3/")
