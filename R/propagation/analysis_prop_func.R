library(igraph)
library(TopKLists)
library(miscTools)

#' Calculate the mean of propagation of a group of subjects
#' @param obj: object containing the times of propagation for subjects 
#'              belonging at the same group
#' @return mean of propagation time of a group of subjects
time_mean <- function(obj){
  n.sbj <- dim(obj)[1]
  
  mean.sbj <- vector(mode = "numeric", length = n.sbj)
  for(i in 1:n.sbj){
    mean.sbj[i] <- mean(obj[i,])
  }
  return(mean(mean.sbj))
}

#' Calculate the standard deviationof the means of propagation of a group of subjects
#' @param obj: object containing the times of propagation for subjects 
#'              belonging at the same group
#' @return list:
#'         - sd.group: standard deviationof propagation time of a group of subjects
#'         - mean.sbj:  standard deviationof the means of a group
time_sd <- function(obj){
  n.sbj <- dim(obj)[1]
  
  mean.sbj <- vector(mode = "numeric", length = n.sbj)
  sd.sbj  <- vector(mode = "numeric", length = n.sbj)
  
  for(i in 1:n.sbj){
    mean.sbj[i] <- mean(obj[i,])
    sd.sbj[i] <- sd(obj[i,])
  }
  
  toRtrn <- list("sd.group" = sd(mean.sbj), "sd.sbj" = sd.sbj)
  return(toRtrn)
}


#' Calculate k edges with max frequency
#' @param obj: object containing the frequency of edges of a group
#' @return data frame contaning a list of edges
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

#' Calculate k edges with max frequency
#' @param obj: object containing the frequency of edges of a group
#' @return data frame contaning a list of edges (id)
topK_freq_id <- function(obj, k, exgraph){
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
    maxfreq.area_vs[i] <- edge.v[1]
    maxfreq.area_vt[i] <- edge.v[2]
  }
  
  df <- data.frame(maxfreq.idx, maxfreq.value, maxfreq.area_vs, maxfreq.area_vt)
  colnames(df) <- c("Index", "Value", "Area_From", "Area_To")
  return(df)
}


#' Calculate the average walker path of a group of subjects
#' @param obj: object containing the walker paths of a group of subjects
#' @param exgraph: dataset graph example
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


#' Calculate exploration order
#' @param path: a walker path
#' @return a vector in which vertex are sorted by visit time
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

time_regions_avg <- function(obj, penalization = 25){
  
  time.sbj <- vector(length = 90, mode = "numeric") 
  
  for(sbj in 1:length(obj)){
    for(walk in 1:length(obj[[sbj]])){
      cur <- obj[[sbj]][[walk]]
      for (reg in 1:90){
        idx <- which(cur == reg)
        idx <- idx[1]
        if(!is.na(idx)){
          time.sbj[reg] <- idx
        }
        else{
          # penalization
          time.sbj[reg] <- penalization
        }
      }
    }
    time.sbj <- time.sbj/length(obj[[sbj]])
    if(sbj == 1){
      M <- as.matrix(t(time.sbj))
    }
    else{
      M <- insertRow(M, sbj, time.sbj)
    }
  }
  avgM <- colMeans(M)
  avgM <- round(avgM, 1)
  return(avgM)
}


