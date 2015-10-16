rm(list=ls())
source("./mysigntest.R")

# load data
load(file = "matrix.RData")

nrows <- dim(mat)[1]
ncols <- dim(mat)[2]

l_pvalues <- vector()

tmd <- 0.01
trh <- 0.05

# sign test on each row (a row of mat contains all the values of an edge for all
# subjects)
for(i in 1:nrows){
  values <- mat[i,]

  res <- mySIGN.test(values, md = tmd, alternative = "greater", conf.level=0.95)
  
  l_pvalues <- c(l_pvalues,res[[1]]$p.value)
}

# adj <- p.adjust(l_pvalues, "bonferroni")

num_selected <- which(l_pvalues <= trh, arr.ind = T)
num_selected
