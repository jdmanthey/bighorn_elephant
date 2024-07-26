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







