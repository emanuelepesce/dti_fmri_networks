library(igraph)
pathIn <- "./../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"

g <- read.graph(pathIn, format="graphml")

w <- get.edge.attribute(g, name = "fmri", index = E(g))
r <- spinglass.community(graph = g, weights=w,  spins = 12, 
                         ,implementation = "neg")

# ugm <- as.undirected(g, "collapse", edge.attr.comb = "mean")
# # get adjacency matrix and turn it into a matrix format
# MA <- get.adjacency(ugm, attr = "fmri")
# M <- as.matrix(MA)
