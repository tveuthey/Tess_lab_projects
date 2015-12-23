function [sleep_inds]=find_sleep_indices_BMI(data, wave, Fs_lfp)
figure;
subplot(2,1,2);plot((data(19,:)));
subplot(2,1,1);plot(wave);
pause;

[x,y]=ginput;
% pause;
close all;
temp_x1=x(1);
temp_x2=x(2);
temp=data(1,:);


FILTER_ORDER=4;
s_inds=round(x(1):x(2));
% s_inds=round(1:length(data));
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=4;
f_hi=240;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
for n=1:size(data,1)
    data_lfp(n,s_inds)=(data(n,s_inds)-mean(data(n,s_inds)))/(2*std(data(n,s_inds)));
%     data_lfpfilt(n,s_inds)=filter(b,a,data_lfp(n,s_inds));
    disp(n)
end

ind_thresh=50;
temp2=mean(data_lfp);
temp2=temp2-mean(temp2(s_inds));
ind1=find(temp2>(3*(std(temp2(s_inds)))));
ind2=diff(ind1)>ind_thresh;
ind1=ind1(ind2);

figure;
%plot(data_lfp(1,:),'k')
%hold on
plot(temp2,'k')
hold on
plot([ind1; ind1],[-1 1],'r')
sleep_inds=ind1;

