#' driver_gen_dataset_SLA2
#' 
#' Generate t test sla2 dataset
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./../utils/apply_mask.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathIn_Controls <- "./../../data/graphs_integration/full_connected/SLA2/"

pathIn_mask <- "./../../data/other/t_test/mask_t_test.csv"

pathOut <- "./../../data/graphs_integration/t_test/SLA2/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

gen_graphs(pathIn_Controls, pathOut, pathIn_mask)

t <- proc.time() - ptm
print(t)