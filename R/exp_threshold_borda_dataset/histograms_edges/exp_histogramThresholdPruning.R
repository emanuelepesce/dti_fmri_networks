#' esperiments for visualization which edges are cutted
#' 
#' Author: Emanuele Pesce
rm(list=ls())
library(grid)
library(igraph)
library(plotrix)
library(ggplot2)

source("./../../utils/multiplot.R", chdir = T)

ptm <- proc.time()
# -------------------------- Inititialization ----------------------------------
dataIn <- "./../server_results/info_edges_0030to0065_26set2015.RData"

pathOut_b <- "./../../../data/other/borda/histograms_threshold_cutting/base_plot/"
pathOut_g <- "./../../../data/other/borda/histograms_threshold_cutting/ggplot/"


# -------------------------- Running -------------------------------------------


load(dataIn)

# indices of thresholds values to get
t_min <- 2
t_max <- 6

list_controls <- list()
list_sla2 <- list()
list_sla3 <- list()
list_thresholds <- list()

# create lists of residual graphs
ii <- 1
for(i in t_min:t_max){
  list_thresholds[ii] <- results[[i]]$threshold
  list_controls[[ii]] <- results[[i]]$r_C$residualGraph
  list_sla2[[ii]] <- results[[i]]$r_S2$residualGraph
  list_sla3[[ii]] <- results[[i]]$r_S3$residualGraph
  ii <- ii + 1
}




# plotting ggplot
ymax <- 250
n_breaks <- seq(0,20)
v_bin <- 300
for(i in 1:length(list_controls)){
  # controls
  w <- E(list_controls[[i]])$weight
  df1 <- data.frame(w)
  colnames(df1) <- ("weights")
  
  p1 <- ggplot(df1, aes(df1$weights)) +
        geom_histogram(binwidth = v_bin, col="black", fill="green", alpha = .5) + 
        labs(title=paste("Controls, Threshold = ",list_thresholds[i])) +
        labs(x = "Borda score", y ="Number of edges") +
        ylim(c(0,ymax))
p1
  # sla2 
  w <- E(list_sla2[[i]])$weight
  df2 <- data.frame(w)
  colnames(df2) <- ("weights")
  
  p2 <- ggplot(df2, aes(df2$weights)) +
        geom_histogram(binwidth = v_bin, col="black", fill="orange", alpha = .5) +
        labs(title=paste("Sla2, Threshold = ",list_thresholds[i])) + 
        labs(x = "Borda score", y ="Number of edges") +
        ylim(c(0,ymax))
  
  # sla3
  w <- E(list_sla3[[i]])$weight
  df3 <- data.frame(w)
  colnames(df3) <- ("weights")
  
  p3 <- ggplot(df3, aes(df3$weights)) + 
        geom_histogram(binwidth = v_bin, col="black", fill="red", alpha = .5) +
        labs(title=paste("Sla3, Threshold = ",list_thresholds[i])) +
        labs(x = "Borda score", y ="Number of edges") +
        ylim(c(0,ymax))
  
  
  pathToSave <- paste(pathOut_g, "./hist_edgesBordaScore_", i, ".jpeg", sep = "")
  jpeg(filename = pathToSave, width = 1200, height = 550)
  p <- multiplot(p1, p2, p3, cols = 3)
  dev.off()
}




# plotting base
ymax <- 500
for(i in 1:length(list_controls)){
  X11 ()
  
  par(mfrow=c(1, 3))
  hist(x = E(list_controls[[i]])$weight, xlab = "Borda Score", 
       main = paste("Controls, Threshold = ",list_thresholds[i]),
       ylim = c(0,ymax), col="steelblue")
  hist(x = E(list_sla2[[i]])$weight, xlab = "Borda Score", 
       main = paste("Sla2, Threshold = ",list_thresholds[i]),
       ylim = c(0,ymax), col="orange")
  hist(x = E(list_controls[[i]])$weight, xlab = "Borda Score", 
       main = paste("Sla3, Threshold = ",list_thresholds[i]),
       ylim = c(0,ymax), col="red")
  
  pathToSave <- paste(pathOut_b, "./hist_edgesBordaScore_", i, ".jpeg", sep = "")
  dev.copy(jpeg,filename=pathToSave, width = 1200, height = 550);
  
  dev.off ();
}

graphics.off()



time = proc.time() -ptm
print (time)