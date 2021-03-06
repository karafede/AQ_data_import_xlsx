

%%%% changing hourly data to daily averages
%loop for the stations
stations=fieldnames(raw_data);
for jjj=1:length(stations)
    pollutants= fieldnames(raw_data.(stations{jjj, 1}));
    % loop for the pollutants
    %for kkk=3:24
        a=double(raw_data.(stations{jjj, 1})(:,3:24)); % a is pollutant value
        aa=permute(a,[1 3 2]);
        %check if the year is leap year or not
        %monthly
        dataset_pol_all=dataset;
        i=2; % initialization of the hourly data 
        while i < length(raw_data.(stations{jjj, 1}))
            date = datenum(cellstr(raw_data.(stations{jjj, 1})(i,2)), 'mm/dd/yyyy HH:MM:SS AM' );
            xx=datevec(date);
            mon=xx(1,2);
            m_31=[1,3,5,7,8,10,12];
            m_30=[4,6,9,11];
            if ismember(xx(1,2),m_31)
                mon_day=31;
            elseif ismember(xx(1,2),m_30)
                mon_day=30;
            else
                if  ~mod(xx(1,1), 4) && (mod(xx(1,1), 100) | ~mod(xx(1,1), 400))==1 
                    mon_day=29;
                else
                    mon_day=28;
                end
            end
            bb=reshape(aa(i-1:i+mon_day*24-2,:,:),24,mon_day,22);
            cc=nanmean(bb,1);
            dd=((24-sum(isnan(bb),1))/24)*100;
            ccc=permute(cc,[2 3 1]);
            ddd=permute(dd,[2 3 1]);
            i=i+mon_day*24;
            date_dataset=datenum(xx(1,1),xx(1,2),1:mon_day);
            formatOut = 'mm/dd/yyyy';
            date_dataset_str=datestr(date_dataset,formatOut);
            dataset_pol=dataset;
            dataset_pol.date=cellstr(date_dataset_str);
            for kkk=1:22
                dataset_pol.(pollutants{kkk+2, 1})=ccc(:,kkk);
                dataset_pol.([pollutants{kkk+2, 1},'_Cap'])=ddd(:,kkk);
            end
            dataset_pol_all=cat(1,dataset_pol_all,dataset_pol);
            clearvars dataset_pol
        end
    
        
    %end
    
    daily_data.(stations{jjj, 1})=dataset_pol_all;
    clearvars -except stations daily_data raw_data
end


    