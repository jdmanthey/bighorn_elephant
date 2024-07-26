options(scipen=999)

n_reps <- 100

# read in admixture output for each of 100 replicates and determine if the elephant mountain population is strongly 
# structured and / or admixed

# in each file, the elephant mountain individuals will be individuals in rows 31-35

q_elephant <- c()
q_other <- c()
for(a in 1:n_reps) {
	a_rep <- read.table(paste0("admixture_plink_", a, ".8.Q"))
	
	# sum the q coefficients for the elephant mountain individuals
	elephant_q_sums <- apply(a_rep[31:35,], 2, sum)
	
	# find the column that the individuals most closely cluster with
	column_to_keep <- match(max(elephant_q_sums), elephant_q_sums)
	
	# get the mean Q value for this cluster for the elephant mountain individuals
	q_elephant <- c(q_elephant, mean(a_rep[31:35, column_to_keep]))
	
	# get the mean Q value for this cluster for all other individuals
	q_other <- c(q_other, mean(a_rep[-(31:35), column_to_keep]))
}

summary(q_elephant)
sd(q_elephant)
summary(q_other)
sd(q_other)


# plot
par(mar=c(5,5,1,1))
par(mfrow=c(1,2))
hist(q_elephant, breaks=seq(from=0,to=1,by=0.05), ylim=c(0,100), main="", xlab="Elephant Mountain Individuals Mean Q Coefficient")
hist(q_other, breaks=seq(from=0,to=1,by=0.05), ylim=c(0,100), main="", xlab="All Other Individuals Mean Q Coefficient")