#' Analyze propagation data result
#' @param data.all: output if propagation esperiment. It is a list in which each
#'                  entry is a group of subjects
#' @param freq.k: indicate the number of top K edges which highest frequency
#' @param graph.ex: an example graph for indacating the structure of dataset graph
#' @param pathOut.obj: output where to save the result object
prop_analysys <- function(data.all, freq.k = 10, graph.ex, pathOut.obj){
    # ==== mean propagation time ====
  time.mean.groups <- vector(mode = "numeric", length = 3)
  time.mean.groups[1] <- time_mean(res.prop[[1]]$sbj_times)
  time.mean.groups[2] <- time_mean(res.prop[[2]]$sbj_times)
  time.mean.groups[3] <- time_mean(res.prop[[3]]$sbj_times)
  
  # ==== standard deviationpropagation time ====
  time.sd.groups <- vector(mode = "numeric", length = 3)
  time.sd.groups[1] <- time_sd(res.prop[[1]]$sbj_times)$sd.group
  time.sd.groups[2] <- time_sd(res.prop[[2]]$sbj_times)$sd.group
  time.sd.groups[3] <- time_sd(res.prop[[3]]$sbj_times)$sd.group
  
  # ==== standard deviationpropagation time for each subject ====
  time.sd.sbjs <- list()
  time.sd.sbjs[[1]] <- time_sd(res.prop[[1]]$sbj_times)$sd.sbj
  time.sd.sbjs[[2]] <- time_sd(res.prop[[2]]$sbj_times)$sd.sbj
  time.sd.sbjs[[3]] <- time_sd(res.prop[[3]]$sbj_times)$sd.sbj
  
  # ==== top frequency edge names ====
  topfreq.groups <- list()
  k <- freq.k
  freq.ctrl <- res.prop[[1]]$f_edge/max(res.prop[[1]]$f_edge)
  freq.sla2 <- res.prop[[2]]$f_edge/max(res.prop[[2]]$f_edge)
  freq.sla3 <- res.prop[[3]]$f_edge/max(res.prop[[3]]$f_edge)
  freq.ctrl <- res.prop[[1]]$f_edge/15
  freq.sla2 <- res.prop[[2]]$f_edge/29
  freq.sla3 <- res.prop[[3]]$f_edge/10
  topfreq.groups[[1]] <- topK_freq(freq.ctrl, k, g)
  topfreq.groups[[2]] <- topK_freq(freq.sla2, k, g)
  topfreq.groups[[3]] <- topK_freq(freq.sla3, k, g)


  # ==== top frequency edge ids ====
  topfreq.groups.id <- list()
  k <- freq.k
  freq.ctrl <- res.prop[[1]]$f_edge/max(res.prop[[1]]$f_edge)
  freq.sla2 <- res.prop[[2]]$f_edge/max(res.prop[[2]]$f_edge)
  freq.sla3 <- res.prop[[3]]$f_edge/max(res.prop[[3]]$f_edge)
  freq.ctrl <- res.prop[[1]]$f_edge/15
  freq.sla2 <- res.prop[[2]]$f_edge/29
  freq.sla3 <- res.prop[[3]]$f_edge/10
  topfreq.groups.id[[1]] <- topK_freq_id(freq.ctrl, k, g)
  topfreq.groups.id[[2]] <- topK_freq_id(freq.sla2, k, g)
  topfreq.groups.id[[3]] <- topK_freq_id(freq.sla3, k, g)
  
  
  # ====  average path ====
  avgwalk.groups <- list()
  k <- 10
  avgwalk.groups[[1]] <- average_walk(res.prop[[1]]$sbj_history, g)
  avgwalk.groups[[2]] <- average_walk(res.prop[[2]]$sbj_history, g)
  avgwalk.groups[[3]] <- average_walk(res.prop[[3]]$sbj_history, g)
  
  df.avgwalk <- data.frame(avgwalk.groups[[1]]$Area, 
                           avgwalk.groups[[2]]$Area,
                           avgwalk.groups[[3]]$Area)
  
  colnames(df.avgwalk) <- c("Controls", "Sla2", "Sla3")

  
  # ==== Time Matrix ==== 
  time.regions <- list()
  time.regions[[1]] <- time_regions_avg(res.prop[[1]]$sbj_history)
  time.regions[[2]] <- time_regions_avg(res.prop[[2]]$sbj_history)
  time.regions[[3]] <- time_regions_avg(res.prop[[3]]$sbj_history)
  
  roiNames <- V(graph.ex)$roiName
  df.time.regions <- data.frame(roiNames, time.regions[[1]], time.regions[[2]], 
                                time.regions[[3]])
  colnames(df.time.regions) <- c("Region", "Controls", "Sla2", "Sla3")
  
  
  analysis.prop <- list("time.mean.groups" = time.mean.groups,
                        "time.sd.groups" = time.sd.groups,
                        "time.sd.subjects" = time.sd.sbjs,
                        "time.regions" = df.time.regions,
                        "freq.topK.names" = topfreq.groups,
                        "freq.topK.id" = topfreq.groups.id,
                        "walks.avg" = df.avgwalk
                        )
  
  save(analysis.prop, file = pathOut.obj)
  return(analysis.prop)
}