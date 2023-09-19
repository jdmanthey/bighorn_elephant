# input = input simple vcf file
# individuals = popmap
# output_fasta = output name
# min_sites = minimum number of sites to include (sometimes used, sometimes not, if no minimum, set to 1)
create_fasta_from_vcf <- function(input, popmap, output_fasta, min_sites) {
	individuals <- read.table(popmap)
	
	xxx <- read.table(input)
	
	# replace all phasing symbols
	for(a in 5:ncol(xxx)) {
		xxx[,a] <- gsub("\\|", "/", xxx[,a])
	}
	
	# remove any sites that are only homozygous reference and heterozygotes (doesn't work
	# with RAxML bias model)
	keep <- list()
	for(a in 1:nrow(xxx)) {
		a_rep <- unique(as.character(xxx[a,5:ncol(xxx)]))
		if("1/1" %in% a_rep & "0/0" %in% a_rep) {
			keep[[a]] <- a
		}
	}
	keep <- unlist(keep)
	xxx <- xxx[keep,]

	# subset genotypes and reference alleles
	genotypes <- xxx[,5:ncol(xxx)]
	ref_allele <- as.character(xxx[,3])
	alt_allele <- as.character(xxx[,4])
	heterozygote_allele <- rep("?", length(ref_allele))

	# fill in heterozygous ambiguity codes
	heterozygote_allele[ref_allele == "A" & alt_allele == "C"] <- "M"
	heterozygote_allele[ref_allele == "C" & alt_allele == "A"] <- "M"
	heterozygote_allele[ref_allele == "A" & alt_allele == "G"] <- "R"
	heterozygote_allele[ref_allele == "G" & alt_allele == "A"] <- "R"
	heterozygote_allele[ref_allele == "A" & alt_allele == "T"] <- "W"
	heterozygote_allele[ref_allele == "T" & alt_allele == "A"] <- "W"
	heterozygote_allele[ref_allele == "C" & alt_allele == "G"] <- "S"
	heterozygote_allele[ref_allele == "G" & alt_allele == "C"] <- "S"
	heterozygote_allele[ref_allele == "C" & alt_allele == "T"] <- "Y"
	heterozygote_allele[ref_allele == "T" & alt_allele == "C"] <- "Y"
	heterozygote_allele[ref_allele == "G" & alt_allele == "T"] <- "K"
	heterozygote_allele[ref_allele == "T" & alt_allele == "G"] <- "K"

	# loop for each individual
	for(a in 1:ncol(genotypes)) {
		genotypes[genotypes[,a] == "0/0",a] <- ref_allele[genotypes[,a] == "0/0"]
		genotypes[genotypes[,a] == "0/1",a] <- heterozygote_allele[genotypes[,a] == "0/1"]
		genotypes[genotypes[,a] == "1/1",a] <- alt_allele[genotypes[,a] == "1/1"]
		genotypes[genotypes[,a] == "./.",a] <- "?"	
	}

	if(nrow(genotypes) >= min_sites) {
		# write output
		for(a in 1:ncol(genotypes)) {
			a_name <- paste(">", individuals[a,1], sep="")
			a_genotype <- paste(genotypes[,a], collapse="")
			if(a == 1) {
				write(a_name, file=output_fasta, append=F)
				write(a_genotype, file=output_fasta, append=T)
			} else {
				write(a_name, file=output_fasta, append=T)
				write(a_genotype, file=output_fasta, append=T)
			}
		}
	}
	
}


