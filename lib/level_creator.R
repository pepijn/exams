data <- read.csv('/tmp/exams_matrix', header = TRUE, row.names = 1)
matrix <- as.matrix(data)

dist <- dist(matrix)
hclust <- hclust(dist)

tree <- cutree(hclust, 30)
table <- as.data.frame(tree)
table$id <- row.names(table)

write.csv(table, quote = FALSE, row.names = FALSE)
