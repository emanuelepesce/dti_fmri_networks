#' driver_union_ttest_mask
#' 
#' Create tt_mask to apply to graphs in order to create ttest dataset
#' Take in input three tt_masks (controls, sla2, sla3) which are the result
#' of t test on each dataset.
rm(list=ls())

# ------------------------ Initialization --------------------------------------
path_mask_c <- "./server/res_2_t005/res_controls.RData"
path_mask_s2 <- "./server/res_2_t005/res_sla2.RData"
path_mask_s3 <- "./server/res_2_t005/res_sla3.RData"

pathOut_mask <- "./../../data/other/t_test_005/mask_ttest_005.csv"
# ------------------------ Running ---------------------------------------------

# load data
load(path_mask_c)
load(path_mask_s2)
load(path_mask_s3)

# get masks
mask_c <- res_controls$selected_edges
mask_s2 <- res_sla2$selected_edges
mask_s3 <- res_sla3$selected_edges

# union
mask <- rbind(mask_c, mask_s2, mask_s3) 
mask <- unique(mask)

write.table(mask,file= pathOut_mask, sep="\t", col.names = F, row.names = F)
