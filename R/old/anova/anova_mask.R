#' Perform a T-Test in order to remove noise
#' 
#' Authors: Alessandro Merola, Emanuele Pesce
library(igraph)
library(miscTools)

#' Create a mask of edges using anova and bonferroni correction
#' 
#' @param pathIn: directory containing igraph files
#' @param tmu: mu value to use to use t-test
#' @param tr: threshold to use for cutting using p-values
#' @param verbose: if > 0 enable check prints
#' @param form: format of the graph file to read
#' 
#' @examples
#' pathIn <-  "./../../data/graphs_integration/full_connected/Controls/"
#' res <- t_test_edges_cutting(pathIn)
#' write.table(res$selected_edges, file = pathOut, sep=",", col.names = F, row.names = F)
anova_test_cutting <- function(pathC, pathS2, pathS3, tmu = 0,  tr = 0.05, verbose = 1, 
                                 form = "graphml") {

  l_pvalues <- list() # list containing p values
  list_edges <- matrix(nrow = 0, ncol = 2) # edges list
  
  k <- 1              # counter for edges
  kp <- 1             # counter for l_pvalues
  kr <- 1             # counter for taken edges
  
  patt <- paste("*", form, sep = "")
  
  verbose = 1
  
  # ---- Create a list of Controls graphs
  list_graphs_C <- list()
  files_names <- list.files(path = pathC, pattern = patt) # names of graph files in pathIn
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathC, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_C[[k]] <- g
    k <- k + 1    
  }
  
  
  # ---- Create a list of Sla2 graphs
  list_graphs_S2 <- list()
  files_names <- list.files(path = pathS2, pattern = patt) # names of graph files in pathIn
  k <- 1
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathS2, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_S2[[k]] <- g
    k <- k + 1    
  }
  
  # ---- Create a list of Sla3 graphs
  list_graphs_S3 <- list()
  files_names <- list.files(path = pathS3, pattern = patt) # names of graph files in pathIn
  k <- 1
  
  for(i in 1:length(files_names)) { # for each file 
    cfile <- paste(pathS3, files_names[i], sep="") # get complete name (including path)
    g <- read.graph(cfile, format = form)          # get the graph
    list_graphs_S3[[k]] <- g
    k <- k + 1    
  }
  
  
  # ----  Generate all pairs of vertices (edges)
  #       For edge get all dti values of all graphs
  #       Computer t-test
  n_vertices <- vcount(g)
  for(i in 1:n_vertices) {
    vi <- i                     # fist vertex
    for (j in 1:n_vertices) {
      vj <- j                   # second vertex
      l_dti_values <- list()    #inizialize list of dti values for the edge vi-vj
      class_values <- list()
      
      # Check print
      if (verbose > 0) {
        print("Egde:")
        print(vi)
        print(vj)
      }
      
      # If the pair is valid
      if (vi != vj) { 
        
        # For each graph take the dti edge value (vi-vj)
        inx <- 1
        g <- NULL   # security check
        for(k in 1:length(list_graphs_C)) {
          g <- list_graphs_C[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "controls"
            inx <- inx + 1
          }          
        }
        
        for(k in 1:length(list_graphs_S2)) {
          g <- list_graphs_S2[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "sla2"
            inx <- inx + 1
          }          
        }  
        
        
        for(k in 1:length(list_graphs_S3)) {
          g <- list_graphs_S3[[k]]
          if(g[vi, vj, attr = "dti"] >= 0) { 
            l_dti_values[inx] <- g[vi, vj, attr = "dti"]
            class_values[inx] <- "sla3"
            inx <- inx + 1
          }          
        }
        
        df <- data.frame(unlist(l_dti_values), unlist(class_values))
        colnames(df) <- c("values", "class")
        
        
        an <- lm(values ~ class, data=df)
        res <- anova(an)
        l_pvalues[kp] <- res$Pr[1]
        list_edges <- insertRow(list_edges, kp, c(vi,vj))
        kp <- kp + 1
       
       
      } 
    } # end for j
  }# end for i
  
  # apply bonferroni correction
  adj <- p.adjust(unlist(l_pvalues), "bonferroni")
  
  # cut evaluating the threshold 
  toSelect <- which(adj <= tr, arr.ind = T)
  selected_edges <- list_edges[toSelect,]
  
  # return 
  res <- list("adj" = adj, "p_values" = l_pvalues, 
              "selected_edges" = selected_edges);
  
  return(res) 
}

