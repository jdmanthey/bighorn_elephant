options(scipen=999)
library(ggplot2)

# read in genotypes  
data_file <- "kinship.related"
x <- read.table(data_file, stringsAsFactors=F)
total <- x

# all dots are missing data, replace those with zeros
for(a in 2:ncol(x)) {
	x[x[,a] == ".",a] <- 0
}

# input species name and dataset
species <- "bighorn"

# estimate the R0, R1, and KING-robust kinship stats for each comparison

# first rearrange the data matrix
x_names <- total[,1]
total2 <- total[,2:ncol(total)]
total2 <- data.frame(x_names, mapply(paste0, total2[c(T,F)], total2[c(F,T)]))

# convert all genotypes to 00, 01, 11, or missing
for(a in 2:ncol(total2)) {
	total2[total2[,a] == "00",a] <- "??"	
	total2[total2[,a] == "55",a] <- "00"
	total2[total2[,a] == "51",a] <- "01"
	total2[total2[,a] == "15",a] <- "01"
}

# determine all the pairwise comparisons
comps <- t(combn(total2[,1], 2))

output <- data.frame(ind1=as.character(comps[,1]), ind2=as.character(comps[,2]))

# calculate the A, B, C, D, E, F, G, H, I categories for each pairwise comparison
AA <- list()
BB <- list()
CC <- list()
DD <- list()
EE <- list()
FF <- list()
GG <- list()
HH <- list()
II <- list()
for(a in 1:nrow(output)) {
	if(a %% 1000 == 0) { print(a) }
	a_rep <- total2[total2[,1] == comps[a,1] | total2[,1] == comps[a,2], ]
	a_rep <- t(a_rep[,2:ncol(a_rep)])
	AA[[a]] <- length(a_rep[a_rep[,1] == "00" & a_rep[,2] =="00",1])
	BB[[a]] <- length(a_rep[a_rep[,1] == "01" & a_rep[,2] =="00",1])
	CC[[a]] <- length(a_rep[a_rep[,1] == "11" & a_rep[,2] =="00",1])
	DD[[a]] <- length(a_rep[a_rep[,1] == "00" & a_rep[,2] =="01",1])
	EE[[a]] <- length(a_rep[a_rep[,1] == "01" & a_rep[,2] =="01",1])
	FF[[a]] <- length(a_rep[a_rep[,1] == "11" & a_rep[,2] =="01",1])
	GG[[a]] <- length(a_rep[a_rep[,1] == "00" & a_rep[,2] =="11",1])
	HH[[a]] <- length(a_rep[a_rep[,1] == "01" & a_rep[,2] =="11",1])
	II[[a]] <- length(a_rep[a_rep[,1] == "11" & a_rep[,2] =="11",1])
}
output <- data.frame(ind1=as.character(output$ind1), ind2=as.character(output$ind2), A=as.numeric(unlist(AA)), B=as.numeric(unlist(BB)), C=as.numeric(unlist(CC)), D=as.numeric(unlist(DD)), E=as.numeric(unlist(EE)), F=as.numeric(unlist(FF)), G=as.numeric(unlist(GG)), H=as.numeric(unlist(HH)), I=as.numeric(unlist(II)))

# calculate the R0, R1, and KING-robust kinship stats for each pairwise comparison
R0 <- (output$C + output$G) / (output$E)
R1 <- (output$E) / (output$B + output$D + output$H + output$F + output$C + output$G)
KINGrobust <- (output$E - 2 * (output$C + output$G)) / (output$B + output$D + output$H + output$F + 2 * output$E)

# add these to output
output <- cbind(output, R0, R1, KINGrobust)


# write the output
write.table(output, file=paste("output_", species, "__relatedness.txt", sep=""), sep="\t", quote=F, col.names=T, row.names=F)

# save the work
save.image(paste(species, "__relatedness.RData", sep=""))
