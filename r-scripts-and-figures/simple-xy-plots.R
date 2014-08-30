setwd("/home/ross/workspace/mygithub/homoplasy-paper")
megatable <- read.csv("./results-summary/results-in-progress.csv")
attach(megatable)
names(megatable)

plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Restriction Index (RI)", ylab="ensemble Consistency Index (CI)")

png('./r-scripts-and-figures/CIvsRI.png')
plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Restriction Index (RI)", ylab="ensemble Consistency Index (CI)")
dev.off()
