rm(list = ls())
source("./../../utils/graphUtils.R", chdir = T)
source("./thresholds_vertices.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathBordaControls <- "./../../../data/other/borda/borda_matrix_controls.txt"
pathBordaSLA2 <- "./../../../data/other/borda/borda_matrix_SLA2.txt"
pathBordaSLA3 <- "./../../../data/other/borda/borda_matrix_SLA3.txt"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

g <- i_adjacencyFromFile(pathBordaControls)
tr_controls <- thresholds_vertices(g)

g <- i_adjacencyFromFile(pathBordaSLA2)
tr_sla2 <- thresholds_vertices(g)

g <- i_adjacencyFromFile(pathBordaSLA3)
tr_sla3 <- thresholds_vertices(g)

yrange = c(0,40)
x_lab <- "Thresholds vertices values"

png('histograms.png', width=600, height=600)
par(mfrow=c(2,2))
hist(tr_controls, ylim = yrange, main = "Mask Controls", xlab = x_lab )
lines(density(tr_controls, adjust = 2))
hist(tr_sla2, ylim = yrange,  main = "Mask Sla2", xlab = x_lab )
lines(density(tr_sla2, adjust = 2))
hist(tr_sla3, ylim = yrange,  main = "Mask Sla3", xlab = x_lab )
lines(density(tr_sla3, adjust = 2))
dev.off()

save.image("workspace.RData")
t <- proc.time() - ptm
print(t)