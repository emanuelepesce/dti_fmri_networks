#' driver_gen_dataset_controls
#' 
#' Generate sign test controls dataset
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./../utils/apply_mask.R", chdir = T)
# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathIn_Controls <- "./../../data/graphs_integration/full_connected/Controls/"

pathIn_mask <- "./../../data/other/sign_test_005/mask_sign_test.csv"

pathOut <- "./../../data/graphs_integration/sign_test/Controls/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

gen_graphs(pathIn_Controls, pathOut, pathIn_mask)

t <- proc.time() - ptm
print(t)