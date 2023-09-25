options(scipen=999)

library(ggplot2)
library(RColorBrewer)

eigenvals <- scan("structure_plink_pca.eigenval")
eigenvals_adj <- eigenvals / sum(eigenvals)

pca_bighorn <- read.table("structure_plink_pca.eigenvec")
pca_bighorn <- pca_bighorn[,c(1,3,4,5,6)]
colnames(pca_bighorn) <- c("ID", "PC1", "PC2", "PC3", "PC4")

populations <- sapply(strsplit(pca_bighorn[,1], "__"), "[[", 1)
populations_unique <- unique(populations)
populations_non_elephant <- populations_unique[c(1,2,3,4,5,9)]

par(mfrow=c(1,2))
par(mar=c(5, 5, 1, 1))
par(lwd=1)

plot_colors1 <- brewer.pal(n = 8, name = "Dark2")[c(1,2,3,4,5,7,6)]

plot(pca_bighorn[,2:3], pch=19, cex=0.1, xlab="PC1 (17.8% Variance)", ylab="PC2 (11.6% Variance)")
for(a in 1:length(populations_non_elephant)) {
points(pca_bighorn[populations == populations_non_elephant[a],2:3], bg=plot_colors1[a], col="black", pch=21, cex=1.4)
}
points(pca_bighorn[populations == "Elephant2019",2:3], bg=plot_colors1[7], col="black", pch=21, cex=1.4)
points(pca_bighorn[populations == "Elephant2017",2:3], bg=plot_colors1[7], col="black", pch=21, cex=1.4)
points(pca_bighorn[populations == "Elephant2000",2:3], bg=plot_colors1[7], col="black", pch=21, cex=1.4)

plot_colors2 <- brewer.pal(n = 12, name = "Paired")[c(1,3,7)]

plot(pca_bighorn[populations == "Elephant2019" | populations == "Elephant2017" | populations == "Elephant2000",2:3], pch=19, cex=0.1, xlab="PC1 (17.8% Variance)", ylab="PC2 (11.6% Variance)")
points(pca_bighorn[populations == "Elephant2019",2:3], bg=plot_colors2[3], col="black", pch=21, cex=1.4)
points(pca_bighorn[populations == "Elephant2017",2:3], bg=plot_colors2[2], col="black", pch=22, cex=1.4)
points(pca_bighorn[populations == "Elephant2000",2:3], bg=plot_colors2[1], col="black", pch=23, cex=1.4)



# read in admixture results desert bighorn
admixture2 <- read.table("structure_plink.2.Q")
admixture3 <- read.table("structure_plink.3.Q")
admixture4 <- read.table("structure_plink.4.Q")
admixture5 <- read.table("structure_plink.5.Q")
admixture6 <- read.table("structure_plink.6.Q")
admixture7 <- read.table("structure_plink.7.Q")

# population plot order
# GabbsValley_NV, FishCreek_CA, KofaMtns_AZ, Sonora_MEX, BlackMtns_AZ, MuddyMtns_NV, Elephant
populations2 <- populations
populations2[populations2 == "Elephant2000"] <- "Elephant"
populations2[populations2 == "Elephant2017"] <- "Elephant"
populations2[populations2 == "Elephant2019"] <- "Elephant"
populations_unique <- unique(populations2)
populations_unique <- populations_unique[c(2, 7, 1, 5, 4, 3, 6)]

# determine order of individuals
ordered_inds <- c()
for(a in 1:length(populations_unique)) {
	ordered_inds <- c(ordered_inds, seq(from=1, to=length(populations), by=1)[populations2 == populations_unique[a]])
}
individual_order <- pca_bighorn[ordered_inds,1]
admixture2 <- admixture2[ordered_inds, ]
admixture3 <- admixture3[ordered_inds, ]
admixture4 <- admixture4[ordered_inds, ]

# determine order of clusters for plotting
# first, plot them all basically to check
par(mfrow=c(3, 1))
par(mar=c(0.1, 0.1, 0.1, 0.1))
par(lwd=0.5)
plot_colors <- brewer.pal(n = 8, name = "Dark2")[c(6,2,7,1,8,5,4)]
admixture3 <- admixture3[,c(1,2,3)]
admixture4 <- admixture4[,c(1,2,3,4)]
barplot(t(admixture2), col=plot_colors, yaxt="n", xaxt="n")
barplot(t(admixture3[,c(1,2,3)]), col=plot_colors, yaxt="n", xaxt="n")
barplot(t(admixture4[,c(1,2,3,4)]), col=plot_colors, yaxt="n", xaxt="n")








