library(ggplot2)
library(reshape2)
library(scales)

WES_targetbasepct <- read.csv("~/Documents/Thesis/Coverage/WES_targetbasepct.csv")
colnames(WES_targetbasepct)=c("Proband_ID","1X","2X","10X","20X","30X","40X","50X","100X")
harrypotter <- melt(WES_targetbasepct, id.vars = "Proband_ID")
ggplot(data=harrypotter, aes(x=variable, y=value, group=Proband_ID, colour=Proband_ID)) + 
  geom_line() + 
  geom_point() + 
  xlab("Depth (bp)") + 
  ylab("Target Bases (%)") + 
  scale_y_continuous(labels=percent) +
  ggtitle("WES Coverage vs. SeqCap EZ Exome v.03 Capture Target")