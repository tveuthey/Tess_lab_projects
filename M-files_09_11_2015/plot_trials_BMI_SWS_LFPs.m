function [Output]=plot_trials_BMI_SWS_LFPs(data,wave,Fs_lfp,chan_no,sleep_ind)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;
figure
times=3*Fs_lfp;
% if length(sleep_ind)>500
%     sleep_ind=sleep_ind(1:3:end);
%     length(sleep_ind)
% end
FILTER_ORDER=4;
END_SMOOTHING=100;
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=4;
f_hi=240;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);

for n=1:length(chan_no)
    data_lfp(n,:)=(data(n,:)-mean(data(n,:)))/std(data(n,:));
    data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
    disp(n)
end
mean_data=mean(data_lfp);
mean_data2=mean_data-mean(mean_data);

for i=1:length(sleep_ind(1:50))
    range(i,:)=round((sleep_ind(i)-times):(sleep_ind(i)+times));
    plot(mean_data2(1,range(i,:))+(i*5));xlim([0 3*times]);
    hold on;
end
xlim([0 3*times]);
title('Sleep Ripples Pre')

filename=['C:\Users\Ganguly VA1\Documents\MATLAB\Tanuj\BMI\S32\Sleep_Pre.tiff'];
saveas(gcf,filename);
Output=length(sleep_ind)

