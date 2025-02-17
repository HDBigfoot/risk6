args <- commandArgs(trailingOnly = TRUE)

csv_file <- args[1]

pcr-data <- read.csv(csv_file, header = TRUE, row.names = 1

print(pcr-data))
