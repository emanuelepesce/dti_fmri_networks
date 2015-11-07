rm(list = ls())
require(compiler)
enableJIT(0)
source("./rw_propagation.R", chdir = T)

# ================================ Globals  ====================================
pathIn.ctrl <- "./../../../data/graphs_integration/borda_sw_004/igraphs_controls.RData"
pathIn.sla2 <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA2.RData"
pathIn.sla3 <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA3.RData"


# ================================ Region 1  ===================================
times <- 50
seed <- 1
maxiter <- 4000
nc <- 3

pathOutC <- "prop_ctrl_dti_r1.RData"
pathOutS2 <- "prop_sla2_dti_r1.RData"
pathOutS3 <- "prop_sla3_dti_r1.RData"

time.start <- proc.time()

cl <- makeCluster(nc)
driver_exp(cl, seed, times, maxiter, pathIn.ctrl, "c", pathOutC)
driver_exp(cl, seed, times, maxiter, pathIn.sla2, "s2", pathOutS2)
driver_exp(cl, seed, times, maxiter, pathIn.sla3, "s3", pathOutS3)
stopCluster(cl)


time.used <- proc.time() - time.start
time.used


# ================================ Region 2  ===================================
times <- 50
seed <- 2
maxiter <- 4000
nc <- 3

pathOutC <- "prop_ctrl_dti_r2.RData"
pathOutS2 <- "prop_sla2_dti_r2.RData"
pathOutS3 <- "prop_sla3_dti_r2.RData"

time.start <- proc.time()

cl <- makeCluster(nc)
driver_exp(cl, seed, times, maxiter, pathIn.ctrl, "c", pathOutC)
driver_exp(cl, seed, times, maxiter, pathIn.sla2, "s2", pathOutS2)
driver_exp(cl, seed, times, maxiter, pathIn.sla3, "s3", pathOutS3)
stopCluster(cl)


time.used <- proc.time() - time.start
time.used


# ================================ Region 67  ==================================
times <- 50
seed <- 67
maxiter <- 4000
nc <- 3

pathOutC <- "prop_ctrl_dti_r67.RData"
pathOutS2 <- "prop_sla2_dti_r67.RData"
pathOutS3 <- "prop_sla3_dti_r67.RData"

time.start <- proc.time()

cl <- makeCluster(nc)
driver_exp(cl, seed, times, maxiter, pathIn.ctrl, "c", pathOutC)
driver_exp(cl, seed, times, maxiter, pathIn.sla2, "s2", pathOutS2)
driver_exp(cl, seed, times, maxiter, pathIn.sla3, "s3", pathOutS3)
stopCluster(cl)


time.used <- proc.time() - time.start
time.used


# ================================ Region 68  ==================================
times <- 50
seed <- 68
maxiter <- 4000
nc <- 3

pathOutC <- "prop_ctrl_dti_r68.RData"
pathOutS2 <- "prop_sla2_dti_r68.RData"
pathOutS3 <- "prop_sla3_dti_r68.RData"

time.start <- proc.time()

cl <- makeCluster(nc)
driver_exp(cl, seed, times, maxiter, pathIn.ctrl, "c", pathOutC)
driver_exp(cl, seed, times, maxiter, pathIn.sla2, "s2", pathOutS2)
driver_exp(cl, seed, times, maxiter, pathIn.sla3, "s3", pathOutS3)
stopCluster(cl)


time.used <- proc.time() - time.start
time.used