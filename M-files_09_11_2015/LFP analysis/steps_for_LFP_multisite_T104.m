%%pulling specific channels and ordering them
close all
% data=data_1([2 18 22 24 8 10 12 14 11 26 30 32 25 27 29 31 1 3 7 23],:);
clear TTX Block_Name get_chan chan chan_no TankName clientname servername remove_chan temp temp3 dec_factor

% extract data from 1 brain region and concatenate data
ordVA=[2 4 22 24];
dataVA=data(ordVA,:);

figure;
for i=1:4
    subplot(4,1,i); plot(dataVA(i,100000:120000)); hold on
end

% ordST=[10 12 14];
% dataST=data(ordST,:);
% 
% figure;
% for i=1:3
%     subplot(4,1,i); plot(dataST(i,100000:120000)); hold on
% end


ordM1=[1 7 21 23];
dataM1=data(ordM1,:);

figure;
for i=1:4
    subplot(4,1,i); plot(dataM1(i,100000:120000)); hold on
end

% ordM2=[25 27 29];
% dataM2=data(ordM2,:);
% 
% figure;
% for i=1:3
%     subplot(4,1,i); plot(dataM2(i,100000:120000)); hold on
% end

ordOC=[26 28 30 32];
dataOC=data(ordOC,:);
figure;
for i=1:4
    subplot(4,1,i); plot(dataOC(i,100000:120000)); hold on
end

% concatenate all the channels
data1=cat(1,dataVA,dataM1,dataOC);
% data2= data1([],:)

%% Notch filter

wo = 60/(1000/2); bw = wo/60;
[b,a] = iirnotch(wo,bw);
for i=1:size(data1,1)    
    data3(i,:)=filtfilt(b,a,data1(i,:));
end
for j=1:size(rEMG,1)
    rEMG(j,:)=filtfilt(b,a,rEMG(j,:));
end

clear i j a b wo bw



% ydft = fft(y);
% xdft = fft(x);
% freq = 0:(Fs/length(x)):500;
% subplot(211)
% plot(freq,abs(xdft(1:501)).^2)
% subplot(212)
% plot(freq,abs(ydft(1:501)).^2);

%% CMR

clear  ordM1 ordVA ordOC dataVA dataM1 dataOC

tmp=data3';
%tmp=data1';

for i=1:size(tmp,2)
    tmp2(:,i)=tmp(:,i)-mean(tmp,2);
end
%tmp2=tmp2';
clear tmp 
clear data1 data3


%% diff LFPs

tmp_norm=zscore(tmp2)';
tmpVA_d=tmp2(3,:)-tmp2(4,:);

% tmpST_d=tmp2(5,:)-tmp2(7,:);
% tmpST_d=base_norm(tmpST_d);

%tmpM1_d=base_norm(tmpM1_d);
tmpM1_d=tmp2(5,:)-tmp2(7,:);

% tmpM2_d=tmp2(11,:)-tmp2(13,:);
% tmpM2_d=base_norm(tmpM2_d);

%tmpOC_d=base_norm(tmpOC_d);
tmpOC_d=tmp2(9,:)-tmp2(12,:);

%% PRE

data_full_pre_d=cat(1,tmpVA_d,tmpM1_d,tmpOC_d);
clear tmpVA_d tmpM1_d tmpOC_d
save data_block_T100_34
%% Plot M1 first to identify epoches

[sleep_ind_pre]=find_sleep_indices_cat_BMI(data_full_pre_d, wave, 2,10)

%%


[data_SWA_pre_d, data_full_pre_d]=cat_LFP_SWA(data_full_pre_d,sleep_ind_pre);
save data_block_T100_34
clear
%% POST

data_full_post_d=cat(1,tmpVA_d,tmpM1_d,tmpOC_d);
clear tmpVA_d tmpM1_d tmpOC_d
save data_block_T100_37

%%
[sleep_ind_post]=find_sleep_indices_cat_BMI(data_full_post_d, wave, 2,8)

[data_SWA_post_d, data_full_post_d]=cat_LFP_SWA(data_full_post_d,sleep_ind_post);

save data_block_T100_37
clear
%%
clear

load data_block_T100_34 data_SWA_pre_d data_full_pre_d
load data_block_T100_37 data_SWA_post_d data_full_post_d


%%

[Change_SWA_20]=plot_LFP_multisite_coherence_VAM1(data_SWA_pre_d(:,1:1220000),data_SWA_post_d(:,1:1220000), 1017, [3 5],10, 'Day5_SWA_20');
[Change_SWA_Full]=plot_LFP_multisite_coherence_VAM1(data_SWA_pre_d,data_SWA_post_d, 1017, [3 5],10, 'Day5_SWA_Full');

[Change_Full_20]=plot_LFP_multisite_coherence_VAM1(data_full_pre_d(:,1:1220000),data_full_post_d(:,1:1220000), 1017, [3 5],10, 'Day5_Full_20');
[Change_Full_Full]=plot_LFP_multisite_coherence_VAM1(data_full_pre_d,data_full_post_d, 1017, [3 5],10, 'Day5_Full_Full');

save data_block_T100_34-37

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


