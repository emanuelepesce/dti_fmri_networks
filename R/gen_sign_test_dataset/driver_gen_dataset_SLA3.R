#' driver_gen_dataset_SLA3
#' 
#' Generate sign test sla3 dataset
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./../utils/apply_mask.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathIn_Controls <- "./../../data/graphs_integration/full_connected/SLA3/"

pathIn_mask <- "./../../data/other/sign_test_005/mask_sign_test.csv"

pathOut <- "./../../data/graphs_integration/sign_test/SLA3/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

gen_graphs(pathIn_Controls, pathOut, pathIn_mask)

t <- proc.time() - ptm
print(t)