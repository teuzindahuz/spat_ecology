#move pdfs from subfolder to a new folder

install.packages("stringi")
install.packages("filesstrings")

library(stringr)
library(stringi)
library(filesstrings)

# list all CSV files recursively through each sub-folder
pdf<-list.files("C:/Users/ASUS/Downloads/here",pattern = ".pdf", full.names=T,recursive = TRUE)


for (i in 1:length(pdf)) {file.move(pdf[i], "C:/Users/ASUS/Downloads/here")}
