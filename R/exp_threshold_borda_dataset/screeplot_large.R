rm(list=ls())
library(ggplot2)

# -------------------------- Inititialization ----------------------------------
data <- "./server_results/info_edges_0030to0080by1_02oct2015.RData"

pathOut <- "./../../data/other/borda/screeplot_threshold/"
nameFileOut <- "screeplot_30_80_by1.jpeg"
# -------------------------- Running ----------------------------------

load(data)

# put values to print in a data frame
n = 51
info_edges <- data.frame()
for(i in 1:n){
  tmp  <-data.frame(threshold = results[[i]]$threshold, 
                    total = results[[i]]$total,
                    strong = results[[i]]$strong,
                    weak = results[[i]]$weak
                    )
  tmp
  info_edges <- rbind(info_edges, tmp)

}

df <- info_edges

# ---------------------------- Plotting Screeplot--------------------------------
nnames <- c("strong", "weak", "total")
# data
p <- ggplot(df, aes(x = df$threshold, y = df$total, col = "Total"))
p <- p + geom_point(size = 5)
p <- p + geom_point(data = df, aes(x = df$threshold, y = df$weak, col = "Weak"),
                    size = 5) 
p <- p + geom_point(data = df, aes(x = df$threshold, y = df$strong, col = "Strong"),
                    size = 5) 
# lines 
p <- p + geom_line(aes(x= df$threshold,y=df$total, group = 1, col = "Total"))
p <- p + geom_line(aes(x= df$threshold,y=df$strong, group = 1, col = "Strong")) 
p <- p + geom_line(aes(x= df$threshold,y=df$weak, group = 1,  col = "Weak"))
# axis
p <- p + xlab("Threshold") + ylab("Number of edges") + ggtitle("Screeplot")
p <- p + scale_color_discrete(name = "Legend")
# ticks
p<- p + scale_x_continuous(breaks = seq(min(df$threshold), max(df$threshold), by = 0.005))

p <- p + scale_y_continuous(breaks = seq(0, 8100, by = 500))


pathToSave <- paste(pathOut, nameFileOut, sep = "")
# ggsave(file=fileOut, width = 25, height = 15, units = "cm")
jpeg(filename = pathToSave, width = 1200, height = 550)
p
dev.off()

