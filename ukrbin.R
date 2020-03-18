#### automatize species download from ukrbin
## libraries
library(stringr)
##read page, example with amphibians
amp.page<-readLines('http://www.ukrbin.com/distribution.php?action=geotaxa&geoid=182&classid=51442&sp=1') #the http is the 
#page of the species of interest

## extract html lines with species names and id
indexphp<-amp.page[grep("index.*id=",amp.page)]
indexphp[1]

## create df with species id in ukrbin and scientific name
id <- str_match(indexphp, 'id=(.*?)"><i>')
id[,2]
names<-str_match(indexphp, '<i>(.*?)</i>')
names[,2]
df.species<-data.frame(ID=id[,2],names=names[,2])
## use the species ID to fetch URL of species of interest
df.occurrences<-data.frame(species=NA,lat=NA,lon=NA)
for (i in 1:nrow(df.species)) {
  url<-paste0("http://www.ukrbin.com/index.php?id=",df.species$ID[i],"&action=distribution")
  distr.url<-readLines(url)
  coords<-distr.url[grep('<td class=\"catcolumn5\" valign=\"top\".*align',distr.url)+1] #string to extract species coordinates
  coords<-gsub("\t","",coords)
  coords<-as.numeric(coords)
  coords<-coords[which(coords>1)]
  coords<-matrix(coords,ncol=2,byrow = T)
  df.occurrences.sp<-data.frame(species=df.species$names[i],lat=coords[,1],lon=coords[,2])
  df.occurrences<-rbind(df.occurrences,df.occurrences.sp)
}
