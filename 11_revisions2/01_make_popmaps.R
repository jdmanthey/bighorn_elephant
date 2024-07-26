options(scipen=999)

full_popmap <- scan("admixture_total_popmap.txt", what="character")

output_name_base <- "keep_admixture"
# subset the elephant mountain population and all others
elephant <- full_popmap[31:195]
everything_else <- full_popmap[c(1:30,196:200)]

# number of randomizations
n_r <- 100
# number of elephant mountain individuals 
n_e <- 5

for(a in 1:n_r) {
	a_rep <- c(everything_else, sample(elephant, 5))
	write.table(a_rep, file=paste0(output_name_base, "_", a, ".txt"), quote=F, row.names=F, col.names=F)
}