library(gplots)

#' Compute the heatmap of the input matrix
#' @param m, matrix
#' @param pathOut, path where to save the heatmap
#' @param width, width of the heatmap image
#' @param height, height of the heatmap image
#' @param tmain, text to show as heatmap title
#' @return h, heatmap object
makeHeatmap <- function(m, pathOut = "", width = 1000, height = 1000,
                        tmain = "") {
  
  h <- heatmap.2(t(m), tracecol = F, main = tmain)
  
  if (pathOut == ""){
  }
  else{
    jpeg(filename=pathOut, width = width, height = height)
    eval(h$call)
    dev.off() 
  }

  return(h)
}
