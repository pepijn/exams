data <- read.csv('/tmp/exams_matrix', header = TRUE, row.names = 1)
matrix <- as.matrix(data)

dist <- dist(matrix)

# Magic number: 30 levels
kmeans <- kmeans(dist, 30)
table <- as.data.frame(kmeans$cluster)
table$id <- row.names(table)

write.csv(table, '/tmp/exams_levels.csv' quote = FALSE, row.names = FALSE)

