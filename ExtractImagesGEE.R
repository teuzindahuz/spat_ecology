# Christine

# initialize gee
library(rgee)
library(sf)

ee_Initialize(email = 'ndef', drive = TRUE) # the email is your personal one


# extract date from the list of information provided

listNames<-read.table("C:/Users/mlatt/postdoc/Christine/imagesInfo.txt",sep = " ")
listNames<-listNames[grep("name",listNames)]

#convert to date then back to character because the gee function is not accepting dates
firstDay<-as.Date(paste0(substr(listNames,17,20),"-",substr(listNames,21,22),"-",substr(listNames,23,24)))
secondDay<-firstDay+1
firstDay<-as.character(firstDay) 
secondDay<-as.character(secondDay)

# create ROI to filter specific tiles
rlist <- list(xmin = 417000 , xmax = 424000 ,ymin = 5952200, ymax =5961000 )
ROI <- c(rlist$xmin, rlist$ymin,
         rlist$xmax, rlist$ymin,
         rlist$xmax, rlist$ymax,
         rlist$xmin, rlist$ymax,
         rlist$xmin, rlist$ymin)

ee_ROI <- matrix(ROI, ncol = 2, byrow = TRUE) %>%
  list() %>%
  st_polygon() %>%
  st_sfc() %>%
  st_set_crs(32632) %>%
  sf_as_ee()

# create ROI for clipping
rlistClip <- list(xmin = 411000 , xmax = 424000 ,ymin = 5952200, ymax =5961000 )
ROIClip <- c(rlistClip$xmin, rlistClip$ymin,
         rlistClip$xmax, rlistClip$ymin,
         rlistClip$xmax, rlistClip$ymax,
         rlistClip$xmin, rlistClip$ymax,
         rlistClip$xmin, rlistClip$ymin)

ee_ROIClip <- matrix(ROIClip, ncol = 2, byrow = TRUE) %>%
  list() %>%
  st_polygon() %>%
  st_sfc() %>%
  st_set_crs(32632) %>%
  sf_as_ee()


#loop the images from gee

for (i in 1:54){
  
# select bands of interest for the ROI
bandsOI = ee$ImageCollection('COPERNICUS/S2')$
  filterBounds(ee$FeatureCollection(ee_ROI))$
  filterDate(firstDay[i],secondDay[i])$
  select(list('B4','B8','B11'))$mean()$clip(ee_ROIClip)

# Download raster
ee_raster <- ee_as_raster(
  image = bandsOI,
  dsn = firstDay[i],
  scale = 10,
  via = "drive"
)
}

