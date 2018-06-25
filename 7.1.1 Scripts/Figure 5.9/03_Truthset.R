library(ggplot2)
library(reshape2)
library(scales)

NA12878_intersect <- read.csv("~/Documents/Thesis/scripts/NA12878_intersect.csv")

snape <- melt(NA12878_intersect_4col, measure.vars = c('Sensitivity','Precision'))
ggplot(data=snape, aes(x=Callset, y=value, fill=variable)) + 
  geom_bar(alpha=0.5,stat="identity", position=position_dodge()) + 
  facet_wrap(~ Truthset, scales="free_x") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Percentage") +
  xlab("Callset") +
  scale_y_continuous(labels=percent) +
  ggtitle("Sensitivity & Precision of SV Callers across NA12878 Truthset")