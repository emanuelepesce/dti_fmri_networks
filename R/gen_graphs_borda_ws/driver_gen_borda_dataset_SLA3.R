#' driver_gen_borda_ws_cutting_dataset
#' 
#' Generate borda ws cutting dataset
#' 
#' Author: Emanuele Pesce
rm(list = ls())
source("./apply_mask_borda.R", chdir = T)

# -------------------------- Inititialization ----------------------------------
verbose = 1
if(verbose > 0){
  print("Initialization..")
}

pathIn_Controls <- "./../../data/graphs_integration/full_connected/SLA3/"

pathIn_mask <- "./../../data/other/borda/threshold_0dot04/borda_mask_ws_cutting_num.csv"

pathOut <- "./../../data/graphs_integration/borda_sw_004/SLA3/"

# -------------------------- Running -------------------------------------------
ptm <- proc.time()

if(verbose > 0){
  print("Running..")
}

gen_graphs_borda_sw(pathIn_Controls, pathOut, pathIn_mask)

t <- proc.time() - ptm
print(t)