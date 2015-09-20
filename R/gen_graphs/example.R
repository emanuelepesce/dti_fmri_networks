rm(list = ls())
source("./attachStructural.R")
source("./attachFunctional.R")
source("./attachNames.R")
source("./attachCoordinates.R")

g <- make_full_graph(90, TRUE, TRUE)

#name of the graph

m <- getMatrixFromFile("./../../data/structural/naive/Controls/CTRL_amore.txt")
g <- attachDtiToGraph(g, m)

m <- getMatrixFromFile("./../../data/structural/naive/Controls/CTRL_amore.txt")
g <- attachDtiInverseToGraph(g, m)

m <- getMatrixFromFile("./../../data/functional/naive/Controls/CTRL_amore.txt", sep=",")
g <- attachFmriToGraph(g, m)

path_names <- "./../../data/utils/aalLABELS.txt"
m <- read.table(path_names, header=FALSE)
roiNames <- as.matrix(m)
g <- attachRoiNames(g, roiNames)

path_names <- "./../../data/utils/aalCOG.txt"
m <- read.table(path_names, header=FALSE)
coords <- as.matrix(m)
g <- attachCoordinates(g, coordinates = coords)

