
library(readxl)
library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(stringr)


# setwd("D:/MoCCE_new_data/new 2016")

# directory with the latest xlsx data from the MOCCE --------------------------------------------------------------------
setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new")
# path<- ".xlsx"
# filenames <- list.files(pattern = path)
# filenames <- filenames[3]     # NCMS


# NCMS
filenames <- list("NCMS data 2013.xlsx", "NCMS data 2014.xlsx", "NCMS data 2015.xlsx", "NCMS data 2016.xlsx")
# filenames <- filenames[3]

# EAD
# filenames <- list("EAD data  2013.xlsx", "EAD data  2014.xlsx", "EAD data  2015.xlsx", "EAD data  2016.xlsx")

# DM 
# filenames <- list("DM data 2013.xlsx", "DM data 2014.xlsx", "DM data 2015.xlsx", "DM data 2016.xlsx")


# load info file  NCMS
info_NCMS <- readxl::read_excel("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/station_info/Stations_NCMS.xlsx",
                                    sheet = "NCMS")

# remove rows with NA from the first column
info_NCMS <- info_NCMS[!(is.na(info_NCMS$`Station name`)), ]

# remove columns with NA from the first column
info_NCMS <- info_NCMS[colSums(!is.na(info_NCMS)) > 0]


# load info file (speadsheet with units)
info_NCMS_units <- readxl::read_excel("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/station_info/Stations_NCMS.xlsx",
                                sheet = "Units")
info_NCMS_units <- info_NCMS_units[!(is.na(info_NCMS_units$SO2)), ]
info_NCMS_units <- info_NCMS_units[colSums(!is.na(info_NCMS_units)) > 0]

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/hourly_data/"


#########################################################################################################

# i <- 1

 import_MOCCE <- function(filenames){ 
   
  # initialize and empty data_frame
   BBB <- NULL
   
  for (i in 1:nrow(info_NCMS)) {

# subset info from the NCMS station info file
  info_data_subset <- info_NCMS[i,]
  headers <- colnames(info_data_subset)
  name <- str_sub(filenames, start = 1, end = -6)
  
  NCMS_data <- readxl::read_excel(unlist(filenames),
                                       sheet = as.character(info_data_subset[1]) , col_names = TRUE, skip = 5)[-1]
  

  
   # make first row as column name
   colnames(NCMS_data) = NCMS_data[1, ]
  
   # remove top 3 rows
   NCMS_data <- tail(NCMS_data, -3)
   
   # rename first column 
   colnames(NCMS_data)[1] <- "DateTime"
   
   # change format of Date & Time 
   NCMS_data$DateTime <- as.numeric(NCMS_data$DateTime)
   NCMS_data$DateTime <- as.POSIXct(as.Date( NCMS_data$DateTime,origin="1899-12-30"))
   attr(NCMS_data$DateTime,"tzone") <- "UTC"
   NCMS_data$DateTime <- NCMS_data$DateTime + 300   # add 1 second
   
   NCMS_data$DateTime <- trunc(NCMS_data$DateTime, units = "mins")
   
  
   # build a new data frame with selected pollutants from the info_data_subset file
   DB_NCMS <- NULL
   
   DB_NCMS$DateTime <- NCMS_data$DateTime
   
   
   
# each header correspond to the position of a pollutant:  "Station name" "Site Type"    "Latitude"     "longitude"    "Emirate" 
   # "Authority" , "SO2" , "NO2",  "O3", "CO", "PM10",  "PM2.5"
   
# for (i in 1:(length(headers))) {
   
   DB_NCMS$Site <- as.character(info_data_subset[1])
   DB_NCMS$Site_Type <- as.character(info_data_subset[2])
   DB_NCMS$Latitude <- as.character(info_data_subset[3])
   DB_NCMS$Longitude <- as.character(info_data_subset[4])
   DB_NCMS$Emirate <- as.character(info_data_subset[5])
   DB_NCMS$Authority <- as.character(info_data_subset[6])
   
   DB_NCMS$SO2 <- as.numeric(NCMS_data[[headers[7]]])
   DB_NCMS$NO2 <- as.numeric(NCMS_data[[headers[8]]])
   DB_NCMS$O3 <- as.numeric(NCMS_data[[headers[9]]])
   DB_NCMS$CO <- as.numeric(NCMS_data[[headers[10]]])
   DB_NCMS$PM10 <- as.numeric(NCMS_data[[headers[11]]])
   DB_NCMS$PM2.5 <- as.numeric(NCMS_data[[headers[12]]])
   DB_NCMS$Total_Pollutants <- as.character(info_data_subset[13])
   
   DB_NCMS <- as.data.frame(DB_NCMS)
   
   # remove rows with NA from the DateTime column
   DB_NCMS <- DB_NCMS[!(is.na(DB_NCMS$DateTime)), ]
   
   
   ### Converting data between wide and long format (Data Base format) ###########
   DB_NCMS <- gather(DB_NCMS, Pollutant, Value, SO2:PM2.5, factor_key=TRUE)
   

   # units for SO2, NO2, O3, PM10 and PM25
   units_micrograms <- info_NCMS_units[1,1]
   # units for CO2
   units_milligrams <- info_NCMS_units[1,4]
   
   
   # create an empty column first
   DB_NCMS$Unit <- NA
   
  
   condition_micro <- DB_NCMS$Pollutant %in% c("SO2", "NO2", "PM10", "PM2.5", "O3") 
   DB_NCMS$Unit[condition_micro] <- unlist(units_micrograms)
   
   condition_milli <- DB_NCMS$Pollutant %in% "CO"
   DB_NCMS$Unit[condition_milli] <- unlist(units_milligrams)
   
   
    BBB <- rbind(BBB, DB_NCMS)


  }  
   
  # return(BBB)
  write_csv(BBB, paste0(dir,"database_", name, "_hourly.csv", sep = ""))
  
  }
  

###### run the function ##################################

# AAA <- import_MOCCE(filenames[4])
 AAA <- lapply(filenames, import_MOCCE)

##### end ################################################
##########################################################




# condition_micro <- AAA$Pollutant %in% c("SO2", "NO2", "PM10", "PM2.5", "O3") 
# 
# condition_milli <- AAA$Pollutant %in% "CO"
# 
# xx_vec<- vector(length=nrow(AAA))
# 
# xx_vec[condition_micro]<- units_micrograms 
# 
# xx_vec[condition_milli]<- units_milligrams 
# 
# 
# xx_vec <- unlist(xx_vec)
# 
# DB_NCMS$Unit[condition_micro] <- units_micrograms)
# 
# condition_milli <- DB_NCMS$Pollutant %in% "CO"
# DB_NCMS$Unit[condition_milli] <- as.data.frame(units_milligrams)
# 
# DB_NCMS$Unit <- as.vector(DB_NCMS$Unit)
# 
# AAAA<-  cbind(AAA,xx_vec)


 