options(scipen=999)
library(ggplot2)
library(RColorBrewer)


x <- read.table("output_bighorn__relatedness.txt", header=T)

# pull out all comparisons inferred parent-offspring or full sibs
x_PO <- x[x$R0 <= 0.02 & x$KINGrobust >= 0.2, ]
x_sibs <- x[x$R0 > 0.02 & x$KINGrobust >= 0.2, ]

# write these to tables
write.table(x_PO, file="output_predicted_parent-offsrpring.txt", sep="\t", row.names=F, quote=F)
write.table(x_sibs, file="output_predicted_full-siblings.txt", sep="\t", row.names=F, quote=F)


par(mar=c(4.5,4.5,1,1))
par(mfrow=c(1,2))
plot_colors <- brewer.pal(12, "Paired") # plot colors

	a_PO <- x[x$R0 <= 0.02 & x$KINGrobust >= 0.2, ]
	a_sibs <- x[x$R0 > 0.02 & x$KINGrobust >= 0.2, ]
	a_partly <- x[x$KINGrobust >= 0.1 & x$KINGrobust < 0.2, ]
	a_not_closely_related <- x[x$KINGrobust < 0.1, ]
	
	plot(a_not_closely_related$R1, a_not_closely_related$R0, xlim=c(min(x$R1), max(x$R1)), ylim=c(min(x$R0), 0.5), pch=19, cex=0.4, xlab="R1", ylab="R0", col=plot_colors[7])
	points(a_PO$R1, a_PO$R0, pch=19, cex=0.4, col=plot_colors[10])
	points(a_sibs$R1, a_sibs$R0, pch=19, cex=0.4, col=plot_colors[2])
	points(a_partly$R1, a_partly$R0, pch=19, cex=0.4, col=plot_colors[4])
	plot(a_not_closely_related$R1, a_not_closely_related$KINGrobust, xlim=c(min(x$R1), max(x$R1)), ylim=c(0, max(x$KINGrobust)), pch=19, cex=0.4, xlab="R1", ylab="KING-robust Kinship", col=plot_colors[7])
	points(a_PO$R1, a_PO$KINGrobust, pch=19, cex=0.4, col=plot_colors[10])
	points(a_sibs$R1, a_sibs$KINGrobust, pch=19, cex=0.4, col=plot_colors[2])
	points(a_partly$R1, a_partly$KINGrobust, pch=19, cex=0.4, col=plot_colors[4])







