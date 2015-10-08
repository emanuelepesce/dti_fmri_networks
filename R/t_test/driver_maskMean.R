#' driver_maskMean
#' 
#' Given a mask, calculate the mean of all edges of the mask.
#' It's important because then it will be applied sw cutting which needs 
#' dti weights on edges
rm(list=ls())
source("./maskMean.R") #union mask function
source("./../strong_weak_ties_cutting/sw_cutting.R")
source("./../utils/graphUtils.R")
source("./../exp_threshold_borda_dataset/threshold_masks/thresholds_vertices.R", chdir = T)
# ------------------------ Initialization --------------------------------------
pathInC <- "./../../data/graphs_integration/full_connected/Controls/"
pathInS2 <- "./../../data/graphs_integration/full_connected/Controls/"
pathInS3 <- "./../../data/graphs_integration/full_connected/Controls/"

pathInMask <- "./../../data/other/t_test_005/mask_ttest_005.csv"

pathOut <- "./../../data/other/t_test_005/"
pathOutMask <- paste(pathOut, "weighted_mask.csv", sep="")
pathOut_graphToCut <- paste(pathOut, "graph_to-cut.graphml", sep = "")
pathOut_residualGraph <- paste(pathOut, "residualGraph_cutted.graphml", sep="") 
pathOut_mask_ttest <- paste(pathOut, "mask_ttest_cutted.csv", sep ="") 
pathOut_mask_ttest_num <- paste(pathOut, "mask_ttest_cutted.csv", sep ="") 
pathOut_sw_cut_obj <- paste(pathOut, "t_test_sw_cut_objects.RData", sep = "")

# ------------------------ Running ---------------------------------------------

# add weights to a mask
res <- maskMean(pathInC, pathInS2, pathInS3, pathInMask)
mask <- cbind(res$mask, res$edges_mean)
write.table(mask,file= pathOutMask, sep="\t", col.names = F, row.names = F)

# mask <- read.table(file = pathOutMask, header=T, sep="\t")
# mask <- as.matrix(mask)

# convert mask in graph object
# g_example <- read.graph("./../../data/graphs_integration/full_connected/Controls/CTRL_amore.graphml",
#                         format="graphml")
g_example <- read.graph("./example.gml", format="gml") # example graph for creating object to cut 
gToCut <- createGraphMask(g_example, mask)
write.graph(graph = gToCut, file = pathOut_graphToCut, format = "graphml")

# gToCut <- read.graph(pathOut_graphToCut, format="graphml")

# cut 0.05
RC <- sw_cutting(gToCut, threshold = 0.04, invert = F)
save(RC, file = pathOut_sw_cut_obj)
write.graph(graph = RC$residualGraph, file = pathOut_residualGraph, format = "graphml")
write.csv(as.matrix(get.edgelist(RC$residualGraph)),
            file = pathOut_mask_ttest ,row.names = F)

char_mask <- as.matrix(get.edgelist(RC$residualGraph))
# create a numeric mask (without "V" in cells)
new_mask <- matrix(nrow = dim(char_mask)[1], ncol = 2)
for(i in 1:dim(char_mask)[1]){
  tmp <- gsub("V","", char_mask[i, 1])
  new_mask[i,1] <- as.integer(tmp)
  tmp <- gsub("V","", char_mask[i, 2])
  new_mask[i,2] <- as.integer(tmp)
}
write.table(new_mask,file= pathOut_mask_ttest_num, sep="\t", col.names = F, row.names = F)

