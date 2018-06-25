library(ggplot2)

WES_WGS_NoCov <- read.csv("~/Documents/Thesis/Coverage/WES_WGS_NoCov.csv")
ronweasley <- melt(WES_WGS_NoCov, id.vars = "Sequencing")
rw <- ggplot(ronweasley, aes(x=Sequencing, y=value))
rw + geom_boxplot(alpha=0.5,aes(fill=variable)) + 
  facet_grid(variable ~ ., scales ='free_y') +  
  ggtitle("WES & WGS vs. No Coverage (0bp) Regions") + 
  xlab("Sequencing Platform") + 
  ylab("Number of Regions") + 
  labs(fill = "Flanking Sequences")