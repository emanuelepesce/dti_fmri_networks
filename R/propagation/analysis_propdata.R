rm(list=ls())
library(igraph)
library(TopKLists)

# ==== definitions ====
path.base <- "./../../data/results/propagation/rand_walk_complete/borda_sw_004/server_fmri_complete_r1/"
pathIn.ctrl <- paste(path.base, "res_ctrl.RData", sep = "")
pathIn.sla2 <- paste(path.base, "res_sla2.RData", sep = "")
pathIn.sla3 <- paste(path.base, "res_sla3.RData", sep = "")


pathIn.ctrl <- "./server3/prop_ctrl_dti_r1.RData"
pathIn.sla2 <- "./server3/prop_sla2_dti_r1.RData"
pathIn.sla3 <- "./server3/prop_sla3_dti_r1.RData"


pathIn.graph_ex <- ("./../../data/results/borda_example_graph.graphml")
g <- read.graph(pathIn.graph_ex, format = "graphml")

pathOut.obj <- paste(path.base, "analysis_complete.RData", sep = "")

pathOut.obj <- "./analysis_complete.RData"

# ==== load data ===
res.prop <- list()
load(pathIn.ctrl)
res.prop[[1]] <- data.prop
load(pathIn.sla2) 
res.prop[[2]] <- data.prop
load(pathIn.sla3) 
res.prop[[3]] <- data.prop

# ===================== functions =========================

# calculate the mean of propagation
time_mean <- function(obj){
  n.sbj <- dim(obj)[1]
  
  mean.sbj <- vector(mode = "numeric", length = n.sbj)
  for(i in 1:n.sbj){
    mean.sbj[i] <- mean(obj[i,])
  }
  return(mean(mean.sbj))
}

# calculate k items with max frequency
topK_freq <- function(obj, k, exgraph){
  maxfreq.idx <- vector(mode = "numeric", k)
  maxfreq.value <- vector(mode = "numeric", k)
  maxfreq.area_vs <- vector(mode = "logical", k)
  maxfreq.area_vt <- vector(mode = "logical", k)
  
  
  for(i in 1:k){
    idx <- which.max(obj)
    maxfreq.idx[i] <- idx
    maxfreq.value[i] <- obj[idx]
    obj[idx] <- 0
    
    edge.v <- ends(exgraph, idx)
    edge.names <- get.vertex.attribute(exgraph, name = "roiName", edge.v)
    maxfreq.area_vs[i] <- edge.names[1]
    maxfreq.area_vt[i] <- edge.names[2]
  }
  
  df <- data.frame(maxfreq.idx, maxfreq.value, maxfreq.area_vs, maxfreq.area_vt)
  colnames(df) <- c("Index", "Value", "Area_From", "Area_To")
  return(df)
}


# calculate the average path
average_walk <- function(obj, exgraph){
  n.sbj <- length(obj)
  l_path <- list()
  s_path <- list()
  si <- 1
  li <- 1
  for(i in 1:n.sbj){
    c.sbj <- obj[[i]]
    for(j in 1:length(c.sbj)){
      s_path[[si]] <- calculate_order(unlist(c.sbj[[j]]))
      si <- si + 1  
    }  
    bo <- Borda(s_path)
    l_path[[li]] <- bo$TopK$mean
    li <- li + 1
  }
  avg.walk.vertex <- Borda(l_path)$TopK$mean
  avg.walk.name <-  vector(mode = "logical", length(avg.walk.vertex))
  for(i in 1:length(avg.walk.vertex)){
    avg.walk.name[i] <- get.vertex.attribute(exgraph, name = "roiName", 
                                          index = avg.walk.vertex[i])
  }
  df <- data.frame(avg.walk.vertex, avg.walk.name)
  colnames(df) <- c("Vertex", "Area")
  return(df)
}


# calculate exploration order
calculate_order <- function(path){
  n <- length(path)
  visited <- vector(mode = "numeric")

  for(i in 1:n){
    if(!(path[i] %in% visited)){
      visited <- c(visited, path[i])
    
    }
  }
  return(visited)
}

# ==== propagation time ====
mean.groups <- vector(mode = "numeric", length = 3)
mean.groups[1] <- time_mean(res.prop[[1]]$sbj_times)
mean.groups[2] <- time_mean(res.prop[[2]]$sbj_times)
mean.groups[3] <- time_mean(res.prop[[3]]$sbj_times)


# ==== top frequency edge ====
topfreq.groups <- list()
k <- 10
freq.ctrl <- res.prop[[1]]$f_edge/max(res.prop[[1]]$f_edge)
freq.sla2 <- res.prop[[2]]$f_edge/max(res.prop[[2]]$f_edge)
freq.sla3 <- res.prop[[3]]$f_edge/max(res.prop[[3]]$f_edge)
freq.ctrl <- res.prop[[1]]$f_edge/15
freq.sla2 <- res.prop[[2]]$f_edge/29
freq.sla3 <- res.prop[[3]]$f_edge/10
topfreq.groups[[1]] <- topK_freq(freq.ctrl, k, g)
topfreq.groups[[2]] <- topK_freq(freq.sla2, k, g)
topfreq.groups[[3]] <- topK_freq(freq.sla3, k, g)


# ==== top frequency edge ====
avgwalk.groups <- list()
k <- 10
avgwalk.groups[[1]] <- average_walk(res.prop[[1]]$sbj_history, g)
avgwalk.groups[[2]] <- average_walk(res.prop[[2]]$sbj_history, g)
avgwalk.groups[[3]] <- average_walk(res.prop[[3]]$sbj_history, g)

df.avgwalk <- data.frame(avgwalk.groups[[1]]$Area, 
                         avgwalk.groups[[2]]$Area,
                         avgwalk.groups[[3]]$Area)

colnames(df.avgwalk) <- c("Controls", "Sla2", "Sla3")

save.image(file = pathOut.obj)
