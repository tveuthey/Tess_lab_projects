function [Output]=plot_BMIneurons_ISI_distributions(TimeStamps, chan_no,data,sleep_ind_pre,sleep_ind_post,wave,Fs_lfp,Waves,N,sc,bin_size,space)
% close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

times=0.5*Fs_lfp;

% FILTER_ORDER=4;
% END_SMOOTHING=100;
% srate = Fs_lfp;
% nyq_sample=srate/2;
% f_lo=1;
% f_hi=100;
% [b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
% clear final_ind
% final_ind=[];
for n=chan_no
    data_lfp(n,:)=(data(n,:)-mean(data(n,:)))/(2*std(data(n,:)));
    %     data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
end
% ind=find(data_lfpfilt>(-4.5*(std(data_lfpfilt))));

sleep_ind2=sleep_ind_pre;
sleep_ind2p=sleep_ind_post;
pre_sleep=sleep_ind2(1):sleep_ind2(end);
range_pre=round(pre_sleep/Fs_lfp);
post_sleep=sleep_ind2p(1):sleep_ind2p(end);
range_post=round(post_sleep/Fs_lfp);
 tstamps1=TimeStamps{chan_no,sc};
             
                    ts_range_pre=tstamps1(range_pre);
                    ts_range_post=tstamps1(range_post);
                   
                    subplot(1,2,1)
                    bar(histc(diff(ts_range_pre),[0.005:0.001:0.100]),'b','Linewidth',0.5);
                    subplot(1,2,2)
                    bar(histc(diff(ts_range_post),[0.005:0.001:0.100]),'r','Linewidth',0.5);
Output=ts_range_pre;

