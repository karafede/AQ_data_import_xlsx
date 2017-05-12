
#################################################################################################
#################################################################################################
#############                                                                   #################
#############     Start of Importing and savind the raw data as db csv format   #################
#############                                                                   #################
#################################################################################################
#################################################################################################


source("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/function_excel2r.R")

library(readxl)
library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(stringr)


dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/hourly_data/test_FK/"


# i <- 2013

## looping around the years

 for (i in 2013:2016){
#  for (i in 2016:2016){

# year 
i
# NCMS  
  
  
import_MOCCE(filenames=paste0("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/NCMS data ", i, ".xlsx"),
             info_NCMS_ex="Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/station_info/Stations_NCMS_2.xlsx" ,
             output= dir)

# DM
import_MOCCE(filenames=paste0("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/DM data ", i, ".xlsx"),
             info_NCMS_ex="Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/station_info/Stations_DM_2.xlsx" ,
             output= dir)

# EAD
import_MOCCE(filenames=paste0("Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/EAD data ", i, ".xlsx"),
             info_NCMS_ex="Z:/_SHARED_FOLDERS/Air Quality/Phase 1/Pathflow of Phase I_DG/dawit Data/Hourly Database format CSV/hourly_FK_new/station_info/Stations_EAD_2.xlsx" ,
             output= dir)


}

#################################################################################################
#################################################################################################
#############                                                                   #################
#############     End of Importing and savind the raw data as db csv format     #################
#############                                                                   #################
#################################################################################################
#################################################################################################



#### cross checking the converted data 

NCMS_2013 <- read_csv(paste0(dir,"database_NCMS data 2013_hourly.csv"))
NCMS_2014 <- read_csv(paste0(dir,"database_NCMS data 2014_hourly.csv"))
NCMS_2015 <- read_csv(paste0(dir,"database_NCMS data 2015_hourly.csv"))
NCMS_2016 <- read_csv(paste0(dir,"database_NCMS data 2016_hourly.csv"))
# remove rows with NA from the first column
NCMS_2013 <- NCMS_2013[!(is.na(NCMS_2013$DateTime)), ]
NCMS_2016 <- NCMS_2016[!(is.na(NCMS_2016$DateTime)), ]


DM_2013 <- read_csv(paste0(dir,"database_DM data 2013_hourly.csv"))
DM_2014 <- read_csv(paste0(dir,"database_DM data 2014_hourly.csv"))
DM_2015 <- read_csv(paste0(dir,"database_DM data 2015_hourly.csv"))
DM_2016 <- read_csv(paste0(dir,"database_DM data 2016_hourly.csv"))
# remove rows with NA from the first column
DM_2013 <- DM_2013[!(is.na(DM_2013$DateTime)), ]
DM_2016 <- DM_2016[!(is.na(DM_2016$DateTime)), ]

EAD_2013 <- read_csv(paste0(dir,"database_EAD data 2013_hourly.csv"))
EAD_2014 <- read_csv(paste0(dir,"database_EAD data 2014_hourly.csv"))
EAD_2015 <- read_csv(paste0(dir,"database_EAD data 2015_hourly.csv"))
EAD_2016 <- read_csv(paste0(dir,"database_EAD data 2016_hourly.csv"))
EAD_2013 <- EAD_2013[!(is.na(EAD_2013$DateTime)), ]
EAD_2016 <- EAD_2016[!(is.na(EAD_2016$DateTime)), ]


