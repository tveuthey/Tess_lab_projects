function [data_SWA, data]=cat_LFP_SWA(data,sleep_ind)

clear data1;
data1=[];
% for n=1:size(data,1)
for i=1:size(sleep_ind,1)
    clear tmp_ind
    tmp_ind= [sleep_ind(i,1):sleep_ind(i,2)];
    data1=[data1, data(:,tmp_ind)];
end
    
data_SWA= data1;
data=data;