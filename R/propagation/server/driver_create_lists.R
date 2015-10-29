source("./create_lists.R")
# Borda
pathIn <- vector(length = 3)
pathIn[1] <- "./../../../data/graphs_integration/borda_sw_004/Controls/"
pathIn[2] <- "./../../../data/graphs_integration/borda_sw_004/SLA2/"
pathIn[3] <- "./../../../data/graphs_integration/borda_sw_004/SLA3/"

pathOut <- vector(length = 3)
pathOut[1] <- "./../../../data/graphs_integration/borda_sw_004/igraphs_controls.RData"
pathOut[2] <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA2.RData"
pathOut[3] <- "./../../../data/graphs_integration/borda_sw_004/igraphs_SLA3.RData"

igraphs_controls <- create_lists(pathIn[1])
igraphs_SLA2 <- create_lists(pathIn[2])
igraphs_SLA3 <- create_lists(pathIn[3])

save(igraphs_controls, file = pathOut[1])
save(igraphs_SLA2, file = pathOut[2])
save(igraphs_SLA3, file = pathOut[3])

# signtest
pathIn <- vector(length = 3)
pathIn[1] <- "./../../../data/graphs_integration/sign_test/Controls/"
pathIn[2] <- "./../../../data/graphs_integration/sign_test/SLA2/"
pathIn[3] <- "./../../../data/graphs_integration/sign_test/SLA3/"

pathOut <- vector(length = 3)
pathOut[1] <- "./../../../data/graphs_integration/sign_test/igraphs_controls.RData"
pathOut[2] <- "./../../../data/graphs_integration/sign_test/igraphs_SLA2.RData"
pathOut[3] <- "./../../../data/graphs_integration/sign_test/igraphs_SLA3.RData"

igraphs_controls <- create_lists(pathIn[1])
igraphs_SLA2 <- create_lists(pathIn[2])
igraphs_SLA3 <- create_lists(pathIn[3])

save(igraphs_controls, file = pathOut[1])
save(igraphs_SLA2, file = pathOut[2])
save(igraphs_SLA3, file = pathOut[3])