pathInC <- "./../../data/graphs_integration/full_connected/Controls/"
pathInS2 <- "./../../data/graphs_integration/full_connected/SLA2/"
pathInS3 <- "./../../data/graphs_integration/full_connected/SLA3/"

r <- anova_test_cutting(pathInC, pathInS2, pathInS3)

load(file = "./anova_mask.RData")
l_pvalues <- r$p_values
adj <- p.adjust(unlist(l_pvalues), "none")

# cut evaluating the threshold 
toSelect <- which(adj <= 0.07, arr.ind = T)
toSelect
selected_edges <- list_edges[toSelect,]





mySIGN.test <- function (x, y = NULL, md = 0, alternative = "two.sided", conf.level = 0.95) 
{
  choices <- c("two.sided", "greater", "less")
  alt <- pmatch(alternative, choices)
  alternative <- choices[alt]
  if (length(alternative) > 1 || is.na(alternative)) 
    stop("alternative must be one \"greater\", \"less\", \"two.sided\"")
  if (!missing(md)) 
    if (length(md) != 1 || is.na(md)) 
      stop("median must be a single number")
  if (!missing(conf.level)) 
    if (length(conf.level) != 1 || is.na(conf.level) || conf.level < 
          0 || conf.level > 1) 
      stop("conf.level must be a number between 0 and 1")
  if (is.null(y)) {
    dname <- paste(deparse(substitute(x)))
    x <- sort(x)
    diff <- (x - md)
    n <- length(x)
    nt <- length(x) - sum(diff == 0)
    s <- sum(diff > 0)
    estimate <- median(x)
    method <- c("One-sample Sign-Test")
    names(estimate) <- c("median of x")
    names(md) <- "median"
    names(s) <- "s"
    CIS <- "Conf Intervals"
    if (alternative == "less") {
      pval <- sum(dbinom(0:s, nt, 0.5))
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)][1]
      if (k < 1) {
        conf.level <- (1 - (sum(dbinom(k, n, 0.5))))
        xl <- -Inf
        xu <- x[n]
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(-Inf, x[n - k + 1])
        acl1 <- (1 - (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(-Inf, x[n - k])
        acl2 <- (1 - (sum(dbinom(0:k, n, 0.5))))
        xl <- -Inf
        xu <- (((x[n - k + 1] - x[n - k]) * (conf.level - 
                                               acl2))/(acl1 - acl2)) + x[n - k]
        ici <- c(xl, xu)
      }
    }
    else if (alternative == "greater") {
      pval <- (1 - sum(dbinom(0:s - 1, nt, 0.5)))
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)][1]
      if (k < 1) {
        conf.level <- (1 - (sum(dbinom(k, n, 0.5))))
        xl <- x[1]
        xu <- Inf
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(x[k], Inf)
        acl1 <- (1 - (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(x[k + 1], Inf)
        acl2 <- (1 - (sum(dbinom(0:k, n, 0.5))))
        xl <- (((x[k] - x[k + 1]) * (conf.level - acl2))/(acl1 - 
                                                            acl2)) + x[k + 1]
        xu <- Inf
        ici <- c(xl, xu)
      }
    }
    else {
      p1 <- sum(dbinom(0:s, nt, 0.5))
      p2 <- (1 - sum(dbinom(0:s - 1, nt, 0.5)))
      pval <- min(2 * p1, 2 * p2, 1)
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)/2][1]
      if (k < 1) {
        conf.level <- (1 - 2 * (sum(dbinom(k, n, 0.5))))
        xl <- x[1]
        xu <- x[n]
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(x[k], x[n - k + 1])
        acl1 <- (1 - 2 * (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(x[k + 1], x[n - k])
        acl2 <- (1 - 2 * (sum(dbinom(0:k, n, 0.5))))
        xl <- (((x[k] - x[k + 1]) * (conf.level - acl2))/(acl1 - 
                                                            acl2)) + x[k + 1]
        xu <- (((x[n - k + 1] - x[n - k]) * (conf.level - 
                                               acl2))/(acl1 - acl2)) + x[n - k]
        ici <- c(xl, xu)
      }
    }
  }
  else {
    if (length(x) != length(y)) 
      stop("Length of x must equal length of y")
    xy <- sort(x - y)
    diff <- (xy - md)
    n <- length(xy)
    nt <- length(xy) - sum(diff == 0)
    s <- sum(diff > 0)
    dname <- paste(deparse(substitute(x)), " and ", deparse(substitute(y)), 
                   sep = "")
    estimate <- median(xy)
    method <- c("Dependent-samples Sign-Test")
    names(estimate) <- c("median of x-y")
    names(md) <- "median difference"
    names(s) <- "S"
    CIS <- "Conf Intervals"
    if (alternative == "less") {
      pval <- sum(dbinom(0:s, nt, 0.5))
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)][1]
      if (k < 1) {
        conf.level <- (1 - (sum(dbinom(k, n, 0.5))))
        xl <- -Inf
        xu <- xy[n]
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(-Inf, xy[n - k + 1])
        acl1 <- (1 - (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(-Inf, xy[n - k])
        acl2 <- (1 - (sum(dbinom(0:k, n, 0.5))))
        xl <- -Inf
        xu <- (((xy[n - k + 1] - xy[n - k]) * (conf.level - 
                                                 acl2))/(acl1 - acl2)) + xy[n - k]
        ici <- c(xl, xu)
      }
    }
    else if (alternative == "greater") {
      pval <- (1 - sum(dbinom(0:s - 1, nt, 0.5)))
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)][1]
      if (k < 1) {
        conf.level <- (1 - (sum(dbinom(k, n, 0.5))))
        xl <- xy[1]
        xu <- Inf
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(xy[k], Inf)
        acl1 <- (1 - (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(xy[k + 1], Inf)
        acl2 <- (1 - (sum(dbinom(0:k, n, 0.5))))
        xl <- (((xy[k] - xy[k + 1]) * (conf.level - acl2))/(acl1 - 
                                                              acl2)) + xy[k + 1]
        xu <- Inf
        ici <- c(xl, xu)
      }
    }
    else {
      p1 <- sum(dbinom(0:s, nt, 0.5))
      p2 <- (1 - sum(dbinom(0:s - 1, nt, 0.5)))
      pval <- min(2 * p1, 2 * p2, 1)
      loc <- c(0:n)
      prov <- (dbinom(loc, n, 0.5))
      k <- loc[cumsum(prov) > (1 - conf.level)/2][1]
      if (k < 1) {
        conf.level <- (1 - 2 * (sum(dbinom(k, n, 0.5))))
        xl <- xy[1]
        xu <- xy[n]
        ici <- c(xl, xu)
      }
      else {
        ci1 <- c(xy[k], xy[n - k + 1])
        acl1 <- (1 - 2 * (sum(dbinom(0:k - 1, n, 0.5))))
        ci2 <- c(xy[k + 1], xy[n - k])
        acl2 <- (1 - 2 * (sum(dbinom(0:k, n, 0.5))))
        xl <- (((xy[k] - xy[k + 1]) * (conf.level - acl2))/(acl1 - 
                                                              acl2)) + xy[k + 1]
        xu <- (((xy[n - k + 1] - xy[n - k]) * (conf.level - 
                                                 acl2))/(acl1 - acl2)) + xy[n - k]
        ici <- c(xl, xu)
      }
    }
  }
  if (k < 1) {
    cint <- ici
    attr(cint, "conf.level") <- conf.level
    rval <- structure(list(statistic = s, p.value = pval, 
                           estimate = estimate, null.value = md, alternative = alternative, 
                           method = method, data.name = dname, conf.int = cint))
    oldClass(rval) <- "htest"
    return(rval)
  }
  else {
    result1 <- c(acl2, ci2)
    result2 <- c(conf.level, ici)
    result3 <- c(acl1, ci1)
    Confidence.Intervals <- round(as.matrix(rbind(result1, 
                                                  result2, result3)), 4)
    cnames <- c("Conf.Level", "L.E.pt", "U.E.pt")
    rnames <- c("Lower Achieved CI", "Interpolated CI", "Upper Achieved CI")
    dimnames(Confidence.Intervals) <- list(rnames, cnames)
    cint <- ici
    attr(cint, "conf.level") <- conf.level
    rval <- structure(list(statistic = s, parameter = NULL, 
                           p.value = pval, conf.int = cint, estimate = estimate, 
                           null.value = md, alternative = alternative, method = method, 
                           data.name = dname))
    oldClass(rval) <- "htest"
    print(rval)
    return(list(rval,Confidence.Intervals))
  }
}
