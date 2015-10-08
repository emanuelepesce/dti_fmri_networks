#' driver_gen_borda_ws_cutting_dataset
#' 
#' Generate borda ws cutting dataset
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./apply_mask_ttest.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathIn_Controls <- "./../../data/graphs_integration/full_connected/Controls/"

pathIn_mask <- "./../../data/other/t_test_005/mask_ttest_cutted.csv"

pathOut <- "./../../data/graphs_integration/ttest_005/Controls/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

gen_graphs_borda_sw(pathIn_Controls, pathOut, pathIn_mask)

t <- proc.time() - ptm
print(t)