## I'll make pretty plots with ggplot2 later, these are just quick & dirty plots to help visualise the data

setwd("/home/ross/workspace/mygithub/homoplasy-paper/")
library("plyr")
library("vioplot")

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
plot(Taxa,MHER, pch=4,ylab="Modified Homoplasy Excess Ratio (MHER)", xlab="Number of Taxa",ylim=c(0,1),xaxt="n",col="blue",cex.lab=1.4)
axis(1, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(180,0.1,"N = 1224",cex=2)
text(212,0.51,"Daza2012",cex=1,srt=45)
text(210,0.75,"Longrich2012",cex=1)
text(188,0.55,"Livezey2007 \n Smith2013",cex=1,srt=45)
text(150,0.51,"Wagner1997",cex=1,srt=45)
plot(Taxa,RI, pch=4,ylab="Retention Index (RI)", xlab="Number of Taxa",ylim=c(0,1), xaxt="n",col="blue",cex.lab=1.4)
axis(1, at=c(0,20,40,60,80,100,120,140,160,180,200,220),)
text(180,0.1,"N = 1224",cex=2)
text(217,0.65,"Daza2012",cex=1,srt=45)
text(210,0.83,"Longrich2012",cex=1)
text(180,0.6,"Livezey2007 \n Smith2013",cex=1,srt=45)
text(154,0.7,"Wagner1997",cex=1,srt=45)
dev.off()

png('./r-scripts-and-figures/CIvsTaxa.png', width = 1000, height = 600)
plot(CI,Taxa, pch=4,ylab="Number of Taxa", xlab="Consistency Index (CI)")
dev.off()

xyx <- zz$MHER <=0.275
zz[xyx,]

unusualMHERbig <- zz$MHER >=0.925
zz[unusualMHERbig,]

boxplot(zz$MHER,zz$RI,zz$CI)
vioplot(zz$MHER,zz$RI,zz$CI, names=c("MHER", "RI", "CI"), 
        col="gold")

png("./r-scripts-and-figures/2plot.png", width = 1000, height = 600)
par(mfrow=c(1,1))
plot(informativechars,MHER,pch=4,xlab="Number of Informative Characters", ylab="Modified Homoplasy Excess Ratio",xlim=c(0,1100), col="blue")
dev.off()

logci <- abs(log10(CI))
logci
vioplot(logci)
Taxa
flogtaxa <- log10(Taxa)
flogtaxa
vioplot(flogtaxa)
logreg2 <- lm(logci~logtaxa*log(informativechars)*X.missingchars)
logreg2
summary(logreg2)
anova(logreg2)
plot(flogtaxa,-logci,xlim=c(0.5,2.5)) #correct!
abline(logreg2)
plot(logreg2)

plot(Taxa,logci,pch=4,xlab="Taxa", ylab="Consistency Index", xlim=c(0,130), col="blue")
summary(logci)
png("./r-scripts-and-figures/CIvChars.png", width = 1000, height = 600)
par(mfrow=c(2,1))
reg1 <- lm((CI~(log(Taxa))*(log(informativechars))*(log(X.missingchars)))) #interaction term
reg2 <- lm(CI~log(Taxa)*log(informativechars)*X.missingchars) #no interaction
reg3 <- lm(logci~log(Taxa)*log(informativechars)*X.missingchars) #no interaction
summary(reg1)
summary(reg2)
summary(reg3)
par(mfrow=c(1,1))
plot(reg2)
logci
svg("plots.svg")
par(mfrow=c(2,1),oma=c(0,0,0,0),mar=c(4,4,1,1))
plot(Taxa,CI,pch=4,xlab="Number of Taxa", ylab="Consistency Index", xlim=c(0,130), col="blue")
plot(log10(Taxa),log10(CI),pch=4,xlab="log(Number of Taxa)", ylab="log(Consistency Index)", xlim=c(0.5,2.5), col="blue")
#abline(-reg3)
#abline(reg2)
#abline(a=0.894, b=-0.456) # Sanderson's 1989 estimate 0.90 -0.022
dev.off()

vioplot(X.missingchars)
#MWU number of Taxa of MHER groups
lowMHER<-c(4,19,14,25,38,8,10,17,27,25,12,28,26,12,22,43,40,12,8,9,24,22,6,21,26,15,18,26,12,12,10,16,11,47,46,36,9,22,36,35,23,18,11,13,9,9)
highMHERtaxa <-c(36,22,63,18,14,12,8,11,44,11,19,12,50,11,16,45,11,16,14,12,13,66,15,10,17,31,11,19,32,19,12,7,12,35,33,8,12,12,21,47,11,14,9,28,35,35,12,60,8,15,37,16,55,37,19,25,15,34,40,20,33,33,34,12,15,8,13,36,10,14,12,66,66,14,74,10,12,13,15,17,25,18,12,37,14,32,23,13,33,30,15,14,33,15,27,20,15,11,12,14,23,18,70,17,51,36,14,5,17,15,54,37,14,40,12,10,20,17,26,42,41,68,18,19,44,14,12,17,101,22,71,24,14,16,25,14,18,24,24,25,19,33,25,18,19,46,19,22,44,72,10,46,17,31,19,17,18,114,20,97,114,21,18,19,72,25,26,46,9,18,45,15,14,45,12,20,21,8,24,79,79,20,27,15,15,24,17,15,27,30,27,52,10,33,51,24,15,10,13,15,9,26,23,35,18,54,100,32,24,29,99,23,29,20,23,27,54,94,13,39,30,100,15,20,23,7,21,38,32,103,20,8,33,24,24,10,29,10,86,22,22,27,24,23,24,15,44,14,6,35,17,27,47,17,28,51,43,48,38,80,60,39,45,37,12,24,22,14,38,67,60,21,37,36,10,26,34,45,21,47,64,26,14,36,19,10,14,30,18,11,13,13,50,20,14,21,38,20,10,17,11,33,36,36,23,19,38,24,24,36,28,28,34,37,37,35,17,16,45,56,44,55,34,15,9,85,41,26,19,8,45,18,14,32,35,46,33,16,56,27,37,21,15,26,45,18,8,54,14,48,10,18,58,27,21,54,39,29,14,48,102,102,102,22,31,26,52,35,19,25,14,55,12,14,14,32,10,23,51,15,11,11,26,89,23,14,11,35,30,24,85,46,19,31,8,47,30,13,19,64,20,34,32,12,56,53,18,39,51,20,46,46,33,46,19,50,22,28,18,37,35,24,33,18,23,34,75,33,25,15,19,9,45,54,32,32,12,19,12,7,50,57,19,62,27,61,26,13,31,16,13,23,43,31,44,58,45,14,48,32,24,33,37,47,76,14,18,70,77,43,37,15,14,26,71,70,77,47,30,27,26,17,30,76,27,69,154,13,36,24,46,15,21,47,9,35,53,46,47,27,40,52,20,27,61,17,16,9,72,12,42,22,34,72,29,45,61,77,44,19,27,19,51,16,42,18,21,28,39,16,22,225,35,59,31,26,13,26,36,11,59,58,89,88,59,19,41,52,20,20,27,45,58,57,51,64,18,58,20,11,30,20,23,27,23,32,29,50,9,71,35,43,28,21,20,70,19,35,88,27,57,67,9,18,9,26,26,30,10,21,12,11,48,20,11,17,8,19,30,20,17,18,27,76,15,9,16,33,34,10,11,11,8,9,12,55,39,19,47,20,56,22,57,60,57,22,21,22,28,50,50,50,47,30,22,29,63,13,14,15,76,50,50,46,27,54,16,30,189,36,62,16,15,188,38,60,8,11,30,18,12,30,95,91,25,8,88,48,10,13,19,37,20,15,14,18,20,7,47,89,89,13,33,90,19,14,14,65,53,30,29,117,15,20,117,18,34,12,47,18,18,8,37,19,15,87,33,16,10,17,32,34,28,12,88,28,27,20,40,15,22,100,10,87,10,45,56,59,29,85,46,20,29,20,100,18,18,86,51,21,51,46,46,80,61,10,36,26,85,19,44,27,57,25,7,26,19,21,61,57,23,14,61,44,11,25,34,37,17,51,23,13,27,31,23,26,30,6,12,53,52,26,39,59,7,29,57,15,22,67,48,16,49,16,30,17,60,16,51,50,56,58,55,24,24,33,107,89,90,19,31,50,32,35,84,17,31,21,49,18,13,25,16,41,20,11,25,32,22,14,16,49,12,18,37,81,32,50,48,33,61,68,24,14,14,17,20,26,49,49,34,21,49,48,30,25,80,21,81,13,25,31,11,27,39,82,24,80,84,30,33,57,53,31,39,12,80,37,16,82,11,9,17,28,30,66,66,30,21,70,11,58,38,9,13,10,30,50,51,30,11,37,23,62,30,25,8,31,16,15,10,30,30,32,9,30,20,8,37,20,14,29,30,11,30,8,30,8,46,30,17,24,31,29,50,11,24,18,30,29,219,25,9,19,33,68,20,81,21,9,13,24,9,7,29,20,63,17,40,27,25,25,20,62,33,14,11,23,7,66,25,13,11,62,9,24,15,11,43,33,70,19,22,20,16,33,10,21,17,62,34,61,61,32,17,62,14,34,8,104,109,15,24,21,32,24,18,13,110,19,70,21,8,17,108,34,21,15,37,16,15,33,33,32,15,80,80,82,11,24,13,85,12,25,10,23,7,19,26,27,19,24,27,14,24,14,14,23,22,8,18,24,8,14,13,18,50,14,14,11,14,36,11,21,11,14,59,10,33,12,11,9,9,35,86,15,34,49,50,15,12,8,28,17,10,13,9,12,7,24,24,18,9,8,53,12,8,20,25,47,6,22,10,8,40,8,9,8,8,13,44,19,45,16,13,17,15,15,15,11,8,19,24,9,9,8,12,34,35,18,33,18,18,19,8,13,7,53,16,13,16,42,22,15,11,11,12,30,10,9,18,13,18,19,11,7,15,8,23,23,16,7,16,19,13,8,16,15,9,22,11,22,11,16,8,19,21,35,8,14,7,6,19,14,11,11,8,8,6,10,6,9,5,10,7,6,9,7)
wilcox.test(lowMHER,highMHERtaxa)
midMHERtaxa<-c(36,22,63,18,14,12,8,11,44,11,19,12,50,11,16,45,11,16,14,12,13,66,15,10,17,31,11,19,32,19,12,7,12,35,33,8,12,12,21,47,11,14,9,28,35,35,12,60,8,15,37,16,55,37,19,25,15,34,40,20,33,33,34,12,15,8,13,36,10,14,12,66,66,14,74,10,12,13,15,17,25,18,12,37,14,32,23,13,33,30,15,14,33,15,27,20,15,11,12,14,23,18,70,17,51,36,14,5,17,15,54,37,14,40,12,10,20,17,26,42,41,68,18,19,44,14,12,17,101,22,71,24,14,16,25,14,18,24,24,25,19,33,25,18,19,46,19,22,44,72,10,46,17,31,19,17,18,114,20,97,114,21,18,19,72,25,26,46,9,18,45,15,14,45,12,20,21,8,24,79,79,20,27,15,15,24,17,15,27,30,27,52,10,33,51,24,15,10,13,15,9,26,23,35,18,54,100,32,24,29,99,23,29,20,23,27,54,94,13,39,30,100,15,20,23,7,21,38,32,103,20,8,33,24,24,10,29,10,86,22,22,27,24,23,24,15,44,14,6,35,17,27,47,17,28,51,43,48,38,80,60,39,45,37,12,24,22,14,38,67,60,21,37,36,10,26,34,45,21,47,64,26,14,36,19,10,14,30,18,11,13,13,50,20,14,21,38,20,10,17,11,33,36,36,23,19,38,24,24,36,28,28,34,37,37,35,17,16,45,56,44,55,34,15,9,85,41,26,19,8,45,18,14,32,35,46,33,16,56,27,37,21,15,26,45,18,8,54,14,48,10,18,58,27,21,54,39,29,14,48,102,102,102,22,31,26,52,35,19,25,14,55,12,14,14,32,10,23,51,15,11,11,26,89,23,14,11,35,30,24,85,46,19,31,8,47,30,13,19,64,20,34,32,12,56,53,18,39,51,20,46,46,33,46,19,50,22,28,18,37,35,24,33,18,23,34,75,33,25,15,19,9,45,54,32,32,12,19,12,7,50,57,19,62,27,61,26,13,31,16,13,23,43,31,44,58,45,14,48,32,24,33,37,47,76,14,18,70,77,43,37,15,14,26,71,70,77,47,30,27,26,17,30,76,27,69,154,13,36,24,46,15,21,47,9,35,53,46,47,27,40,52,20,27,61,17,16,9,72,12,42,22,34,72,29,45,61,77,44,19,27,19,51,16,42,18,21,28,39,16,22,225,35,59,31,26,13,26,36,11,59,58,89,88,59,19,41,52,20,20,27,45,58,57,51,64,18,58,20,11,30,20,23,27,23,32,29,50,9,71,35,43,28,21,20,70,19,35,88,27,57,67,9,18,9,26,26,30,10,21,12,11,48,20,11,17,8,19,30,20,17,18,27,76,15,9,16,33,34,10,11,11,8,9,12,55,39,19,47,20,56,22,57,60,57,22,21,22,28,50,50,50,47,30,22,29,63,13,14,15,76,50,50,46,27,54,16,30,189,36,62,16,15,188,38,60,8,11,30,18,12,30,95,91,25,8,88,48,10,13,19,37,20,15,14,18,20,7,47,89,89,13,33,90,19,14,14,65,53,30,29,117,15,20,117,18,34,12,47,18,18,8,37,19,15,87,33,16,10,17,32,34,28,12,88,28,27,20,40,15,22,100,10,87,10,45,56,59,29,85,46,20,29,20,100,18,18,86,51,21,51,46,46,80,61,10,36,26,85,19,44,27,57,25,7,26,19,21,61,57,23,14,61,44,11,25,34,37,17,51,23,13,27,31,23,26,30,6,12,53,52,26,39,59,7,29,57,15,22,67,48,16,49,16,30,17,60,16,51,50,56,58,55,24,24,33,107,89,90,19,31,50,32,35,84,17,31,21,49,18,13,25,16,41,20,11,25,32,22,14,16,49,12,18,37,81,32,50,48,33,61,68,24,14,14,17,20,26,49,49,34,21,49,48,30,25,80,21,81,13,25,31,11,27,39,82,24,80,84,30,33,57,53,31,39,12,80,37,16,82,11,9,17,28,30,66,66,30,21,70,11,58,38,9,13,10,30,50,51,30,11,37,23,62,30,25,8,31,16,15,10,30,30,32,9,30,20,8,37,20,14,29,30,11,30,8,30,8,46,30,17,24,31,29,50,11,24,18,30,29,219,25,9,19,33,68,20,81,21,9,13,24,9,7,29,20,63,17,40,27,25,25,20,62,33,14,11,23,7,66,25,13,11,62,9,24,15,11,43,33,70,19,22,20,16,33,10,21,17,62,34,61,61,32,17,62,14,34,8,104,109,15,24,21,32,24,18,13,110,19,70,21,8,17,108,34,21,15,37,16,15,33,33,32,15,80,80,82,11,24,13,85,12,25,10,23,7,19,26,27,19,24,27,14,24,14,14,23,22,8,18,24,8,14,13,18,50,14,14,11,14,36,11,21,11,14,59,10,33,12,11,9,9,35,86,15,34,49,50,15,12,8,28,17,10,13,9,12,7,24,24,18,9,8,53,12,8,20,25,47,6,22,10,8,40,8,9,8,8,13,44,19,45,16,13,17,15,15,15,11,8,19,24,9,9,8,12,34,35,18,33,18,18,19,8,13,7,53,16,13,16,42,22,15,11,11,12,30,10,9,18,13,18,19,11,7,15,8,23,23,16,7,16,19,13,8,16)
extremeMHERtaxa<-c(4,19,14,25,38,8,10,17,27,25,12,28,26,12,22,43,40,12,8,9,24,22,6,21,26,15,18,26,12,12,10,16,11,47,46,36,9,22,36,35,23,18,11,13,9,9,15,9,22,11,22,11,16,8,19,21,35,8,14,7,6,19,14,11,11,8,8,6,10,6,9,5,10,7,6,9,7)
wilcox.test(midMHERtaxa,extremeMHERtaxa)
median(midMHERtaxa)
median(extremeMHERtaxa)
vioplot(CI)
vioplot(RI)
shapiro.test(RI)
mean(CI)
mean(informativechars)
summary(zz$Average.GC.standard.bootstrap.support)
write.csv(megasumm, file='megasumm.csv')


#cor.test(MHER,Average.GC.standard.bootstrap.support, method = c("spearman"))
#Go with Kendall because there are ties
cor.test(MHER,Average.GC.standard.bootstrap.support, method = c("kendall"))
cor.test(MHER,average.jackknife.support, method = c("kendall"))
cor.test(MHER,Average.symmetric.resampling.support, method = c("kendall"))

par(mfrow=c(1,1))
plot(MHER,Average.GC.standard.bootstrap.support,pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="GC Bootstrap Support", col="blue")
plot(MHER,average.jackknife.support)
plot(MHER,Average.symmetric.resampling.support,pch=4,xlab="Modified Homoplasy Excess Ratio", ylab="Symmetric Resampling Support", col="blue")
plot(Average.GC.standard.bootstrap.support,Average.symmetric.resampling.support,pch=4,xlab="GC Bootstrap Support", ylab="Symmetric Resampling Support", col="blue")
plot(Average.GC.standard.bootstrap.support,average.jackknife.support,pch=4,xlab="GC Bootstrap Support", ylab="Jackknife Support", col="blue")

par(mfrow=c(2,1),oma=c(0,0,0,0),mar=c(4,5,1,1))
plot(Average.GC.standard.bootstrap.support,Average.symmetric.resampling.support,pch=4,xlab="GC Bootstrap Support", ylab="Symmetric Resampling Support", col="blue")
plot(Average.GC.standard.bootstrap.support,average.jackknife.support,pch=4,xlab="GC Bootstrap Support", ylab="Jackknife Support", col="blue")

summary(average.jackknife.support)

png("./r-scripts-and-figures/CIvYears.png", width = 1000, height = 600)
plot(Year.Published,CI,pch=4,xlab="Year of Publication", ylab="Consistency Index", col="blue")
regres <- lm(CI~Year.Published)
abline(regres)
dev.off()

summary(regres)

cor.test(Average.GC.standard.bootstrap.support, Average.symmetric.resampling.support, method = c("kendall")) 
citation(plyr)
