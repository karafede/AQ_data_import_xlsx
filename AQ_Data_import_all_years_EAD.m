%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                       %%%%%%%%%%
%%%%%%%%%% IMPORTING AND ORGANIZING IN-SITU DATA %%%%%%%%%%
%%%%%%%%%%                                       %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       2013       %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Imporing the raw data from the excel files   %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Data from the National Center of Meteorology & Seismology - NCMS 
startRow = 10; % the row that the data starts
endRow = 8769; % 8769 or 8793 for the entire year 
[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data  2013.xlsx'); 
%%%% loop for the sheets
%tic
for k=1:length(sheetname)%-1 % minus one depending on the worksheet if it has a sheet named 'lists' at the end 
    if strcmp(sheetname{1,k}, 'Lists' ) || strcmp(sheetname{1,k}, 'lists' )
    else
    data = importfile3('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data  2013.xlsx',sheetname{1,k},startRow, endRow);
    dawit=sheetname{1,k}; % to create valid name with out spaces
    sheetname{1,k}=genvarname(dawit); %on the updated version matlab.lang.makeValidName can be used instead of genvarname
    raw_data.(sheetname{1,k}) = data; 
    end
end
%on the updated version matlab.lang.makeValidName can be used instead of genvarname
%toc
save('AQ_raw_data_EAD_2013_hourly.mat', 'raw_data')
clearvars data sheetname type dawit startRow endRow k
%%%% end of the loop the result will be a structure with file name of raw_data



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Imporing the stations details           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx'); 

% start row and end row have to be set from the station_NCMS.xlsx data
startRow=2;
endRow=21; % depends of the number of stations
%%% loop for the sheets
for kk=1: length(sheetname)
    if strcmp(sheetname{1,kk}, 'Units' )
        % range= a2:v2;% Specify RANGE using the syntax  'C1:C2',where C1 and C2 are opposing corners of the region.
        polu_units = units('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx', sheetname{1,kk});
    else
        %endrow= ; startrow = ; % Specify STARTROW and   ENDROW as a pair of scalars or vectors of matching size for dis-contiguous row intervals. To read to the end of the file specify an ENDROW of inf.
        Station_detail = import_station_detail('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx',sheetname{1,kk},startRow,endRow);
        pollutant=double(Station_detail(:,7:29));
    end
end
 clearvars  sheetname type kk
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Rearranging the raw data to database format  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%the headers of the file are as follows
%1)data and time 2) site name 3) variable 4) unit 5) value 6) latitude 7)
%longitude 8) emirate 9) authority 10) Total number of pollutants measured

names = fieldnames(raw_data);
for ii=1:length (names) % a loop to all the stations in the structure
    %name_dataset= names{ii,1};
    %new_dataset=dataset;
    new_data=dataset;
    for jj=3:24 % to move acoross the variables
        if pollutant(ii,jj-2)==1 % checks if the pollutant is measured at the station
        for i=1:length (raw_data.(names{ii,1})) % a loop to collect one variable
            new_dataset=raw_data.(names{ii,1})(i,2);
            new_dataset.Site=cellstr(Station_detail(ii,1)); %%% problem
            new_dataset.Site_Type=cellstr(Station_detail(ii,2));
            new_dataset.Pollutant=cellstr(polu_units{1,jj-2}); % need a file containing the variable names and their units
            new_dataset.Unit=cellstr(polu_units{2,jj-2});
            new_dataset.Value=double(raw_data.(names{ii,1})(i,jj));
            new_dataset.Latitude=double(Station_detail(ii,3));
            new_dataset.Longitude=double(Station_detail(ii,4));
            new_dataset.Emirate= cellstr(Station_detail(ii,5));
            new_dataset.Authority=cellstr(Station_detail(ii,6));
            new_dataset.Total_Polutants=double(Station_detail(ii,29));            
            new_data=cat(1,new_data,new_dataset);
        end
        else
        end
    end
    arra_dataset_station.(names{ii,1})=new_data;
    clearvars new_dataset new_data
end

save('AQ_arranged_data_EAD_2013_hourly.mat', 'arra_dataset_station')
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Combining and Exporting the dataset to csv file %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Combining all stations to one dataset
names = fieldnames(arra_dataset_station);
final_dataset=dataset;
for kkk=1:length(names)
    final_dataset=cat(1,final_dataset,arra_dataset_station.(names{kkk,1}));
end

%%%% arrange the date format to mm/dd/yyyy HH:MM:SS

for i=1:length(final_dataset)
    dawit=cellstr(final_dataset (i,1));
    if length(dawit{1,1})< 12
        final_dataset.DateTime(i,1)=cellstr(strcat(dawit{1,1},' 12:00:00 AM'));
    else   
    end
end

