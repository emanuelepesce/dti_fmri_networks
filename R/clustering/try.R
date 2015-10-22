library(igraph)
library(fpc)
library(cluster)
library(MCL)
library(apcluster)
# pathIn <- "./../../../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"
pathIn <- "./../../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"


g <- read.graph(pathIn, format="graphml")

w <- get.edge.attribute(g, name = "fmri", index = E(g))
r <- spinglass.community(graph = g, weights=w,  spins = 12, 
                         ,implementation = "neg")

ugm <- as.undirected(g, "collapse", edge.attr.comb = "mean")
uw <- get.edge.attribute(ugm, name = "fmri", index = E(ugm))
# get adjacency matrix and turn it into a matrix format
MA <- get.adjacency(ugm, attr = "fmri")
M <- as.matrix(MA)
MR <- 1 - M
dist <- as.dist(MR)

# dens<-dbscan(dist,eps=0.1, method="dist")

# label.propagation.community(graph = g, weights = 1-w)


p <- pam(dist, k = 10)

r <- apclusterK(MR, K = 10)

mem <- vector(mode = "numeric", length= 90)
cl <- r@clusters
for(i in 1:length(cl)){
  cl_tmp <- cl[[i]]
  for(j in 1:length(cl_tmp)){
    mem[cl_tmp[j]] <- i
  }
}

capture.output(r3 <- apclusterK(MR, K = 10, maxits = 10000, convits = 10000) , file='NUL')

fastgreedy.community(ugm, weights = 1-uw)
leading.eigenvector.community(ugm, weights = 1-uw)

f <- fanny(dist, k = 10, diss = T, memb.exp = 1.1)
f$clustering

