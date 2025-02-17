risk6 <- function(rdat)
        {# Get primers in subsets and weights
        subsets <- read.table("RISK6Gene_Subsets.txt", colClasses = character(), stringsAsFactors = F, sep = "\t");
        # Get primers in scorce tables
        scoreTables <- list();
        for (subset in 1:nrow(subsets))
        {
                scoreTables[[subset]] <- read.table(paste("RISK6Gene_ScoreTable/RISK6Gene_ScoreTable", subset, ".txt", sep = ""), colClasses = numeric(), sep = "\t");
        }
        subsetPrimers <- unique(c(subsets[,1], subsets[,2]));
        # Get predictions for each sample
        predictions <- NULL
        uniqueSamples <- unique(colnames(rdat))
        samples <- colnames(rdat)
        primers <- rownames(rdat)
        pairwiseScores <- matrix(0, nrow = nrow(subsets), ncol = length(uniqueSamples))
        for (sample in uniqueSamples)
        {
                sampleIndex <- match(sample, uniqueSamples)
                sampleReplicates <- which(samples == sample)
                scoreSum <- 0
                scoreCount <- 0
                for (subset in 1:nrow(subsets)) {
                        primer1 <- subsets[subset,1]
                        primer2 <- subsets[subset,2]
                        if (primer1 %in% primers & primer2 %in% primers){
                                ratio <- 0
                                ratioCount <- 0
                                for (rep in sampleReplicates)
                                {
                                        pIndices1 <- which(primers == primer1 & !is.na(rdat[,rep]));
                                        pIndices2 <- which(primers == primer2 & !is.na(rdat[,rep]));
                                        
                                        for (p1 in pIndices1)
                                        {
                                                for (p2 in pIndices2)
                                                {
                                                        if (!is.na(rdat[p1,rep]) & !is.na(rdat[p2,rep])){
                                                                ratio <- ratio + rdat[p2,rep] - rdat[p1,rep]
                                                                ratioCount <- ratioCount + 1
                                                        }
                                                }; rm(p2)	
                                        }; rm(p1)
                                }
                                if (ratioCount > 0)
                                {
                                        ratio <- ratio / ratioCount
                                        scoreFound <- FALSE
                                        ratioTested <- 1
                                        while (!scoreFound & ratioTested <= nrow(scoreTables[[subset]]))
                                        {
                                                if (ratio < scoreTables[[subset]][ratioTested,1])
                                                {
                                                        scoreSum <- scoreSum + scoreTables[[subset]][ratioTested,2]
                                                        scoreCount <- scoreCount + 1
                                                        scoreFound <- TRUE
                                                        pairwiseScores[subset,sampleIndex] <- scoreTables[[subset]][ratioTested,2]
                                                }
                                                ratioTested <- ratioTested + 1
                                        }
                                        if (!scoreFound)
                                        {
                                                scoreSum <- scoreSum + 1
                                                scoreCount <- scoreCount + 1
                                                pairwiseScores[subset,sampleIndex] <- 1
                                        }
                                }
                        }
                }; rm(subset);
                predictions <- rbind(predictions, c(sample, scoreSum/scoreCount));
                predictions <- as.data.frame(predictions, stringsAsFactors = F)
        }; rm(sampleIndex)
        colnames(predictions) <- c("Sample Name", "Risk6 Score")
        return(predictions)
}
