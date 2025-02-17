args <- commandArgs(trailingOnly = TRUE)

csv_file <- args[1]

pcrData <- read.csv(csv_file, header = TRUE, row.names = 1)

source("risk6.R")
risk6.results <- risk6(pcrData)

write.csv(risk6.results, row.names = FALSE)
