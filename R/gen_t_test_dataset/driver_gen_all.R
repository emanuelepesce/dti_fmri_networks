#' driver_gen_all
#' 
#' Generate sign test dataset
#' 
#' Author: Emanuele Pesce
ptm <- proc.time()

source("./driver_gen_dataset_controls.R")
source("./driver_gen_dataset_SLA2.R")
source("./driver_gen_dataset_SLA3.R")

t <- proc.time() - ptm
print(t)
