
function arra =arra_data(raw_data,station_detail_file,startRow,endRow,filename_loction_expo)

% the outcome of the hour2daily function can be feed to the arra_data
% function to create a database structure of th daily data of the
% pollutants with capture percentage and other station details like the
% latitutde, longitude, site name, emirates, authority ...
% the outcome of the function is a csv file of the daily data in data
% base format
    % arra_data(daily_data, filename_SD,startRow,endRow,filename_output)
    % daily_data is the outcome of the houly2daily function above in a
    % structure format with stations in the fields as dataset.
    % filename_SD is the filename and path of the excel file with the
    % station details.
    % startRow & endRow are the start and end row of the stations in the
    % station detail excel file. (depends on the number of stations)
    % filename_output is the filename and path of the output csv file.

[type,sheetname] = xlsfinfo(station_detail_file); 

%%% loop for the sheets

for kk=1: length(sheetname)
    if strcmp(sheetname{1,kk}, 'Units' )
        % range= a2:v2;% Specify RANGE using the syntax  'C1:C2',where C1 and C2 are opposing corners of the region.
        polu_units = units(station_detail_file, sheetname{1,kk});
    else
        %endrow= ; startrow = ; % Specify STARTROW and   ENDROW as a pair of scalars or vectors of matching size for dis-contiguous row intervals. To read to the end of the file specify an ENDROW of inf.
        Station_detail = import_station_detail(station_detail_file,sheetname{1,kk},startRow,endRow);
        pollutant=double(Station_detail(:,7:28));
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
xx=2:2:44;
for ii=1:length (names) % a loop to all the stations in the structure
    %name_dataset= names{ii,1};
    %new_dataset=dataset;
    new_data=dataset;
    for jj=3:24 % to move acoross the variables
        if pollutant(ii,jj-2)==1 % checks if the pollutant is measured at the station
        for i=1:length (raw_data.(names{ii,1})) % a loop to collect one variable
            new_dataset=raw_data.(names{ii,1})(i,1);
            new_dataset.Site=cellstr(Station_detail(ii,1)); %%% problem
            new_dataset.Site_Type=cellstr(Station_detail(ii,2));
            new_dataset.Pollutant=cellstr(polu_units{1,jj-2}); % need a file containing the variable names and their units
            new_dataset.Unit=cellstr(polu_units{2,jj-2});
            new_dataset.Value=double(raw_data.(names{ii,1})(i,xx(jj-2)));
            new_dataset.Cap=double(raw_data.(names{ii,1})(i,xx(jj-2)+1));
            new_dataset.Latitude=double(Station_detail(ii,3));
            new_dataset.Longitude=double(Station_detail(ii,4));
            new_dataset.Emirate= cellstr(Station_detail(ii,5));
            new_dataset.Authority=cellstr(Station_detail(ii,6));
            new_dataset.Total_polutants=double(Station_detail(ii,29));            
            new_data=cat(1,new_data,new_dataset);
        end
        else
        end
    end
    arra_dataset_station.(names{ii,1})=new_data;
    clearvars new_dataset new_data
end

%save('AQ_arranged_data_NCMS_station_1_Quar_2015.mat', 'arra_dataset_station')
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
%{
for i=1:length(final_dataset)
    dawit=cellstr(final_dataset (i,1));
    if length(dawit{1,1})< 12
        final_dataset.DateTime(i,1)=cellstr(strcat(dawit{1,1},' 12:00:00 AM'));
    else   
    end
end
%}

clearvars -except final_dataset filename_loction_expo
%%%%%% Exporting the file to csv file
export(final_dataset,'File',filename_loction_expo,'Delimiter',',')
   