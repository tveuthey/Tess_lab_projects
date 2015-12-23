%%ALL STEPS FOR LFP ANALYSIS, CREATES

close all; clear all;clc;

TankName = 'T104';
numBlocks = 48;
cd ('J:\T104 data and analysis\T104 Blocks')
chan=[1:32]; %number of channels

%%pulling specific channels and ordering them

for n = 1:numBlocks;
% n=1;
   Block_Name = sprintf('Block-%d',n);
   name = sprintf('data_block_%s_%d',TankName,n);

    clearvars -except TankName numBlocks n Block_Name chan name
    load ([name], 'data')

% data=data_1([2 18 22 24 8 10 12 14 11 26 30 32 25 27 29 31 1 3 7 23],:);
% channels to hide for TV M1/M2 recordings: 30,13,15,9,32,26,14,10,16,12,22,18,5,1,21,17,24,20,23,19
% clear TTX Block_Name get_chan chan chan_no TankName clientname servername remove_chan temp temp3 dec_factor

% %% choose and plot channels for VA
% ordVA=[11 13 28];
% dataVA=data(ordVA,:);
% 
% figure;
% for i=1:4
%     subplot(4,1,i); plot(dataVA(i,100000:120000)); hold on
% end

% %% choose and plot channels for striatum
% ordST=[10 12 14];
% dataST=data(ordST,:);
% 
% figure;
% for i=1:3
%     subplot(4,1,i); plot(dataST(i,100000:120000)); hold on
% end

% choose and plot channels for M1
ordM1=[25 27 29 31];
dataM1=data(ordM1,:);

figure;
for i=1:4
    subplot(4,1,i); plot(dataM1(i,100000:120000)); hold on
end

% choose and plot channels for M2
ordM2=[11 28]; %13 and 30 were bad channel
dataM2=data(ordM2,:);

figure;
for i=1:length(ordM2)
    subplot(4,1,i); plot(dataM2(i,100000:120000)); hold on
end

% % choose and plot channels for Occipetal
ordOC=[2 4 6 8];
dataOC=data(ordOC,:);
figure;
for i=1:4
    subplot(4,1,i); plot(dataOC(i,100000:120000)); hold on
end


data1=cat(1,dataM2,dataM1,dataOC);
clear  ordM1 ordM2 ordOC dataM2 dataM1 dataOC data

%% Remove artifacts
% removes data points that are more than 6 STD away

[data2 totalM] = blockMedian(data1);
% [data2 totalM] = blockMedian(data1, 'THRESHOLD', 5); %if wanted to change
% the threshold to other limit
clear totalM

% %% Notch filter (removes 60Hz hum) 
% % Ling and Tanuj only use this on days when the data signal is really bad
% 
% wo = 60/(1000/2); bw = wo/60;
% [b,a] = iirnotch(wo,bw);
% for i=1:size(data2,1)    
%     data3(i,:)=filtfilt(b,a,data2(i,:));
% end
% for j=1:size(rEMG,1)
%     rEMG(j,:)=filtfilt(b,a,rEMG(j,:));
% end
% 
% clear i j a b wo bw



% % ydft = fft(y);
% % xdft = fft(x);
% % freq = 0:(Fs/length(x)):500;
% % subplot(211)
% % plot(freq,abs(xdft(1:501)).^2)
% % subplot(212)
% % plot(freq,abs(ydft(1:501)).^2);

%% Common Mode Rejection (CMR)
% normalize accross channels; subtract mean of all channels from each
% channel

% tmp=data3';
tmp=data2';

for i=1:size(tmp,2)
    tmp2(:,i)=tmp(:,i)-mean(tmp,2);
end
tmp2=tmp2';
clear tmp 
% clear data1 data2 data3


%% diff LFPs (takes a local reference)
% calculate median of all 4 channels in each area and
% subtract channels with greatest median difference 
% if channel2 and channel4 have greatest median different, calculate
% channel2-channel4 and look at that for the rest of the analysis. this
% looks at signal differences within one brain region.

% tmpM2_d=tmp2(2,:)-tmp2(4,:);
median_tmp2=median(tmp2,2);

% M2=tmp2(1:2,:);
tmpM2_d=tmp2(find(median_tmp2==max(median_tmp2(1:2,:))),:)-tmp2(find(median_tmp2==min(median_tmp2(1:2,:))),:);

% tmpST_d=tmp2(5,:)-tmp2(7,:);
% tmpST_d=base_norm(tmpST_d);

%tmpM1_d=base_norm(tmpM1_d);
% tmpM1_d=tmp2(5,:)-tmp2(8,:);
M1=tmp2(3:6,:);
tmpM1_d=tmp2(5,:)-tmp2(8,:);

% tmpM2_d=tmp2(11,:)-tmp2(13,:);
% tmpM2_d=base_norm(tmpM2_d);

%tmpOC_d=base_norm(tmpOC_d);
% tmpOC_d=tmp2(10,:)-tmp2(12,:);
OC=tmp(7:10;:);
tmpOC_d=tmp2(10,:)-tmp2(12,:);

