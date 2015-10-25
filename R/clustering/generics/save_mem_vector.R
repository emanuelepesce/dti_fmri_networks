source("./make_heatmap.R")
source("./coOccurence.R")

k = 10

# save the final clustering membership vector in a csv file

pathIn_mem_C <- "./../../../data/results/spec_clust/10/borda_sw_004/membership_controls.csv"
pathIn_mem_S2 <- "./../../../data/results/spec_clust/10/borda_sw_004/membership_sla2.csv"
pathIn_mem_S3 <- "./../../../data/results/spec_clust/10/borda_sw_004/membership_sla3.csv"


pathOut <- "./membership.csv"

mC <- read.csv(pathIn_mem_C)
mC <- mC[, -1:-2]

mS2 <- read.csv(pathIn_mem_S2)
mS2 <- mS2[, -1:-2]

mS3 <- read.csv(pathIn_mem_S3)
mS3 <- mS3[, -1:-2]

m <- as.matrix(mS3) 
class(m) <- "numeric"

# calculate coOccurence matrix
coOc_m <- coOccurrence(m)

# heatmap
dm <- dist(coOc_m)
hc <- hclust(dm)
hcc <- cutree(hc, k = k)
hcc <- as.vector(hcc)

write.table(hcc, pathOut, row.names = F, col.names = F)

