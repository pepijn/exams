library("dynamicTreeCut")

data <- read.csv('/tmp/exams_matrix', header = TRUE, row.names = 1)
matrix <- as.matrix(data)

dist <- dist(matrix)

# Magic number: 30 levels
hclust <- hclust(dist)

tree <- cutree(hclust, 50)
table <- data.frame(rownames(matrix))
table$level <- tree

#tree <- cutreeHybrid(hclust, matrix, minClusterSize = 5)
#table <- data.frame(tree$labels)
#table$id <- row.names(matrix)

colnames(table) <- c("id", "level")
write.csv(table, '/tmp/exams_levels.csv', quote = FALSE, row.names = FALSE)
