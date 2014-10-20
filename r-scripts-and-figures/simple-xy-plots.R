## I'll make pretty plots with ggplot2 later, these are just quick & dirty plots to help visualise the data

setwd("/home/ross/workspace/mygithub/homoplasy-paper/")
library("plyr")
library(vioplot)

megatable <- read.csv("./results-summary/results-in-progress.csv")
attach(megatable)
names(megatable)
zz <- as.data.frame(megatable)
str(zz)
names(zz)
#colnames(zz)[23] = "mpts" #shorter names, easier to type!
#colnames(zz)[3] = "groups" #shorter names, easier to type!
#zz[4:16] <- list(NULL) #remove higher taxon columns
#zz[22:27] <- list(NULL) #delete more unwanted columns
names(zz)
summary(zz)
cor(zz)                              # correlation matrix
# pairs(zz)                           # pairwise plots
#model1 = lm(CI ~ L + MinL + mpts + informativechars + Taxa + X.missingchars, data=zz)
model1 = lm(CI ~ L + log(MinL) + log(X.mpts) + log(informativechars) + log(Taxa) + X.missingchars, data=zz)
summary(model1)
summary.aov(model1)
hist(log(informativechars)) #needs to be logged
hist(log(MinL)) #needs to be logged
hist(Taxa) #needs to be logged, mpts might need to be logged too
hist(X.mpts)
m1b = step(model1)
summary(m1b)
boxplot(residuals(model1)~groups)
plot(log(X.mpts),CI)

model2 = lm(MHER ~ L + log(MinL) + log(X.mpts) + log(informativechars) + log(Taxa) + X.missingchars, data=zz)
summary(model2)
summary.aov(model2)

boxplot(CI,as.factor(Grouping.for.statistical.tests))
zz$Grouping.for.statistical.tests

# LOTS OF PAIRWISE PLOTS
plot(MHER,Taxa,main="Taxa vs MHER", pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="Number of Taxa",xlim=c(0,1),yaxt="n")
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(0.54,225,"Daza2012",cex=1)
text(0.8,219,"Longrich2012",cex=1)
text(0.8,188,"LivezeyZusi07 + Smithea13",cex=1)
text(0.68,154,"Wagner1997",cex=1)

plot(informativechars,Taxa,main="Taxa vs Characters", pch=4,xlab="Number of Informative Characters", ylab="Number of Taxa",xlim=c(0,1100),yaxt="n", col="blue")
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(290,225,"Daza2012",cex=1)
text(700,219,"Longrich2012",cex=1)
text(800,188,"LivezeyZusi07 + Smithea13 [OFFPLOT] -> 2500+",cex=1)
text(220,154,"Wagner1997",cex=1)
text(940,72,"Naish'12",cex=1)
text(900,101,"Godefroit'13b",cex=1)

plot(MHER,CI,main="CI vs MHER", pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="ensemble Consistency Index (CI)",xlim=c(0,1))
plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Retention Index (RI)", ylab="ensemble Consistency Index (CI)")

png('./r-scripts-and-figures/pairs.png')
pairs(zz)
dev.off()

png('./r-scripts-and-figures/CIvsMHER.png')
plot(MHER,CI,main="CI vs MHER", pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="ensemble Consistency Index (CI)",xlim=c(0,1))
dev.off()

png('./r-scripts-and-figures/RIvsMHER.png')
plot(MHER,RI,main="RI vs MHER", pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="ensemble Retention Index (RI)",xlim=c(0,1))
dev.off()

png('./r-scripts-and-figures/TaxavsMHER.png')
plot(MHER,Taxa,main="Taxa vs MHER", pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="Number of Taxa",xlim=c(0,1),yaxt="n",col="blue")
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(0.54,225,"Daza2012",cex=1)
text(0.8,219,"Longrich2012",cex=1)
text(0.8,188,"LivezeyZusi07 + Smithea13",cex=1)
text(0.68,154,"Wagner1997",cex=1)
dev.off()

