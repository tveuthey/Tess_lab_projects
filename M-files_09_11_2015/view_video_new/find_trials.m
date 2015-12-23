function [trial_ls]=find_trials(unique_rats,unique_dates,rat_name,rat_date,p)

if ~isempty ('p')
%    p='C:\Users\Karunesh\Desktop\VIDEOS\';
    p='E:\T28\Day1';
end
%rat_name=1;
%rat_date=1;
temp=ls(p);
temp_stop=1; offset=0;
while temp_stop
    temp2=temp(offset+1,:);
    dash=find(temp2=='.');
    temp_stop=~strcmp('mat',temp2(dash+1:dash+3));
    offset=offset+1;
end

dates=unique_dates{rat_name};
dates2=dates(rat_date);
base_name=strcat(unique_rats(rat_name),'-',dates2);

trial_ls=[];
for n= offset:length(temp)
    temp2=temp(n,:);
    dash=find(temp2=='-');
    per=find(temp2=='.');
    temp3=temp2(1:dash(3)-1);
    trial_no=str2num((temp2(dash(3)+1:(per-1))));
    if strcmp(base_name,temp3)
        trial_ls=[trial_ls trial_no];
    end
end

trial_ls=sort(trial_ls);
disp([trial_ls([1 end])])
        
