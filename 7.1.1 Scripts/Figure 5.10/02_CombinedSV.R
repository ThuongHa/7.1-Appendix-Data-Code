library (ggplot2)
library (reshape2)
library (scales)

combinedSV <- read.csv("~/Documents/Thesis/NA12878/combinedSV.csv")
hermione <- melt(combinedSV, measure.vars = c('TruePositive','FalseNegative','Precision'))
ggplot(data=hermione, aes(x=Callset, y=value, fill=variable, colour=variable)) +
  geom_bar(alpha=0.5,stat="identity", position=position_dodge()) +
  facet_wrap(~ Truthset, scales="free_x") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab("Percentage") +
  xlab("Callset") +
  scale_y_continuous(labels=percent) +
  ggtitle("Combined SV Callers: True Positive vs False Negative")