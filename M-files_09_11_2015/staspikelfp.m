function [STA]=staspikelfp(TimeStamps,data, Fs_lfp,wave)
a=TimeStamps;
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;
data21=data(:,block);
temp3=wave(1,block)>2;
figure;
plot(temp3)
hold on
for i=3:(size(a,2)-3)
    if temp3(round((a(i)*(Fs_lfp))))== 1    
    data2(:,:,i)=data(:,(a(i)-1)*(Fs_lfp):(a(i)+1)*(Fs_lfp));
    else
        data3(:,:,i)=data(:,(a(i)-1)*(Fs_lfp):(a(i)+1)*(Fs_lfp));
    end
end
lfp_avg_prestim=mean(data2,3);
lfp_avg_duringstim=mean(data3,3);
STA=size(lfp_avg_prestim);
for j=1:size(data,1)
    subplot(4,1,j);plot(lfp_avg_prestim(j,:));hold on;plot(lfp_avg_duringstim(j,:),'r')
end


