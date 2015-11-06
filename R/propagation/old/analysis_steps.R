rm(list = ls())

# borda 
pathIn_C <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_controls.RData"
pathIn_S2 <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_SLA2.RData"
pathIn_S3 <- "./../../data/results/propagation/mean_steps/borda_sw_004/res_frequency_SLA3.RData"

meanSteps <- NULL
sdSteps <- NULL
# controls
load(pathIn_C)

# get nsteps and uvisted
udataC <- unlist(data)

nstepsC <- NULL
nvisited <- NULL

for (i in 1:length(udataC)){
  if(i%%2==0){
    nvisited <- c(nvisited, udataC[i])
  }
  else{
    nstepsC <- c(nstepsC, udataC[i])
  }
}

meanSteps <- c(meanSteps, mean(nstepsC))
sdSteps <- c(sdSteps, sd(nstepsC))

# sla 2
load(pathIn_S2)

# get nsteps and uvisted
udataS2 <- unlist(data)

nstepsS2 <- NULL
nvisited <- NULL

for (i in 1:length(udataS2)){
  if(i%%2==0){
    nvisited <- c(nvisited, udataS2[i])
  }
  else{
    nstepsS2 <- c(nstepsS2, udataS2[i])
  }
}
meanSteps <- c(meanSteps, mean(nstepsS2))
sdSteps <- c(sdSteps, sd(nstepsS2))


# sla 3
load(pathIn_S3)

# get nsteps and uvisted
udataS3 <- unlist(data)

nstepsS3 <- NULL
nvisited <- NULL

for (i in 1:length(udataS3)){
  if(i%%2==0){
    nvisited <- c(nvisited, udataS3[i])
  }
  else{
    nstepsS3 <- c(nstepsS3, udataS3[i])
  }
}
meanSteps <- c(meanSteps, mean(nstepsS3))
sdSteps <- c(sdSteps, sd(nstepsS3))


hist(nstepsC, breaks = 5)
hist(nstepsS2, breaks = 5)
hist(nstepsS3, breaks = 5)

