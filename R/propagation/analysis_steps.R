rm(list = ls())

# borda 
pathIn_C <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_controls.RData"
pathIn_S2 <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_SLA2.RData"
pathIn_S3 <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_SLA3.RData"

meanSteps <- NULL

# controls
load(pathIn_C)

# get nsteps and uvisted
udata <- unlist(data)

nsteps <- NULL
nvisited <- NULL

for (i in 1:length(udata)){
  if(i%%2==0){
    nvisited <- c(nvisited, udata[i])
  }
  else{
    nsteps <- c(nsteps, udata[i])
  }
}

meanSteps <- c(meanSteps, mean(nsteps))

# sla 2
load(pathIn_S2)

# get nsteps and uvisted
udata <- unlist(data)

nsteps <- NULL
nvisited <- NULL

for (i in 1:length(udata)){
  if(i%%2==0){
    nvisited <- c(nvisited, udata[i])
  }
  else{
    nsteps <- c(nsteps, udata[i])
  }
}
meanSteps <- c(meanSteps, mean(nsteps))

# sla 3
load(pathIn_S3)

# get nsteps and uvisted
udata <- unlist(data)

nsteps <- NULL
nvisited <- NULL

for (i in 1:length(udata)){
  if(i%%2==0){
    nvisited <- c(nvisited, udata[i])
  }
  else{
    nsteps <- c(nsteps, udata[i])
  }
}
meanSteps <- c(meanSteps, mean(nsteps))