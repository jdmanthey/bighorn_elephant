library(ggplot2)
library(RColorBrewer)
options(scipen=999)



x <- read.table("phylo.simple.vcf")

individuals <- scan("keep_phylo.txt", what="character")
populations <- sapply(strsplit(individuals, "__"), "[[", 1)

# keep only genotypes
x <- x[,5:ncol(x)]


missing <- list()
for(a in 1:ncol(x)) {
	a_rep <- x[,a]
	a_rep <- length(a_rep[a_rep == "./."]) / length(a_rep)
	missing[[a]] <- a_rep
}

heterozygosity <- list()
for(a in 1:ncol(x)) {
	a_rep <- x[,a]
	a_rep <- a_rep[a_rep != "./."]
	a_rep <- length(a_rep[a_rep == "0/1"]) / length(a_rep)
	heterozygosity[[a]] <- a_rep
}

output <- data.frame(individual=as.character(individuals), missing=as.numeric(unlist(missing)), obs_het=as.numeric(unlist(heterozygosity)), population=as.character(populations))

write.table(output, file="output_missing_heterozygosity.txt", sep="\t", row.names=F, quote=F)


# reorder the pop factor levels
output$population <- factor(output$population, levels=c("DallSheep_AK", "RockyMountain_NM", "GabbsValley_NV", "FishCreek_CA", "KofaMtns_AZ", "Sonora_MEX", "BlackMtns_AZ", "MuddyMtns_NV", "Elephant2000", "Elephant2017", "Elephant2019"))

# calculate expected heterozygosity for each population with at least 5 samples
expected_heterozygosity <- rep(0, nrow(output))
for(a in 1:nrow(output)) {
	a_ind <- x[,a]
	a_pop <- as.matrix(x[,output$population == output$population[a]])
	a_pop <- as.matrix(a_pop[a_ind != "./.",])
	a_ind <- a_ind[a_ind != "./."]
	if(ncol(a_pop) >= 5) {
		# get sample sizes and allele frequencies for each snp
		sample_sizes <- rep(0, nrow(a_pop))
		p <- rep(0, nrow(a_pop)) 
		for(b in 1:nrow(a_pop)) {
			b_rep <- a_pop[b,]
			b_rep <- b_rep[b_rep != "./."]
			sample_sizes[b] <- length(b_rep) * 2
			p[b] <- (length(b_rep[b_rep == "0/0"]) * 2 + length(b_rep[b_rep == "0/1"])) / sample_sizes[b]
		}
		expected_heterozygosity[a] <- mean(sample_sizes / (sample_sizes - 1) * (1 - p^2 - (p-1)^2))
	} else {
		expected_heterozygosity[a] <- NA
	}
}

# calculate inbreeding coefficient for all individuals with expected heterozygosity values
exp_het <- expected_heterozygosity
inbreeding <- (exp_het - output$obs_het) / exp_het

output <- cbind(output, exp_het, inbreeding)

write.table(output, file="output_missing_heterozygosity.txt", sep="\t", row.names=F, quote=F)

save.image("_het.Rdata")

# plot colors
plot_colors <- colorRampPalette(brewer.pal(8, "Dark2"))(10)

theme_set(theme_minimal())

ggplot(output[2:196,], aes(x=population, y= obs_het, color=population)) + geom_jitter(position = position_jitter(width = .2), size=1.5) + scale_color_manual(values=plot_colors) + expand_limits(y=0) + coord_flip() + theme(legend.position = "none")

ggplot(output[2:196,], aes(x=population, y= inbreeding, color=population)) + geom_jitter(position = position_jitter(width = .2), size=1.5) + scale_color_manual(values=plot_colors) + expand_limits(y=0) + coord_flip() + theme(legend.position = "none")


# anova and tukey test for differences in time between Elephant Mountain populations
elephant <- output[output$population == "Elephant2019" | output$population == "Elephant2017" | output$population == "Elephant2000", ]
anova_output <- aov(obs_het ~ population, data=elephant)
summary(anova_output)
tukey <- TukeyHSD(anova_output)
tukey <- tukey$population
tukey <- tukey[order(tukey[,4]),]
tukey

write.table(tukey, file="output_tukeyHSD.txt")



