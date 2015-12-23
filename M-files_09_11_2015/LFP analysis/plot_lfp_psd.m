function plot_lfp_psd(data_pre, data_post, Fs, win, tapers, filename)
% Plots PSD for pre and post-sleep
% Input vectors for data_pre and data_post

time_pre=length(data_pre);
time_post=length(data_post);

if time_pre<time_post
    data_post=data_post(1:time_pre);
else
    data_pre=data_pre(1:time_post);
end

params.tapers=tapers;
params.Fs=Fs;
params.fpass=[0 60];
params.pad=1;
params.err=[2 0.05];
params.trialave=1;

[S1, f1, varS1, C1, Serr1] = mtspectrumsegc(data_pre', win, params, 1);

%plot PSD-pre in blue
fig = figure
hold on 
shadedErrorBar(f1,S1,[Serr1],'b',0);
xlim([0 60]);
set(gca,'YScale','log');

[S2, f2, varS2, C2, Serr2] = mtspectrumsegc(data_post', win, params, 1);

%PSD-post in red
shadedErrorBar(f2,S2,[Serr2],'r',0);
xlim([0 60]);
set(gca,'YScale','log');
xlabel('Frequenzy (Hz)');
ylabel('Power');
title(filename);
hold off

saveas(fig,['D:\MultiSiteLFP_LG\T100\' filename '.tiff']);