%% PRE (for pre-sleep activity block)
% concatenate data extracted previously from taking local reference. does
% artifact removal again because they are amplified after taking local
% reference

data_full_pre_d_prenorm = cat(1,tmpM2_d,tmpM1_d,tmpOC_d);
clear tmpM2_d tmpM1_d tmpOC_d
[data_full_pre_d totalM] = blockMedian(data_full_pre_d_prenorm);
clear totalM
save data_block_T100_31
%% Plot M1 first to identify epoches (ID slow wave sleep)

[sleep_ind_pre]=find_sleep_indices_cat_BMI(data_full_pre_d, wave, 2,10)
%second to last number is row where data is
%last number is the number of period of slow wave activity

%% concatenates just the slow wave activity

data_SWA_pre_d = cat_LFP_SWA(data_full_pre_d,sleep_ind_pre);
save data_block_T100_31
clear
%% POST (for post-sleep activity block)

data_full_post_d_prenorm=cat(1,tmpM2_d,tmpM1_d,tmpOC_d);
clear tmpVA_d tmpM1_d tmpOC_d
[data_full_post_d totalM] = blockMedian(data_full_post_d_prenorm);
clear totalM
save data_block_T100_33

%%
[sleep_ind_post]=find_sleep_indices_cat_BMI(data_full_post_d, wave, 2,3)

data_SWA_post_d=cat_LFP_SWA(data_full_post_d,sleep_ind_post);

save data_block_T100_33
clear
%% just loading data that you need
clear

load data_block_T100_31 data_SWA_pre_d Fs_lfp
load data_block_T100_33 data_SWA_post_d


%% calculate coherence of slow wave activity
% first 20 minutes
% change_SWA_20 is matrix that reports coherence of A-B regions over
% different frequency bands, both pre and post sleep and the difference
% between the two. this only contains summary data (averaged within each
% frequency band)
% change_swa_20_complete contains all the data point (the bin size of
% averaging is determined by the window and taper) [# #] are tapers, number
% after is window (in s). '_____' is file name for figure for each day
% need to change directory for plot_LFP function (now in that function, but
% should be changed to be in here)
% Change_SWA_Full_Complete has 3 parts to it: C-pre is coherence, Cerr_pre
% is error (aka confidence level, like the std dev. creates error bars),
% and f_pre is the frequency bins. If we want to plot, but C_pre as y and
% f_pre as x-axis. can also add error. this function already outputs a
% plot, but this data can be used to re-plot without having to re-run
% things.
[Change_SWA_20 Change_SWA_20_complete]=plot_LFP_multisite_coherence_VAM1(data_SWA_pre_d(:,1:1220000),data_SWA_post_d(:,1:1220000), Fs_lfp, [3 5],10, 'Day4_SWA_20');
[Change_SWA_Full Change_SWA_Full_complete]=plot_LFP_multisite_coherence_VAM1(data_SWA_pre_d,data_SWA_post_d, Fs_lfp, [3 5],10, 'Day4_SWA_Full');

save data_block_T100_31-33

% clearing data we don't need
clear Change_SWA_20 Change_SWA_20_complete Change_SWA_Full Change_SWA_Full_complete data_SWA_pre_d data_SWA_post_d

%loading just the data we use
load data_block_T100_31 data_full_pre_d
load data_block_T100_33 data_full_post_d

% calculate coherence of slow wave activity for the whole block
% creates 
[Change_Full_20 Change_Full_20_complete]=plot_LFP_multisite_coherence_VAM1(data_full_pre_d(:,1:1220000),data_full_post_d(:,1:1220000), Fs_lfp, [3 5],10, 'Day4_Full_20');
[Change_Full_Full Change_Full_Full_complete]=plot_LFP_multisite_coherence_VAM1(data_full_pre_d,data_full_post_d, Fs_lfp, [3 5],10, 'Day4_Full_Full');

save('data_block_T100_31-33','data_full_pre_d','data_full_post_d','Change_Full_20', 'Change_Full_20_complete', 'Change_Full_Full', 'Change_Full_Full_complete', '-append');

%clear



%% Plot power spectrogram
clear all

load data_block_T100_18-20 data_SWA_pre_d data_SWA_post_d
load data_block_T100_18 Fs_lfp

time_pre=length(data_SWA_pre_d);
time_post=length(data_SWA_post_d);

if time_pre<time_post
    data_SWA_post_d=data_SWA_post_d(:,1:time_pre);
else
    data_SWA_pre_d=data_SWA_pre_d(:,1:time_post);
end

plot_lfp_power_spect_hilb(data_SWA_pre_d(2,:), Fs_lfp, 'Day5_SWA_pre');
plot_lfp_power_spect_hilb(data_SWA_post_d(2,:), Fs_lfp, 'Day5_SWA_post');

% Plot PSDs (PSD = power spectrum density) - summary for whole time period.
% average over whole time period without extracting S

plot_lfp_psd(data_SWA_pre_d, data_SWA_post_d, Fs_lfp, 10, [3 5], 'Day1_PSD');

end