clearvars -except final_dataset
%%%%%% Exporting the file to csv file
export(final_dataset,'File','Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\database_EAD_2013_hourly.csv','Delimiter',',')
clear all
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       2014       %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Imporing the raw data from the excel files   %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Data from the National Center of Meteorology & Seismology - NCMS 
startRow = 10; % the row that the data starts
endRow = 8769; % 8769 or 8793 for the entire year 
[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2014.xlsx'); 
%%%% loop for the sheets
%tic
for k=1:length(sheetname)%-1 % minus one depending on the worksheet if it has a sheet named 'lists' at the end 
    if strcmp(sheetname{1,k}, 'Lists' ) || strcmp(sheetname{1,k}, 'lists' )
    else
    data = importfile3('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2014.xlsx',sheetname{1,k},startRow, endRow);
    dawit=sheetname{1,k}; % to create valid name with out spaces
    sheetname{1,k}=genvarname(dawit); %on the updated version matlab.lang.makeValidName can be used instead of genvarname
    raw_data.(sheetname{1,k}) = data; 
    end
end
%on the updated version matlab.lang.makeValidName can be used instead of genvarname
%toc
save('AQ_raw_data_EAD_2014_hourly.mat', 'raw_data')
clearvars data sheetname type dawit startRow endRow k
%%%% end of the loop the result will be a structure with file name of raw_data



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Imporing the stations details           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx'); 

% start row and end row have to be set from the station_NCMS.xlsx data
startRow=2;
endRow=21; % depends of the number of stations
%%% loop for the sheets
for kk=1: length(sheetname)
    if strcmp(sheetname{1,kk}, 'Units' )
        % range= a2:v2;% Specify RANGE using the syntax  'C1:C2',where C1 and C2 are opposing corners of the region.
        polu_units = units('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx', sheetname{1,kk});
    else
        %endrow= ; startrow = ; % Specify STARTROW and   ENDROW as a pair of scalars or vectors of matching size for dis-contiguous row intervals. To read to the end of the file specify an ENDROW of inf.
        Station_detail = import_station_detail('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx',sheetname{1,kk},startRow,endRow);
        pollutant=double(Station_detail(:,7:29));
    end
end
 clearvars  sheetname type kk
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Rearranging the raw data to database format  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%the headers of the file are as follows
%1)data and time 2) site name 3) variable 4) unit 5) value 6) latitude 7)
%longitude 8) emirate 9) authority 10) Total number of pollutants measured

names = fieldnames(raw_data);
for ii=1:length (names) % a loop to all the stations in the structure
    %name_dataset= names{ii,1};
    %new_dataset=dataset;
    new_data=dataset;
    for jj=3:24 % to move acoross the variables
        if pollutant(ii,jj-2)==1 % checks if the pollutant is measured at the station
        for i=1:length (raw_data.(names{ii,1})) % a loop to collect one variable
            new_dataset=raw_data.(names{ii,1})(i,2);
            new_dataset.Site=cellstr(Station_detail(ii,1)); %%% problem
            new_dataset.Site_Type=cellstr(Station_detail(ii,2));
            new_dataset.Pollutant=cellstr(polu_units{1,jj-2}); % need a file containing the variable names and their units
            new_dataset.Unit=cellstr(polu_units{2,jj-2});
            new_dataset.Value=double(raw_data.(names{ii,1})(i,jj));
            new_dataset.Latitude=double(Station_detail(ii,3));
            new_dataset.Longitude=double(Station_detail(ii,4));
            new_dataset.Emirate= cellstr(Station_detail(ii,5));
            new_dataset.Authority=cellstr(Station_detail(ii,6));
            new_dataset.Total_Polutants=double(Station_detail(ii,29));            
            new_data=cat(1,new_data,new_dataset);
        end
        else
        end
    end
    arra_dataset_station.(names{ii,1})=new_data;
    clearvars new_dataset new_data
end

save('AQ_arranged_data_EAD_2014_hourly.mat', 'arra_dataset_station')
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Combining and Exporting the dataset to csv file %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Combining all stations to one dataset
names = fieldnames(arra_dataset_station);
final_dataset=dataset;
for kkk=1:length(names)
    final_dataset=cat(1,final_dataset,arra_dataset_station.(names{kkk,1}));
end

%%%% arrange the date format to mm/dd/yyyy HH:MM:SS

for i=1:length(final_dataset)
    dawit=cellstr(final_dataset (i,1));
    if length(dawit{1,1})< 12
        final_dataset.DateTime(i,1)=cellstr(strcat(dawit{1,1},' 12:00:00 AM'));
    else   
    end
end

