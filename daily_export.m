%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Changing the hourly to daily and exporting with Cap  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% changing the hourly data to daily data with the function of
%%%%% hour2daily. the input to this function is the a structure raw_data
%%%%% output of the imported excel files using changing2dataset.m script.
    
    %%%% daily_data=hour2daily(raw_data, pollut_start,pollut_end)
    %%%% raw_data should be a structure with all the station data as a
    %%%% dataset format. the field names of the should be the pollutants name.
    %%%% pollut_start is the column that the pollutants start in the raw
    %%%% data.
    %%%% pollut_end is the column that hte pollutants end in the raw data.
    %%%% the output of the function is the structure data with station
    %%%% datasets.
    
daily_data_NCMS=hour2daily(raw_data);

%%%% the outcome of the hour2daily function can be feed to the arra_data
%%%% function to create a database structure of th daily data of the
%%%% pollutants with capture percentage and other station details like the
%%%% latitutde, longitude, site name, emirates, authority ...
%%%% the outcome of the function is a csv file of the daily data in data
%%%% base format
    %%%% arra_data(daily_data, filename_SD,startRow,endRow,filename_output)
    %%%% daily_data is the outcome of the houly2daily function above in a
    %%%% structure format with stations in the fields as dataset.
    %%%% filename_SD is the filename and path of the excel file with the
    %%%% station details.
    %%%% startRow & endRow are the start and end row of the stations in the
    %%%% station detail excel file. (depends on the number of stations)
    %%%% filename_output is the filename and path of the output csv file.
filename_SD = 'Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_NCMS.xlsx';
% filename_output= 'Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\daily data\database_NCMS_2016_daily.csv';
filename_output= 'D:\procedures for AQ data processing\1_importing from excel\daily_data\database_NCMS_2016_daily.csv';

startRow= 2;
endRow = 9;
arra_data(daily_data_NCMS,filename_SD,startRow,endRow,filename_output)
clear all


