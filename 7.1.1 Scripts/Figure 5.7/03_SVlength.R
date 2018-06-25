library(ggplot2)

NA12878_svlength <- read.csv("~/Documents/Thesis/NA12878/NA12878_svlength.csv")
hermionegranger <- ggplot(NA12878_svlength, aes(x=SVcaller, y=SVlength))
hermionegranger + 
  geom_boxplot(alpha=0.5,aes(fill=SVtype),outlier.size=0.1) + 
  facet_grid(SVtype ~., scale="free_y") + 
  scale_y_log10() +
  ggtitle("Differences in SV length: SV Caller versus SV type")