rm(list=ls())

load(file = "matrix.RData")

nrows <- dim(mat)[1]
ncols <- dim(mat)[2]

l_pvalues <- vector()

c1 <- rep("ctrl", 15)
c2 <- rep("sla2", 29)
c3 <- rep("sla3", 10)
cl <- c(c1,c2,c3)

tmu <- 0
trh <- 0.05

for(i in 1:nrows){
  values <- mat[i,]
  
  df <- data.frame(values, cl)
  colnames(df) <- c("values", "class")
  
  an <- lm(values ~ class, data=df)
  res <- anova(an)
  
  l_pvalues <- c(l_pvalues, res$Pr[1])
}

adj <- p.adjust(l_pvalues, "BH")

num_selected <- which(l_pvalues <= trh, arr.ind = T)
num_selected

num_selected <- which(adj <= trh, arr.ind = T)
num_selected

