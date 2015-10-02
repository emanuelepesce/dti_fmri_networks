rm(list=ls())
library(ggplot2)

# load("./server_results/info_edges_0030to0065_25set2015.RData")
load("./server_results/info_edges_0030to0065_26set2015.RData")

# create input
n = 11
info_edges <- data.frame()
for(i in 1:11){
  tmp  <-data.frame(threshold = results[[i]]$threshold, 
                    total = results[[i]]$total,
                    strong = results[[i]]$strong,
                    weak = results[[i]]$weak
                    )
  tmp
  info_edges <- rbind(info_edges, tmp)

}

df <- info_edges

# info_edges <- unlist(results)
# info_edges <- matrix(info_edges, ncol=4, byrow = T)
# df <- data.frame(info_edges)
# colnames(df) <- c("threshold", "total", "strong", "weak")

# green: total ties 
# red: strong ties
# blue: weak ties


# qplot(x = info_edges[,1], y = info_edges[,2], 
#       xlab = "Threshold", ylab = "Number of edges", main = "Screeplot threshold",
#       shape = I(19), size = I(4), color = "red", col="strong")


# ---------------------------- Ploting Screeplot--------------------------------
nnames <- c("strong", "weak", "total")
p <- ggplot(df, aes(x = df$threshold, y = df$total, col = "Total"))
p <- p + geom_point(size = 5)
p <- p + xlab("Threshold") + ylab("Number of edges") + ggtitle("Screeplot")
p <- p + scale_color_discrete(name = "Legend")

p <- p +geom_point(data = df, aes(x = df$threshold, y = df$weak, col = "Weak", group =df$weak ),
                   size = 5)

p <- p + geom_point(data = df, aes(x = df$threshold, y = df$strong, col = "Strong"),
                    size = 5)

p <- p + scale_x_continuous(breaks = seq(min(df$threshold), max(df$threshold), by = 0.005))

p <- p + scale_y_continuous(breaks = seq(0, 8100, by = 500))

p
  
