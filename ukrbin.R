## automatize species download from ukrbin
## libraries
library(stringr)
#read page, example with amphibians
amp.page<-readLines('http://www.ukrbin.com/distribution.php?action=geotaxa&geoid=182&classid=51442&sp=1')
# extract html lines with species names and id
indexphp<-amp.page[grep("index.*id=",amp.page)]
indexphp[1]
## create df with species id in ukrbin and scientific name
id <- str_match(indexphp, 'id=(.*?)"><i>')
id[,2]
names<-str_match(indexphp, '<i>(.*?)</i>')
names[,2]
df.species<-data.frame(ID=id[,2],names=names[,2])
df.occurrences<-data.frame(species=NA,lat=NA,lon=NA)
for (i in 1:nrow(df.species)) {
  url<-paste0("http://www.ukrbin.com/index.php?id=",df.species$ID[i],"&action=distribution")
  distr.url<-readLines(url)
  coords<-distr.url[grep('<td class=\"catcolumn5\" valign=\"top\".*align',distr.url)+1]
  coords<-gsub("\t","",coords)
  coords<-as.numeric(coords)
  coords<-matrix(coords[which(coords>1)],ncol=2,byrow = T)
  df.occurrences.sp<-data.frame(species=df.species$names[i],lat=coords[,1],lon=coords[,2])
  df.occurrences<-rbind(df.occurrences,df.occurrences.sp)
}

df.occurrences.amp<-df.occurrences[-1,]

##rep
rep.page<-readLines('http://www.ukrbin.com/distribution.php?action=geotaxa&geoid=182&classid=51443&sp=1')
# extract html lines with species names and id
indexphp<-rep.page[grep("index.*id=",rep.page)]
indexphp[1]
## create df with species id in ukrbin and scientific name
id <- str_match(indexphp, 'id=(.*?)"><i>')
id[,2]
names<-str_match(indexphp, '<i>(.*?)</i>')
names[,2]
df.species<-data.frame(ID=id[,2],names=names[,2])
df.occurrences.rep<-data.frame(species=NA,lat=NA,lon=NA)
for (i in 1:nrow(df.species)) {
  url<-paste0("http://www.ukrbin.com/index.php?id=",df.species$ID[i],"&action=distribution")
  distr.url<-readLines(url)
  coords<-distr.url[grep('<td class=\"catcolumn5\" valign=\"top\".*align',distr.url)+1]
  coords<-if (length(coords)==0) {NA} else {gsub("\t","",coords)}
  coords<-as.numeric(coords)
  is.logical(coords)
  coords<-if (is.na(coords)) {matrix(rep(NA,2),ncol=2) } else {matrix(coords[which(coords>1)],ncol=2,byrow = T)}
  df.occurrences.sp<-data.frame(species=df.species$names[i],lat=coords[,1],lon=coords[,2])
  df.occurrences.rep<-rbind(df.occurrences.rep,df.occurrences.sp)
}

df.occurrences.rep<-df.occurrences[-1,]
ukrbin_occ<-rbind(df.occurrences.rep,df.occurrences.amp)
ukrbin_occ<-ukrbin_occ[complete.cases(ukrbin_occ),]
ukrbin_coords<-matrix(c(ukrbin_occ$lon,ukrbin_occ$lat),ncol = 2)
ukrbin_occ_sp<-SpatialPointsDataFrame(coords = ukrbin_coords, data = ukrbin_occ, proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
ukrbin_occ_sp<-writeOGR(ukrbin_occ_sp, "C:/Users/ASUS/Desktop/phd/porto/gbif","ukrbin", driver="ESRI Shapefile")

