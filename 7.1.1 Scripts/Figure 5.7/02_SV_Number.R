library(ggplot2)

SV_Number <- read.csv("~/Documents/Thesis/NA12878/SV_Number.csv")
hagrid <- melt(SV_Number, id.vars = "Caller")
ggplot(data=hagrid, aes(x=Caller, y=value, colour=variable, fill=variable)) + 
  geom_bar(alpha=0.5,stat="identity", position=position_dodge()) + 
  scale_y_sqrt(breaks=c(10,50,100,500,1000,5000,10000,50000,100000)) + 
  xlab("SVCaller") + 
  ylab("Number of SV") + 
  ggtitle("Number of Structural Variants per SV Caller") + 
  labs(fill="SVtype")