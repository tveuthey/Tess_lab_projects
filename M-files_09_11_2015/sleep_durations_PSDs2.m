function [Sleep_Pre_Duration, Sleep_Post_Duration, percent_change]= sleep_durations_PSDs2(sleep_ind_pre, sleep_ind_post, data,chan_no, Fs_lfp)
close all
clear pre_tot post_tot
pre_tot=[];
post_tot=[];

for i=1: size(sleep_ind_pre,1)
    sleep_pre=[sleep_ind_pre(i,1):sleep_ind_pre(i,2)];
    pre_tot=[pre_tot sleep_pre];
end

for i=1: size(sleep_ind_post,1)
    sleep_post=[sleep_ind_post(i,1):sleep_ind_post(i,2)];
    post_tot=[post_tot sleep_post];
end


% data=(data(chan_no,:))-mean(data(chan_no,:));
data=median(data)-mean(median(data));
data_pre=data(pre_tot);
data_post=data(post_tot);

%%

params.tapers=[10 19];
params.Fs=Fs_lfp;
params.fpass=[0 20];
params.pad=1;
params.err=[2 0.05];
params.trialave=1;
if (length(pre_tot)> length(post_tot))
    length_trial = length(post_tot)/Fs_lfp;
else 
    length_trial = length(pre_tot)/Fs_lfp;
end
dur=round(10*Fs_lfp);
icount = 0;
for i=1:10:601 
    icount = icount+1;
    pre_tot1(:,icount)=data_pre((i*1001):((i*1001)+9999));
    post_tot1(:,icount)=data_post((i*1001):((i*1001)+9999));
end

% [S1,f1,Serr1] = mtspectrumc( pre_tot1, params );
% movingwin = [

[S1,f1,Serr1] = mtspectrumc( pre_tot1, params );

% plot(f,S,'g', 'LineWidth',3); %figure; 
% hold on; 
shadedErrorBar(f1,S1,[Serr1],'g')
[S2,f2,Serr2] = mtspectrumc( post_tot1, params );
hold on;
% plot(f,S,'r','LineWidth',3);
% hold on; 
shadedErrorBar(f2,S2,[Serr2],'r')
% legend('Pre','Post')
XLim([0 20])
set(gca,'YScale','log')
set(gcf, 'Position', get(0,'Screensize')); 


ind_sws1=find(f1>=0.03,3,'first');
ind_sws2=find(f1<=3.0,3,'last');
ind_sws3=find(f1>=8,3,'first');
ind_sws4=find(f1<=12,3,'last');

pre_swa=max(S1(ind_sws1(1):ind_sws2(end)));
post_swa=max(S2(ind_sws1(1):ind_sws2(end)));
pre_sp=max(S1(ind_sws3(1):ind_sws4(end)));
post_sp=max(S2(ind_sws3(1):ind_sws4(end)));

swa_ch=((post_swa-pre_swa)/pre_swa)/100;
sp_ch=((post_sp-pre_sp)/pre_sp)/100;

percent_change=[swa_ch sp_ch]*10000;

% % filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S23\2_3_13\Pre-F-Post-H PSD.tiff'];
filename= ['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session3\new_Pre-F-Post-H PSD.tiff'];
%       
saveas(gcf,filename)
% 
% 
Sleep_Pre_Duration=round(length(pre_tot)/Fs_lfp);
Sleep_Post_Duration=round(length(post_tot)/Fs_lfp);



