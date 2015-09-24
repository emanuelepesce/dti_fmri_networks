#' driver_gen_borda_ws_cutting_dataset
#' 
#' Generate borda ws cutting dataset complete (controls, sla2 and sla3)
#' 
#' Author: Emanuele Pesce
ptm <- proc.time()

source("./driver_gen_borda_dataset_controls.R")
source("./driver_gen_borda_dataset_SLA2.R")
source("./driver_gen_borda_dataset_SLA3.R")

t <- proc.time() - ptm
print(t)
