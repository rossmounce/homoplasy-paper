## I'll make pretty plots with ggplot2 later, these are just quick & dirty plots to help visualise the data

setwd("/home/ross/workspace/mygithub/homoplasy-paper")
megatable <- read.csv("./results-summary/results-in-progress.csv")
attach(megatable)
names(megatable)

plot(MHER,CI,main="CI vs MHER", pch=4,xlab="mod. Homoplasy Excess Ratio", ylab="ensemble Consistency Index (CI)",xlim=c(0,1))

plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Restriction Index (RI)", ylab="ensemble Consistency Index (CI)")

png('./r-scripts-and-figures/CIvsMHER.png')
plot(MHER,CI,main="CI vs MHER", pch=4,xlab="mod. Homoplasy Excess Ratio", ylab="ensemble Consistency Index (CI)",xlim=c(0,1))
dev.off()

png('./r-scripts-and-figures/CIvsRI.png')
plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Restriction Index (RI)", ylab="ensemble Consistency Index (CI)")
dev.off()
