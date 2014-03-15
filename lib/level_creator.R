library("dynamicTreeCut")

data <- read.csv('/tmp/exams_matrix', header = TRUE, row.names = 1)
matrix <- as.matrix(data)

dist <- dist(matrix)

# Magic number: 30 levels
hclust <- hclust(dist)
tree <- cutreeHybrid(hclust, matrix, minClusterSize = 6, cutHeight = 4)

table <- data.frame(tree$labels)
table$id <- row.names(matrix)

write.csv(table, '/tmp/exams_levels.csv', quote = FALSE, row.names = FALSE)

