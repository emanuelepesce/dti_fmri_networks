#' createMask
#' 
#' Run sign test on edges in order to choose which edges to select to.
#' Then create a mask.
rm(list=ls())
library(igraph)
source("./../statistics_test/mysigntest.R")

# ------------------------ Initialization --------------------------------------
pathInMatrix <- "./../../data/other/matrix_all_edges.RData"
pathIn_ex_graph <- "./../../data/graphs_integration/full_connected/Controls/CTRL_amore.graphml"

pathOut_mask <- "./../../data/other/sign_test_005/mask_sign_test.csv"

# load data
load(file = pathInMatrix)

nrows <- dim(mat)[1]
ncols <- dim(mat)[2]

l_pvalues <- vector()

tmd <- 0.01
trh <- 0.05

# ------------------------ Running ---------------------------------------------

# sign test on each row (a row of mat contains all the values of an edge for all
# subjects)
for(i in 1:nrows){
  values <- mat[i,]
  
  res <- mySIGN.test(values, md = tmd, alternative = "greater", conf.level=0.95)
  
  l_pvalues <- c(l_pvalues,res[[1]]$p.value)
}

selected_idx <- which(l_pvalues <= trh, arr.ind = T)

# read example graph in order to get a list of edges
ge <- read.graph(pathIn_ex_graph, format="graphml")
list_edges <- get.edgelist(ge)

mask <- list_edges[selected_idx,]

# save
write.table(mask,file= pathOut_mask, sep="\t", col.names = F, row.names = F)


