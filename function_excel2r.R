import_MOCCE <- function(filenames,info_NCMS_ex=info_NCMS_ex , output= dir){ 
  
  library(readxl)
  library(dplyr)
  library(lubridate)
  library(tidyr)
  library(readr)
  library(stringr)
  library(tools)
  
  # initialize and empty data_frame
  BBB <- NULL
  
  # station detail extraction
  
  info_NCMS <- readxl::read_excel(info_NCMS_ex,
                                  sheet = 1)
  
  # remove rows with NA from the first column
  info_NCMS <- info_NCMS[!(is.na(info_NCMS$`Station name`)), ]
  
  # remove columns with NA from the first column
  # info_NCMS <- info_NCMS[colSums(!is.na(info_NCMS)) > 0]
  
  
  # load info file (speadsheet with units)
  info_NCMS_units <- readxl::read_excel(info_NCMS_ex,
                                        sheet = "Units")
  info_NCMS_units <- info_NCMS_units[!(is.na(info_NCMS_units$SO2)), ]
  info_NCMS_units <- info_NCMS_units[colSums(!is.na(info_NCMS_units)) > 0]
  

  
  for (i in 1:nrow(info_NCMS)) {
    #i=3
    
    # subset info from the NCMS station info file
    info_data_subset <- info_NCMS[i,]
    headers <- colnames(info_data_subset)
    
    name<- file_path_sans_ext(basename(filenames))
    #### removing the white spaces str_trim()
    
    
    #name <- str_sub(filenames, start = 1, end = -6)
    # wb <- sheetNames(unlist(filenames), perl = "perl")
    # sheets <- getSheets(wb)
    # 
    # sheet <- names( getSheets( unlist(filenames) ) )
    
    NCMS_data<- tryCatch({ NCMS_data <- readxl::read_excel(unlist(filenames),
                                    sheet = as.character(info_data_subset[1]) , col_names = TRUE, skip = 6)[-1]
    }, error= function(err) { print(paste0("check the station name ", as.character(info_data_subset[1])))
      NCMS_data <- readxl::read_excel(unlist(filenames),
                                      sheet = i , col_names = TRUE, skip = 6)[-1]
      return(NCMS_data)
    }, finally = {
      
   })
    
    # make first row as column name
    #colnames(NCMS_data) = NCMS_data[1, ]
    
    # remove top 3 rows
    NCMS_data <- tail(NCMS_data, -2)
    
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
    
    
    for (qq in 7: (length(info_data_subset))) {
      #qq=7
      if (!is.na(as.numeric(info_data_subset[qq]))) {
        if (as.numeric(info_data_subset[qq]) ==1){
          
          DB_NCMS[[paste0(headers[qq])]] <- as.numeric(NCMS_data[[headers[qq]]])
          
        }
        if (as.numeric(info_data_subset[qq]) > 1){
          
          DB_NCMS[[paste0(headers[qq])]] <- as.character(info_data_subset[29])
        }
      }
    }

    DB_NCMS <- as.data.frame(DB_NCMS)
    
    # remove rows with NA from the DateTime column
    DB_NCMS <- DB_NCMS[!(is.na(DB_NCMS$DateTime)), ]
    
    
    ### Converting data between wide and long format (Data Base format) ###########
    DB_NCMS <- gather(DB_NCMS, Pollutant, Value, -DateTime,-Site,
                  -Site_Type, -Latitude,-Longitude,-Emirate,-Authority,-Total, factor_key=TRUE)

  ### adding units from the info file
    
    # create an empty column first
    DB_NCMS$Unit <- NA
    
    for (kk in 1:ncol(info_NCMS_units)){
    condition_micro <- DB_NCMS$Pollutant == colnames(info_NCMS_units[kk])
    DB_NCMS$Unit[condition_micro] <- unlist(info_NCMS_units[kk])
    }
    
    
    
    BBB <- rbind(BBB, DB_NCMS)
    
    
  }  
  
  # return(BBB)
  write_csv(BBB, paste0(output,"database_", name, "_hourly.csv", sep = ""))
  
}

