#' Unify masks obtained with t test
#' Idea: if an edges is present in two masks on three keep it

rm(list=ls())
library(miscTools)

# ------------------------ Load ------------------------------------------------
load("./server/res_1/res_controls.RData")
load("./server/res_1/res_sla2.RData")
load("./server/res_1/res_sla3.RData")


edges_c <- res_controls$selected_edges
edges_s2 <- res_sla2$selected_edges
edges_s3 <- res_sla3$selected_edges



# ------------------------ Load ------------------------------------------------
list_consensus <- matrix(nrow = 0, ncol = 2)
kc <- 1

for(i in 1:dim(edges_s2)[1]){
  consensus = 1
  edge <- edges_s2[i,]
  e1 <- edge[1]
  e2 <- edge[2]
  
  # check consensus
  for(j in 1:dim(edges_c)[1]){
    if ((edges_c[j,1] == e1) && (edges_c[j,2] == e2)){
      consensus = consensus + 1
    }
  }

  for(j in 1:dim(edges_s3)[1]){
    if ((edges_s3[j,1] == e1) && (edges_s3[j,2] == e2)){
      consensus = consensus + 1
    }
  }

  if (consensus >= 2 ){
    list_consensus <- insertRow(list_consensus, kc, c(edge[1], edge[2]))
    kc = kc + 1
  }
  
}
