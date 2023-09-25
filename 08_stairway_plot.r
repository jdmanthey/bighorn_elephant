options(scipen=999)
library(viridis)

line_colors <- mako(n = 7, alpha = 1, begin = 0.3, end = 0.7, direction = 1)[c(1,4,7)]
polygon_colors <- mako(n = 7, alpha = 0.5, begin = 0.3, end = 0.7, direction = 1)[c(1,4,7)]


em2000 <- read.table("EM2000_plot.final.summary",header=T)
em2017 <- read.table("EM2017_plot.final.summary",header=T)
em2019 <- read.table("EM2019_plot.final.summary",header=T)

# define plotting limits
x_limits <- c(5, 75)
y_limits <- c(1, 1000)

par(mfrow=c(1,3))
par(mar=c(5,5,1,1))

plot(em2000$year/1000, em2000$Ne_median/1000, log=c("xy"), type="n", xlab="Time Before Present (kya)", ylab="Effective Population Size (thousands)", xlim=x_limits, ylim=y_limits, cex.lab=1.5)

polygon(cbind(c(em2000$year/1000, rev(em2000$year/1000)), c(em2000$Ne_2.5./1000, rev(em2000$Ne_97.5./1000))), col=polygon_colors[1], border=polygon_colors[1])
lines(em2000$year/1000, em2000$Ne_median/1000,type="s",col=line_colors[1],lwd = 3)
title("EM 2000", adj=0.96, line=-1.7, cex.main=2)

plot(em2017$year/1000, em2017$Ne_median/1000, log=c("xy"), type="n", xlab="Time Before Present (kya)", ylab="Effective Population Size (thousands)", xlim=x_limits, ylim=y_limits, cex.lab=1.5)

polygon(cbind(c(em2017$year/1000, rev(em2017$year/1000)), c(em2017$Ne_2.5./1000, rev(em2017$Ne_97.5./1000))), col=polygon_colors[2], border=polygon_colors[2])
lines(em2017$year/1000, em2017$Ne_median/1000,type="s",col=line_colors[2],lwd = 3)
title("EM 2017", adj=0.96, line=-1.7, cex.main=2)

plot(em2019$year/1000, em2019$Ne_median/1000, log=c("xy"), type="n", xlab="Time Before Present (kya)", ylab="Effective Population Size (thousands)", xlim=x_limits, ylim=y_limits, cex.lab=1.5)

polygon(cbind(c(em2019$year/1000, rev(em2019$year/1000)), c(em2019$Ne_2.5./1000, rev(em2019$Ne_97.5./1000))), col=polygon_colors[3], border=polygon_colors[3])
lines(em2019$year/1000, em2019$Ne_median/1000,type="s",col=line_colors[3],lwd = 3)
title("EM 2019", adj=0.96, line=-1.7, cex.main=2)
