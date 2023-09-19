

vcf_to_related <- function(input, output, popmap) {
	options(scipen=999)
	
	# read in input file
	x <- read.table(input, sep="", stringsAsFactors=F, header=F)
	
	# read in popmap 
	popmap2 <- read.table(popmap, stringsAsFactors=F)
	
	# replace all phased genotypes with unphased genotypes
	for(a in 5:ncol(x)) {
		x[,a] <- gsub("\\|", "/", x[,a])
		# zeros considered missing data, so switch to fives (arbitrary choice)
		x[,a] <- gsub("0", "5", x[,a])
	}
	
	# get genotypes in vector format for each individual
	genotypes <- list()
	for(a in 1:nrow(popmap2)) {
		genotypes[[a]] <- unlist(strsplit(x[,(a + 4)], "/"))
	}
	
	# get all the genotypes into a matrix
	for(a in 1:nrow(popmap2)) {
		if(a == 1) {
			output_genotypes <- genotypes[[a]]
		} else {
			output_genotypes <- rbind(output_genotypes, genotypes[[a]])
		}
	}
	rownames(output_genotypes) <- popmap2[,1]
	
	# write output
	write.table(output_genotypes, file=output, quote=F, col.names=F, sep="\t")
	
}