clearvars -except final_dataset
%%%%%% Exporting the file to csv file
export(final_dataset,'File','Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\database_EAD_2014_hourly.csv','Delimiter',',')
clear all
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       2015       %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Imporing the raw data from the excel files   %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Data from the National Center of Meteorology & Seismology - NCMS 
startRow = 10; % the row that the data starts
endRow = 8769; % 8769 or 8793 for the entire year 
[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2015.xlsx'); 
%%%% loop for the sheets
%tic
for k=1:length(sheetname)%-1 % minus one depending on the worksheet if it has a sheet named 'lists' at the end 
    if strcmp(sheetname{1,k}, 'Lists' ) || strcmp(sheetname{1,k}, 'lists' )
    else
    data = importfile3('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2015.xlsx',sheetname{1,k},startRow, endRow);
    dawit=sheetname{1,k}; % to create valid name with out spaces
    sheetname{1,k}=genvarname(dawit); %on the updated version matlab.lang.makeValidName can be used instead of genvarname
    raw_data.(sheetname{1,k}) = data;  
    end
end
%on the updated version matlab.lang.makeValidName can be used instead of genvarname
%toc
save('AQ_raw_data_EAD_2015_hourly.mat', 'raw_data')
clearvars data sheetname type dawit startRow endRow k
%%%% end of the loop the result will be a structure with file name of raw_data



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Imporing the stations details           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx'); 

% start row and end row have to be set from the station_NCMS.xlsx data
startRow=2;
endRow=21; % depends of the number of stations
%%% loop for the sheets
for kk=1: length(sheetname)
    if strcmp(sheetname{1,kk}, 'Units' )
        % range= a2:v2;% Specify RANGE using the syntax  'C1:C2',where C1 and C2 are opposing corners of the region.
        polu_units = units('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx', sheetname{1,kk});
    else
        %endrow= ; startrow = ; % Specify STARTROW and   ENDROW as a pair of scalars or vectors of matching size for dis-contiguous row intervals. To read to the end of the file specify an ENDROW of inf.
        Station_detail = import_station_detail('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx',sheetname{1,kk},startRow,endRow);
        pollutant=double(Station_detail(:,7:29));
    end
end
 clearvars  sheetname type kk
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Rearranging the raw data to database format  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%the headers of the file are as follows
%1)data and time 2) site name 3) variable 4) unit 5) value 6) latitude 7)
%longitude 8) emirate 9) authority 10) Total number of pollutants measured

names = fieldnames(raw_data);
for ii=1:length (names) % a loop to all the stations in the structure
    %name_dataset= names{ii,1};
    %new_dataset=dataset;
    new_data=dataset;
    for jj=3:24 % to move acoross the variables
        if pollutant(ii,jj-2)==1 % checks if the pollutant is measured at the station
        for i=1:length (raw_data.(names{ii,1})) % a loop to collect one variable
            new_dataset=raw_data.(names{ii,1})(i,2);
            new_dataset.Site=cellstr(Station_detail(ii,1)); %%% problem
            new_dataset.Site_Type=cellstr(Station_detail(ii,2));
            new_dataset.Pollutant=cellstr(polu_units{1,jj-2}); % need a file containing the variable names and their units
            new_dataset.Unit=cellstr(polu_units{2,jj-2});
            new_dataset.Value=double(raw_data.(names{ii,1})(i,jj));
            new_dataset.Latitude=double(Station_detail(ii,3));
            new_dataset.Longitude=double(Station_detail(ii,4));
            new_dataset.Emirate= cellstr(Station_detail(ii,5));
            new_dataset.Authority=cellstr(Station_detail(ii,6));
            new_dataset.Total_Polutants=double(Station_detail(ii,29));            
            new_data=cat(1,new_data,new_dataset);
        end
        else
        end
    end
    arra_dataset_station.(names{ii,1})=new_data;
    clearvars new_dataset new_data
end

save('AQ_arranged_data_EAD_2015_hourly.mat', 'arra_dataset_station')
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Combining and Exporting the dataset to csv file %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Combining all stations to one dataset
names = fieldnames(arra_dataset_station);
final_dataset=dataset;
for kkk=1:length(names)
    final_dataset=cat(1,final_dataset,arra_dataset_station.(names{kkk,1}));
end

%%%% arrange the date format to mm/dd/yyyy HH:MM:SS

for i=1:length(final_dataset)
    dawit=cellstr(final_dataset (i,1));
    if length(dawit{1,1})< 12
        final_dataset.DateTime(i,1)=cellstr(strcat(dawit{1,1},' 12:00:00 AM'));
    else   
    end
end

