#' createMask
#' 
#' Run a t test on edges in order to choose which edges to select to.
#' Then create a mask.
rm(list=ls())
library(igraph)
source("./../statistics_test/ttest.R")

# ------------------------ Initialization --------------------------------------
pathInMatrix <- "./../../data/other/matrix_all_edges.RData"
pathIn_ex_graph <- "./../../data/graphs_integration/full_connected/Controls/CTRL_amore.graphml"

pathOut_mask <- "./../../data/other/t_test/mask_t_test.csv"

# load data
load(file = pathInMatrix)

nrows <- dim(mat)[1]
ncols <- dim(mat)[2]

l_pvalues <- vector()

tmu <- 1e-05
trh <- 0.01

# ------------------------ Running ---------------------------------------------

# sign test on each row (a row of mat contains all the values of an edge for all
# subjects)
for(i in 1:nrows){
  values <- mat[i,]
  tt <-  t.test(values, mu = tmu)
  l_pvalues <- c(l_pvalues, tt$p.value)
}

adj <- p.adjust(l_pvalues, "bonferroni")
selected_idx <- which(adj <= trh, arr.ind = T)

# read example graph in order to get a list of edges
ge <- read.graph(pathIn_ex_graph, format="graphml")
list_edges <- get.edgelist(ge)

mask <- list_edges[selected_idx,]

# save
write.table(mask,file= pathOut_mask, sep="\t", col.names = F, row.names = F)