png('./r-scripts-and-figures/TaxavsCharacters.png')
plot(informativechars,Taxa,main="Taxa vs Characters", pch=4,xlab="Number of Informative Characters", ylab="Number of Taxa",xlim=c(0,1100),yaxt="n", col="blue")
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(290,225,"Daza2012",cex=1)
text(700,219,"Longrich2012",cex=1)
text(800,188,"Livezey07 + Smith13 [OFFPLOT] -> 2500+",cex=1)
text(220,154,"Wagner1997",cex=1)
text(940,72,"Naish'12",cex=1)
text(900,101,"Godefroit'13b",cex=1)
dev.off()


png('./r-scripts-and-figures/TaxavsRI.png')
plot(RI,Taxa,main="Taxa vs RI", pch=4,xlab="ensemble Retention Index (RI)", ylab="Number of Taxa",xlim=c(0,1))
dev.off()

png('./r-scripts-and-figures/CIvsRI.png')
plot(RI,CI,main="CI vs RI", pch=4,xlab="ensemble Retention Index (RI)", ylab="ensemble Consistency Index (CI)")
dev.off()

png('./r-scripts-and-figures/CIvsTaxa.png')
plot(Taxa,CI,main="CI vs Taxa", pch=4,xlab="Number of Taxa", ylab="ensemble Consistency Index (CI)")
dev.off()


#tutorial http://ww2.coastal.edu/kingw/statistics/R-tutorials/multregr.html

zz[c(1,7,9,10,12,13)] <- list(NULL)
zz[c(4,8)] <- list(NULL)
names(zz)
png('./r-scripts-and-figures/pairs.png')
pairs(zz)
dev.off()

#Using Hadley Wickham's 'plyr' R-package to summarise the data by group

yyy <- ddply(zz, .(Grouping.for.statistical.tests), summarise,
             size.of.group = length(CI),
             meanTaxa = mean(Taxa),
             meanChars = mean(informativechars),
             meanMPTs = mean(X.mpts),
             meanCI = mean(CI),
             meanRI = mean(RI),
             MEANmeanci = mean(meanci),
             MEANmeanri = mean(meanri),
             meanMHER = mean(MHER),
             meanBootSupport = mean(Average.GC.standard.bootstrap.support, na.rm=TRUE),
             meanJackknifeSupport = mean(average.jackknife.support, na.rm=TRUE),
             meanSymResamplingSupport = mean(Average.symmetric.resampling.support, na.rm=TRUE),
             meanPSI = mean(PSI),
             meanTSI = mean(TSI))
            
yyy

xxx <- yyy$size.of.group > 4
yyy[xxx,]

write.csv(yyy[xxx,], file = "meansbygroup.csv")

#save 1000x600 PNG
png("./r-scripts-and-figures/2plot.png", width = 1000, height = 600)
par(mfrow=c(1,2))
plot(MHER,Taxa, pch=4,xlab="Modified Homoplasy Excess Ratio (MHER)", ylab="Number of Taxa",xlim=c(0,1),yaxt="n",col="blue",cex.lab=1.4)
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(0.2,220,"N = 1224",cex=2)
text(0.49,225,"Daza2012",cex=1)
text(0.85,219,"Longrich2012",cex=1)
text(0.75,188,"Livezey2007 \n Smith2013",cex=1)
text(0.7,154,"Wagner1997",cex=1)
plot(RI,Taxa, pch=4,xlab="Retention Index (RI)", ylab="Number of Taxa",xlim=c(0,1), yaxt="n",col="blue",cex.lab=1.4)
axis(2, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(0.2,220,"N = 1224",cex=2)
text(0.6,225,"Daza2012",cex=1)
text(0.92,219,"Longrich2012",cex=1)
text(0.81,188,"Livezey2007 \n Smith2013",cex=1)
text(0.87,154,"Wagner1997",cex=1)
dev.off()

xyx <- zz$MHER <=0.275
length(zz[xyx,])

unusualMHERbig <- zz$MHER >=0.925
length(zz[unusualMHERbig,])

boxplot(zz$MHER)

