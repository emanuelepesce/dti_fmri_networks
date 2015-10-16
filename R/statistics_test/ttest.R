rm(list=ls())

load(file = "matrix.RData")

nrows <- dim(mat)[1]
ncols <- dim(mat)[2]

l_pvalues <- vector()

tmu <- 0
trh <- 0.1

for(i in 1:nrows){
  values <- mat[i,]
  tt <-  t.test(values, mu = tmu)
  l_pvalues <- c(l_pvalues, tt$p.value)
}

adj <- p.adjust(l_pvalues, "bonferroni")

num_selected <- which(adj <= trh, arr.ind = T)
num_selected