rm(list = ls())
source("./votingBorda.R")

# -------------------------- Inititialization ----------------------------------
pathIn <- "./../../data/structural/naive/SLA2/"
pathOut <- "./../../data/other/borda/borda_matrix_SLA2.txt"

# -------------------------- Running ------------------------------------------

if(interactive()){
  
  # preparing input to Borda
  mControls <- genMatrix(pathIn)
  
  # Borda voting
  outBorda=Borda(mControls,space = mControls)
  
  # saving
  writeBordaMatrix(filename = pathOut, outBorda$TopK$mean, outBorda$Scores$mean)
}