clearvars -except final_dataset
%%%%%% Exporting the file to csv file
export(final_dataset,'File','Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\database_EAD_2015_hourly.csv','Delimiter',',')
clear all
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       2016       %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Imporing the raw data from the excel files   %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Data from the National Center of Meteorology & Seismology - NCMS 
startRow = 10; % the row that the data starts
endRow = 8793; % 8769 or 8793 for the entire year 
[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2016.xlsx'); 
%%%% loop for the sheets
%tic
for k=1:length(sheetname)%-1 % minus one depending on the worksheet if it has a sheet named 'lists' at the end 
    if strcmp(sheetname{1,k}, 'Lists' ) || strcmp(sheetname{1,k}, 'lists' )
    else
    data = importfile3('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\MoEW Data\Abu Dhabi data 2016.xlsx',sheetname{1,k},startRow, endRow);
    dawit=sheetname{1,k}; % to create valid name with out spaces
    sheetname{1,k}=genvarname(dawit); %on the updated version matlab.lang.makeValidName can be used instead of genvarname
    raw_data.(sheetname{1,k}) = data; 
    end
end
%on the updated version matlab.lang.makeValidName can be used instead of genvarname
%toc
save('AQ_raw_data_EAD_2016_hourly.mat', 'raw_data')
clearvars data sheetname type dawit startRow endRow k
%%%% end of the loop the result will be a structure with file name of raw_data



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Imporing the stations details           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[type,sheetname] = xlsfinfo('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx'); 

% start row and end row have to be set from the station_NCMS.xlsx data
startRow=2;
endRow=21; % depends of the number of stations
%%% loop for the sheets
for kk=1: length(sheetname)
    if strcmp(sheetname{1,kk}, 'Units' )
        % range= a2:v2;% Specify RANGE using the syntax  'C1:C2',where C1 and C2 are opposing corners of the region.
        polu_units = units('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx', sheetname{1,kk});
    else
        %endrow= ; startrow = ; % Specify STARTROW and   ENDROW as a pair of scalars or vectors of matching size for dis-contiguous row intervals. To read to the end of the file specify an ENDROW of inf.
        Station_detail = import_station_detail('Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\Stations_EAD.xlsx',sheetname{1,kk},startRow,endRow);
        pollutant=double(Station_detail(:,7:29));
    end
end
 clearvars  sheetname type kk
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Rearranging the raw data to database format  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%the headers of the file are as follows
%1)data and time 2) site name 3) variable 4) unit 5) value 6) latitude 7)
%longitude 8) emirate 9) authority 10) Total number of pollutants measured

names = fieldnames(raw_data);
for ii=1:length (names) % a loop to all the stations in the structure
    %name_dataset= names{ii,1};
    %new_dataset=dataset;
    new_data=dataset;
    for jj=3:24 % to move acoross the variables
        if pollutant(ii,jj-2)==1 % checks if the pollutant is measured at the station
        for i=1:length (raw_data.(names{ii,1})) % a loop to collect one variable
            new_dataset=raw_data.(names{ii,1})(i,2);
            new_dataset.Site=cellstr(Station_detail(ii,1)); %%% problem
            new_dataset.Site_Type=cellstr(Station_detail(ii,2));
            new_dataset.Pollutant=cellstr(polu_units{1,jj-2}); % need a file containing the variable names and their units
            new_dataset.Unit=cellstr(polu_units{2,jj-2});
            new_dataset.Value=double(raw_data.(names{ii,1})(i,jj));
            new_dataset.Latitude=double(Station_detail(ii,3));
            new_dataset.Longitude=double(Station_detail(ii,4));
            new_dataset.Emirate= cellstr(Station_detail(ii,5));
            new_dataset.Authority=cellstr(Station_detail(ii,6));
            new_dataset.Total_Polutants=double(Station_detail(ii,29));            
            new_data=cat(1,new_data,new_dataset);
        end
        else
        end
    end
    arra_dataset_station.(names{ii,1})=new_data;
    clearvars new_dataset new_data
end

save('AQ_arranged_data_EAD_2016_hourly.mat', 'arra_dataset_station')
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Combining and Exporting the dataset to csv file %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Combining all stations to one dataset
names = fieldnames(arra_dataset_station);
final_dataset=dataset;
for kkk=1:length(names)
    final_dataset=cat(1,final_dataset,arra_dataset_station.(names{kkk,1}));
end

%%%% arrange the date format to mm/dd/yyyy HH:MM:SS

for i=1:length(final_dataset)
    dawit=cellstr(final_dataset (i,1));
    if length(dawit{1,1})< 12
        final_dataset.DateTime(i,1)=cellstr(strcat(dawit{1,1},' 12:00:00 AM'));
    else   
    end
end

clearvars -except final_dataset
%%%%%% Exporting the file to csv file
export(final_dataset,'File','Z:\_SHARED_FOLDERS\Air Quality\Phase 1\Pathflow of Phase I_DG\dawit Data\database_EAD_2016_hourly.csv','Delimiter',',')
clear all
