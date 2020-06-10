# Cropping pictures in a folder in centre. That can be useful for obtaining a standard size of all the pictures contained in the folder
# This function collect raster files in a specified folder, crop them from the centre and save them in a new folder
#arguments
#files: character list from list.files function
#dir.out: character object indicating the folder to save the results. The file is saved as .tif
#width: number of columns to crop from centre of pictures
#height: number of rows to crop from centre of pictures
install.packages("raster")

library(raster)

#example to crop pics as 300x300 squares
files<-list.files("C:/Users/ASUS/Desktop/projects/fb_id/fb_test/nnp/test_crop",".jpg",full.names = T)

dir.out<-"C:/Users/ASUS/Desktop/projects/fb_id/fb_test/nnp/test_crop"

width<-150

height<-150

crop_centre<- function  (files,dir.out,width,height ){
  for  (i in 1:length (files ) ){
    crop1<- raster (files[i] )
    crop_ext<- extent (round (extent (crop1 )[2]/2- width ),
                     round (extent (crop1 )[2]/2+width ),
                     round (extent (crop1 )[4]/2- height ),
                     round (extent (crop1 )[4]/2+height ) )
    cropped<- crop (crop1,crop_ext )
#cropped<- resample (crop1,res )
    writeRaster (cropped,paste0 (dir.out,"/","test_",i,".tif" ),overwrite=T )
  }
}


