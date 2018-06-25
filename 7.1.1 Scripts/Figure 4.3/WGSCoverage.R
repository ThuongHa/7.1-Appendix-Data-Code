library(ggplot2)
library(reshape2)
library(scales)

WGS_targetbasepct <- read.csv("~/Documents/Thesis/Coverage/WGS_targetbasepct.csv")
colnames(WGS_targetbasepct)=c("Proband_ID","1X","2X","10X","20X","30X","40X","50X","100X")
dumbledore <- melt(WGS_targetbasepct, id.vars = "Proband_ID")
ggplot(data=dumbledore, aes(x=variable, y=value, group=Proband_ID, colour=Proband_ID)) + 
  geom_line() + 
  geom_point() + 
  xlab("Depth (bp)") + 
  ylab("Target Bases (%)") + 
  scale_y_continuous(labels=percent) +
  ggtitle("WGS Coverage vs. Hg19 Canonical Transcript ORF")