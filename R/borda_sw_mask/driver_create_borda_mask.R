#' borda_extracting_mask
#' 
#' Generate borda mask.
#' After we have taken the result of borda voting, and after we have done the
#' cutting with S/W ties, we have to aggregate the result, doing the union the 
#' masks.
#'
#' Applying this mask it could be generate borda_ws_cutting dataset.
#' 
#' Furthermore rusult objects of SW cutting procedure are saved in order to be
#' recovered lately (for attaching label for example).
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./borda_extracting_mask.R", chdir = T)
source("./../strong_weak_ties_cutting/sw_cutting.R", chdir = T)
source("./../utils/graphUtils.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathBordaControls <- "./../../data/other/borda/borda_matrix_controls.txt"
pathBordaSLA2 <- "./../../data/other/borda/borda_matrix_SLA2.txt"
pathBordaSLA3 <- "./../../data/other/borda/borda_matrix_SLA3.txt"

pathMask_borda_ws_cutting <- "./../../data/other/borda/borda_mask_ws_cutting.csv"
pathMask_borda_ws_cutting_info <- "./../../data/other/borda/borda_mask_ws_cutting_info.csv"

path_results_cutting <- "./../../data/other/borda/borda_sw_cut_objects.RData"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}
# import graphs
g_Controls <- i_adjacencyFromFile(pathBordaControls)
g_SLA2 <- i_adjacencyFromFile(pathBordaSLA2)
g_SLA3 <- i_adjacencyFromFile(pathBordaSLA3)

# compute residuals
r_Controls <- sw_cutting(g_Controls, threshold = 0.05, flow = 0)
if(verbose > 0){
  print("r_Controls complete")
}
r_SLA2 <- sw_cutting(g_SLA2, threshold = 0.05, flow = 0)
if(verbose > 0){
  print("r_Controls complete")
}
r_SLA3 <- sw_cutting(g_SLA3, threshold = 0.05, flow = 0)
if(verbose > 0){
  print("r_Controls complete")
}

# save 
save(r_Controls, r_SLA2, r_SLA3, file = path_results_cutting)

residual_Controls <- r_Controls$residualGraph
residual_SLA2 <- r_SLA2$residualGraph
residual_SLA3 <- r_SLA3$residualGraph

# union masks: first compute all masks, then do the union
# computer all masks
mask1 <- unionMask(residual_Controls, residual_SLA2)
mask2 <- unionMask(residual_Controls, residual_SLA3)
# union
maskU <- rbind(mask1, mask2)
maskU <- unique(maskU)

print("Edges in Controls")
print(r_Controls$n_residualEdges)
print("Edges in SLA2")
print(r_SLA2$n_residualEdges)
print("Edges in SLA3")
print(r_SLA3$n_residualEdges)
print("Edges in Union")
print(dim(maskU)[1])
print("Union - Controls")
print(r1 <- dim(maskU)[1] - r_Controls$n_residualEdges)
print("Union - SLA2")
print(r2 <- dim(maskU)[1] - r_SLA2$n_residualEdges)
print("Union - SLA3")
print(r3 <- dim(maskU)[1] - r_SLA3$n_residualEdges)


# saving
out <- list("e_controls" = r_Controls$n_residualEdges, "e_SLA2" = r_SLA2$n_residualEdges, 
            "e_SLA3" = r_SLA3$n_residualEdges, "e_union" = dim(maskU)[1], "e_union_m_controls" = r1,
            "e_union_m_SLA2" = r2, "e_union_m_SLA3" = r3 )
write.csv(out, file = pathMask_borda_ws_cutting_info)
write.table(maskU,file= pathMask_borda_ws_cutting, sep="\t", col.names = F, row.names = F)

save.image(file = "driver_create_borda_mask.RData")

time  <- proc.time() - ptm
print(time)