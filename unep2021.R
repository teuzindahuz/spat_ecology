library(raster)
library(ggplot2)
library(viridis)

csbasin<-raster('C:/Users/mlatt/OneDrive/Desktop/unep/maskCS.tif')
plot(csbasin)
??`aggregate,Raster-method`
csbasinAgg<-aggregate(csbasin,c(16,16),fun=mean)
plot(csbasinAgg)
writeRaster(csbasinAgg,'C:/Users/mlatt/OneDrive/Desktop/unep/CSopt1.tif')

sum(csbasinAgg[] >= -38 & csbasinAgg[] <= 23,na.rm=T)* (res(csbasinAgg)[1]*81)*(res(csbasinAgg)[1]*111)

intervals <- list(c(-38,23))
for (i in 1:199){intervals <-c(intervals,list(c(-38,23)-i))}

                  

suboptim0_62<-sapply(intervals, function(x) { 
  sum(csbasinAgg[] >= x[1] & csbasinAgg[] <= x[2],na.rm=T)*(res(csbasinAgg)[1]*81)*(res(csbasinAgg)[1]*111)
})

intervalsOpt <- list(c(-38,-7))
for (i in 1:199){intervalsOpt <-c(intervalsOpt,list(c(-38,-7)-i))}

optim31_62<-sapply(intervalsOpt, function(x) { 
  sum(csbasinAgg[] >= x[1] & csbasinAgg[] <= x[2],na.rm=T)*(res(csbasinAgg)[1]*81)*(res(csbasinAgg)[1]*111)
})

df<-data.frame(sl=c(23:-176),area=suboptim0_62,type="suboptim")
df<-rbind(df,data.frame(sl=c(23:-176),area=optim31_62,type="optim"))

ggplot(data=df, aes(x=sl, y=area, group=type)) +
  geom_line(aes(color=type))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))

# SVG graphics device
svg("csOptimHab.svg")

# Code of the plot
ggplot(data=df, aes(x=sl, y=area, group=type)) +
  geom_line(aes(color=type))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Close the graphics device
dev.off() 

114.31/50
2.28*27
