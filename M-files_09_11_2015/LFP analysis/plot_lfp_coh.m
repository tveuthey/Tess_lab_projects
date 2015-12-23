function plot_lfp_coh(data_pre, data_post, Fs, win, tapers, session)
% plot coherence spectrograms for M1-VA for both pre and post sleep
% input M1 data in row 2 and VA in row 1 of matrix in data_pre and data_post
% Fs=Fs_lfp
% win = [2 0.125]
% tapers = [3 5]
% session = string of testing day e.g. 'Day1'
% change saving directory if necessary

time_pre=length(data_pre);
time_post=length(data_post);

if time_pre<time_post
    data_post=data_post(:,1:time_pre);
else
    data_pre=data_pre(:,1:time_post);
end

data_pre=data_pre';
data_post=data_post';

params.tapers=tapers;
params.Fs=Fs;
params.fpass=[0 60];
params.pad=1;
params.err=[2 0.05];
params.trialave=1;

%plot coh spectrogram for pre-sleep
[C1,phi1,S121,S11,S21,t1,f1,confC1,phistd1,Cerr1]=cohgramc(data_pre(:,2),data_pre(:,1),win,params);

figure
fig1 = imagesc(t1, f1, C1');
set(gca,'YDir','norm');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title([session ' SWA pre M1-VA Coh']);
saveas(fig1, ['D:\MultiSiteLFP_LG\T100\' session 'SWA_pre_M1-VA_coh.tiff']);

%plot coh spectrogram for post-sleep
[C2,phi2,S122,S12,S22,t2,f2,confC2,phistd2,Cerr2]=cohgramc(data_post(:,2),data_post(:,1),win,params);

figure
fig2 = imagesc(t2, f2, C2');
set(gca,'YDir','norm');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title([session ' SWA post M1-VA Coh']);
saveas(fig2, ['D:\MultiSiteLFP_LG\T100\' session 'SWA_post_M1-VA_coh.tiff']);
